#!/usr/bin/env bash
set -euo pipefail

readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly INSTALLER_URL="https://install.determinate.systems/nix"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m!!\033[0m %s\n' "$*" >&2; }

usage() {
  cat <<EOF
Usage: $0 <host>

Bootstrap script for kugeke's dotfiles (macOS Apple Silicon).
  1. Install Nix via Determinate Systems installer (skipped if present)
  2. Backup existing /etc/{zshrc,bashrc,zshenv} to *.before-nix-darwin
  3. Apply nix-darwin configuration: darwin-rebuild switch --flake .#<host>

<host> は hosts/<host>/default.nix が存在する名前（fragments は除外）。
現在のディレクトリ:
EOF
  local d name
  for d in "${DOTFILES_DIR}/hosts"/*/; do
    [[ -d $d ]] || continue
    name="$(basename "$d")"
    [[ $name == "fragments" ]] && continue
    [[ -f "${d}default.nix" ]] && printf '  - %s\n' "$name"
  done | sort
}

# Apple Silicon Homebrew (`/opt/homebrew`) は現ユーザー所有が前提。
# 旧 Intel Homebrew からの移行や root 経由のインストール跡で subdir が
# root 所有になっていると `brew install pyenv` 等が permission error で落ちる
# (例: "/opt/homebrew/share is not writable")。
# 起動毎に find で 1 件でも他所有を検出したら sudo chown で一括修復する。
# `/opt/homebrew` が無い (Nix 初回 install 前) ホストでは何もしない。
# `SKIP_HOMEBREW_OWNERSHIP_CHECK=1` で skip 可。
ensure_homebrew_ownership() {
  [[ ${SKIP_HOMEBREW_OWNERSHIP_CHECK:-} == "1" ]] && return 0
  [[ -d /opt/homebrew ]] || return 0
  local me offender
  me="$(id -un)"
  offender="$(find /opt/homebrew -not -user "$me" -print -quit 2>/dev/null || true)"
  if [[ -n $offender ]]; then
    err "/opt/homebrew に $me 以外が所有するパスを検出: $offender"
    log "sudo chown -R $me:admin /opt/homebrew で所有権を修復します"
    sudo chown -R "$me":admin /opt/homebrew
  fi
}

main() {
  local host="${1:-}"
  case "$host" in
  -h | --help | "")
    usage
    exit 1
    ;;
  esac

  if [[ $host == "fragments" ]] || [[ ! -f "${DOTFILES_DIR}/hosts/${host}/default.nix" ]]; then
    err "unknown host: ${host:-empty} (hosts/${host:-?}/default.nix が無い、または fragments はホストにできません)"
    usage
    exit 1
  fi

  if ! command -v nix >/dev/null 2>&1; then
    log "Installing Nix via Determinate Systems installer"
    curl --proto '=https' --tlsv1.2 -sSf -L "$INSTALLER_URL" | sh -s -- install
    err "Nix installed. Open a new shell and re-run: $0 $host"
    exit 0
  fi

  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  local f
  for f in /etc/zshrc /etc/bashrc /etc/zshenv; do
    if [[ -f $f && ! -L $f ]] && ! grep -q "nix-darwin" "$f"; then
      log "Backing up $f -> $f.before-nix-darwin.$ts"
      sudo mv "$f" "$f.before-nix-darwin.$ts"
    fi
  done

  ensure_homebrew_ownership

  log "Applying nix-darwin configuration for host: $host"
  if command -v darwin-rebuild >/dev/null 2>&1; then
    darwin-rebuild switch --flake "${DOTFILES_DIR}#${host}"
  else
    sudo nix run nix-darwin -- switch --flake "${DOTFILES_DIR}#${host}"
  fi

  # 初回 LazyVim プラグインの prefetch (任意)
  # 初回の `nvim` 起動を速くするため、ここで LazyVim のプラグインを headless で
  # 一括ダウンロードしておく。スキップしたい場合は SKIP_LAZY_PREINSTALL=1 を付与。
  if [[ ${SKIP_LAZY_PREINSTALL:-} != "1" ]] && command -v nvim >/dev/null 2>&1; then
    log "Pre-installing LazyVim plugins (Ctrl-C で中断可、SKIP_LAZY_PREINSTALL=1 で次回スキップ)"
    nvim --headless "+Lazy! sync" +qa || true
  fi

  log "Done. Open a new shell to use the new environment."
}

main "$@"
