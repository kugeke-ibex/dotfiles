# 個人 PC 専用の zsh エイリアス / 関数。
# modules/home/profiles/personal.nix の initExtra から source される。
# raw zsh で書くと ${AWS_PROFILE} など実行時展開のシェル変数をそのまま記述できる。

# ----------------------------------------------------
# Dotfiles ショートカット
# ----------------------------------------------------
alias dotfiles='cd ~/Development/dotfiles && nvim'

# ----------------------------------------------------
# Volta (Node.js manager): インストール済みの Node.js を削除
# ----------------------------------------------------
remove_node_for_volta() {
  local package="$1"
  local dir="$HOME/.volta/tools/image/node/$package/"
  if [ -d "$dir" ]; then
    if rm -rf "$dir"; then
      echo "Successfully removed $package"
    else
      echo "Failed to remove $package"
    fi
  else
    echo "Not found $package"
  fi
}

# ----------------------------------------------------
# SSH key
# ----------------------------------------------------
alias sakuge_ed="ssh-add -K ~/.ssh/kugeke_id_ed25519_2"

# ----------------------------------------------------
# CloudPratica: AWS 認証情報切替
# ----------------------------------------------------
alias cpstg='export ENV=stg && export AWS_ACCOUNT_ID=700526300827 && export AWS_PROFILE=cp-terraform-stg'
alias cpprd='export ENV=prd && export AWS_ACCOUNT_ID=871399318936 && export AWS_PROFILE=cp-terraform-prd'

# ----------------------------------------------------
# CloudPratica: コスト最適化スクリプト (起動 / 停止)
# ----------------------------------------------------
alias cpstgup='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=up ENV=stg ./scripts/aws_cost_cutter/main.sh'
alias cpstgdown='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=down ENV=stg ./scripts/aws_cost_cutter/main.sh'
alias cpstgupeks='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=up ENV=stg WITH_EKS=true WITH_ECS=false ./scripts/aws_cost_cutter/main.sh'
alias cpstgdowneks='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=down ENV=stg ./scripts/aws_cost_cutter/main.sh'
alias cpprdup='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-prd MODE=up ENV=prd ./scripts/aws_cost_cutter/main.sh'
alias cpprddown='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-prd MODE=down ENV=prd ./scripts/aws_cost_cutter/main.sh'
alias cpprdupeks='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-prd MODE=up ENV=prd WITH_EKS=true WITH_ECS=false ./scripts/aws_cost_cutter/main.sh'
alias cpprddowneks='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-prd MODE=down ENV=prd ./scripts/aws_cost_cutter/main.sh'
alias cpstgssmdbconn='~/scrips/port_forward_to_cloud_pratica_stg.sh'
alias cpprdssmdbconn='~/scrips/port_forward_to_cloud_pratica_prd.sh'
alias ddup='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=up ENV=stg ./scripts/dd_course_cost_cutter/main.sh'
alias dddown='cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=down ENV=stg ./scripts/dd_course_cost_cutter/main.sh'

# ----------------------------------------------------
# Terraform
# ----------------------------------------------------
alias tf='terraform fmt --recursive'
alias tfimport='aws-vault exec ${AWS_PROFILE} terraform import'
alias tfrefresh='aws-vault exec ${AWS_PROFILE} -- terraform refresh'
alias tfinit='aws-vault exec ${AWS_PROFILE} -- terraform init'
alias tfplan='aws-vault exec ${AWS_PROFILE} -- terraform plan'
alias tfapply='aws-vault exec ${AWS_PROFILE} -- terraform apply'
alias tfslist='aws-vault exec ${AWS_PROFILE} -- terraform state list'
alias tfplang='aws-vault exec ${AWS_PROFILE} -- terraform plan -generate-config-out=tmp.tf'
alias tui='aws-vault exec ${AWS_PROFILE} -- tftui'

