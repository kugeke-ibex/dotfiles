# AI コーディングエージェント用ランチャ（cmux 風の「専用ターミナル」体験を
# WezTerm / Ghostty / cmux 共通で、宣言管理のまま実現する土台）。
#
# 方針:
# - claude / codex / gemini 本体を薄くラップし、起動時にターミナルのタイトルを
#   "🤖 <agent> · <branch>" に設定する（どのタブがどのエージェントか一目で分かる）。
#   → cmux の「垂直タブに状態表示」を、端末クロムではなく OSC タイトルで再現。
# - WezTerm では SetUserVar も送り、タブタイトル（modules/status.lua）に
#   エージェント名と git ブランチを表示する。
# - Ghostty / cmux では OSC 0 のウィンドウ/タブタイトルとして反映される。
# - キーバインドからの起動は各ターミナル側（Ghostty: config, WezTerm: modules/agents.lua）
#   が `claude` / `codex` / `gemini` を送信して、この関数ラッパを踏む。

# 現在の git ブランチ（repo 外なら空文字）
_ai_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# OSC 0: ウィンドウ/タブタイトル（WezTerm・Ghostty・cmux 共通）
_ai_set_title() {
  printf '\033]0;%s\007' "$1"
}

# WezTerm SetUserVar（WezTerm 以外の端末では無視される）
_ai_set_uservar() {
  [[ "$TERM_PROGRAM" == "WezTerm" ]] || return 0
  printf '\033]1337;SetUserVar=%s=%s\007' "$1" "$(printf '%s' "$2" | base64)"
}

# エージェント起動の共通ラッパ: ラベル付けしてから実コマンドを実行
#   $1        表示ラベル (claude/codex/gemini)
#   $2..      実際に実行するコマンド (command claude ... など)
_ai_launch() {
  local label="$1"
  shift
  local branch
  branch="$(_ai_git_branch)"
  local title="🤖 ${label}"
  [[ -n "$branch" ]] && title="${title} · ${branch}"
  _ai_set_title "$title"
  _ai_set_uservar agent "$label"
  "$@"
}

# 本体が入っている環境でだけ関数ラップする（未導入ホストでは素の PATH 解決に任せる）。
# `command <name>` で実体を呼ぶことで関数の無限再帰を避ける。
if command -v claude >/dev/null 2>&1; then
  claude() { _ai_launch claude command claude "$@"; }
fi
if command -v codex >/dev/null 2>&1; then
  codex() { _ai_launch codex command codex "$@"; }
fi
if command -v gemini >/dev/null 2>&1; then
  gemini() { _ai_launch gemini command gemini "$@"; }
fi

# ディスパッチャ: ai claude|codex|gemini [args...]
ai() {
  local agent="${1:-}"
  (( $# > 0 )) && shift
  case "$agent" in
    claude) claude "$@" ;;
    codex) codex "$@" ;;
    gemini) gemini "$@" ;;
    *)
      print -u2 "usage: ai {claude|codex|gemini} [args...]"
      return 1
      ;;
  esac
}

# WezTerm: precmd で git ブランチを SetUserVar（タブタイトル表示用）。
# エージェントを起動していない通常タブでも、そのタブのブランチが見えるようにする。
if [[ "$TERM_PROGRAM" == "WezTerm" ]] && [[ -o interactive ]]; then
  _ai_branch_precmd() { _ai_set_uservar git_branch "$(_ai_git_branch)"; }
  if (( ! ${precmd_functions[(Ie)_ai_branch_precmd]} )); then
    precmd_functions+=(_ai_branch_precmd)
  fi
fi
