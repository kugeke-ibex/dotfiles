# 全社用 PC（profile=work）で共通の zsh エイリアス / 関数。
# modules/home/profiles/work.nix の initContent から source される。
# raw zsh なので ${AWS_PROFILE} 等の実行時展開シェル変数をそのまま書ける。
#
# マシン固有（プロジェクトパス・特定の AWS profile / プロジェクト切替など）は
# config/zsh/host-<hostname>.zsh に書く（例: host-work.zsh / host-work-office.zsh）。
# 個人 PC 専用は config/zsh/personal.zsh。汎用は config/zsh/common.zsh。

# ----------------------------------------------------
# Dotfiles ショートカット
# ----------------------------------------------------
alias dotfiles='cd ~/Development/dotfiles && nvim'

# ----------------------------------------------------
# 例: 社用共通で使うツール alias をここに集約する
# （全社用 PC で同じプロジェクト構成・同じ AWS profile 体系のものだけ）
# ----------------------------------------------------
# alias k='kubectl'
# alias tf='terraform fmt --recursive'
# alias tfplan='aws-vault exec ${AWS_PROFILE} -- terraform plan'
# alias tfapply='aws-vault exec ${AWS_PROFILE} -- terraform apply'
