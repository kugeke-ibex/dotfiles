# 社用 PC「work-office」固有の zsh エイリアス / 関数。
# modules/home/profiles/work.nix が flake の hostname=="work-office" のとき source する
# （host-${hostname}.zsh）。社用共通分は config/zsh/work-common.zsh。
# raw zsh なので ${AWS_PROFILE} 等の実行時展開シェル変数をそのまま書ける。

# ----------------------------------------------------
# 例: このマシン固有のプロジェクトパス・認証切替など
# ----------------------------------------------------
# alias proj='cd ~/Development/<office-project>'
# alias awsdev='export AWS_PROFILE=<office>-dev'
# alias awsprd='export AWS_PROFILE=<office>-prd'
