# Login shell (.zprofile) — personal Mac
# pyenv はここでは初期化しない (brew の pyenv + config/zsh/common.zsh の lazy init)。
# PYENV_ROOT は home-manager の sessionVariables (profiles/personal.nix) で設定。

# macOS: launchd の soft maxfiles は 256 になりがち。zeno / Nix 等で枯渇するため先に引き上げる。
if [[ "$(uname -s)" == Darwin ]]; then
  ulimit -n 65536 2>/dev/null || ulimit -n 10240 2>/dev/null || true
  /bin/launchctl limit maxfiles 65536 200000 2>/dev/null || true
fi

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] \
  && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"

# nodebrew
export PATH="$HOME/.nodebrew/current/bin:$PATH"
export NODE_PATH="$HOME/.nodebrew/node/v16.13.1/lib/node_modules/"

# ssh-agent (既存エージェントが無ければ起動)
if [ -z "$SSH_AUTH_SOCK" ]; then
  RUNNING_AGENT="$(ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]')"
  if [ "$RUNNING_AGENT" = "0" ]; then
    ssh-agent -s &>"$HOME/.ssh/kugeke_id_ed25519"
  fi
  eval "$(cat "$HOME/.ssh/kugeke_id_ed25519")"
fi

# OrbStack: command-line tools and integration
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] \
  && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
