#!/usr/bin/env bash
set -euo pipefail

readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly INSTALLER_URL="https://install.determinate.systems/nix"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m!!\033[0m %s\n' "$*" >&2; }

usage() {
  cat <<EOF
Usage: $0 <personal|work>

Bootstrap script for kugeke's dotfiles (macOS Apple Silicon).
  1. Install Nix via Determinate Systems installer (skipped if present)
  2. Backup existing /etc/{zshrc,bashrc,zshenv} to *.before-nix-darwin
  3. Apply nix-darwin configuration: darwin-rebuild switch --flake .#<host>
EOF
}

main() {
  local host="${1:-}"
  case "$host" in
    personal|work) ;;
    -h|--help|"") usage; exit 1 ;;
    *) err "invalid host: $host"; usage; exit 1 ;;
  esac

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
    if [[ -f "$f" && ! -L "$f" ]] && ! grep -q "nix-darwin" "$f"; then
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

  log "Done. Open a new shell to use the new environment."
}

main "$@"