# Terraform state operations (引数を取るので関数で)
tfsshow() {
  aws-vault exec "${AWS_PROFILE}" -- terraform state show "$1"
}
tfsmv() {
  aws-vault exec "${AWS_PROFILE}" -- terraform state mv "$1" "$2"
}
tfsrm() {
  aws-vault exec "${AWS_PROFILE}" -- terraform state rm "$1"
}

# Terraform module skeleton (aws / gcp)
tnma() {
  local base_dir=~/Development/CloudPratica/cloud-pratica-terraform/modules/aws
  mkdir -p "$base_dir/$1" \
    && touch "$base_dir/$1/main.tf" "$base_dir/$1/variables.tf" "$base_dir/$1/outputs.tf"
}
tnmg() {
  local base_dir=~/Development/CloudPratica/cloud-pratica-terraform/modules/gcp
  mkdir -p "$base_dir/$1" \
    && touch "$base_dir/$1/main.tf" "$base_dir/$1/variables.tf" "$base_dir/$1/outputs.tf"
}

# Terraform plan / apply に複数の -target=module.X を渡す
tfplantm() {
  aws-vault exec "${AWS_PROFILE}" -- terraform plan $(printf -- "-target=module.%s " "$@")
}
tfapplytm() {
  aws-vault exec "${AWS_PROFILE}" -- terraform apply $(printf -- "-target=module.%s " "$@")
}

# Terraform output (引数なしで全件 / 引数ありで特定 output)
tfoutput() {
  if [ -z "$1" ]; then
    aws-vault exec "${AWS_PROFILE}" -- terraform output -json
  else
    aws-vault exec "${AWS_PROFILE}" -- terraform output -json "$1"
  fi
}

# ----------------------------------------------------
# ecspresso
# ----------------------------------------------------
alias ecspinit='aws-vault exec ${AWS_PROFILE} -- ecspresso init'
alias ecspregister='aws-vault exec ${AWS_PROFILE} -- ecspresso register'
alias ecsprun='aws-vault exec ${AWS_PROFILE} -- ecspresso run'
alias ecspdeploy='aws-vault exec ${AWS_PROFILE} -- ecspresso deploy'
alias ecspverify='aws-vault exec ${AWS_PROFILE} -- ecspresso verify'
alias ecsprender='aws-vault exec ${AWS_PROFILE} -- ecspresso render'
alias ecspdiff='aws-vault exec ${AWS_PROFILE} -- ecspresso diff'
alias ecspexec='aws-vault exec ${AWS_PROFILE} -- ecspresso exec'

# ----------------------------------------------------
# Kubernetes
# ----------------------------------------------------
alias k='kubectl'
alias ak='aws-vault exec ${AWS_PROFILE} -- kubectl'
alias k9='aws-vault exec ${AWS_PROFILE} -- k9s'
alias h='helm'
alias ah='aws-vault exec ${AWS_PROFILE} -- helm'
alias kdb='aws-vault exec ${AWS_PROFILE} -- sh ~/Development/CloudPratica/CI_CD/cloud-pratica-backend/ops/kubernetes/eks/kubernetes-dashboard/scripts/start.sh'
alias aisc='aws-vault exec ${AWS_PROFILE} -- istioctl'

# ----------------------------------------------------
# gcloud
# ----------------------------------------------------
alias gc='gcloud'
alias gccl='gcloud config configurations list'
alias gaal='gcloud auth application-default login'
alias gcsp='cloud-sql-proxy --port 35432 cp-kengol-stg:asia-northeast1:cloud-pratica-stg'
alias gcpup='cd ~/Development/CloudPratica/cloud-pratica-backend && PROJECT=cp-kengol-stg MODE=up ./scripts/gcp_cost_cutter/main.sh'
alias gcpdown='cd ~/Development/CloudPratica/cloud-pratica-backend && PROJECT=cp-kengol-stg MODE=down ./scripts/gcp_cost_cutter/main.sh'
alias gcssh='gcloud compute ssh --zone "asia-northeast1-a" "bastion-stg" --tunnel-through-iap --project "cp-kengol-stg"'
