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
