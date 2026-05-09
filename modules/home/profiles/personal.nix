{ ... }:
{
  programs.git.userEmail = "kugetyan0211@gmail.com";

  # 個人 PC 専用の zsh エイリアス。
  # `aws-vault exec ${AWS_PROFILE} -- ...` 形式の alias は、 alias 実行時に
  # zsh で AWS_PROFILE を展開させたいので Nix 側では `\${AWS_PROFILE}` でエスケープする。
  programs.zsh.shellAliases = {
    # SSH key
    sakuge_ed = "ssh-add -K ~/.ssh/kugeke_id_ed25519_2";

    # CloudPratica AWS 認証情報切替
    cpstg = "export ENV=stg && export AWS_ACCOUNT_ID=700526300827 && export AWS_PROFILE=cp-terraform-stg";
    cpprd = "export ENV=prd && export AWS_ACCOUNT_ID=871399318936 && export AWS_PROFILE=cp-terraform-prd";

    # CloudPratica コスト最適化スクリプト (起動 / 停止)
    cpstgup = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=up ENV=stg ./scripts/aws_cost_cutter/main.sh";
    cpstgdown = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=down ENV=stg ./scripts/aws_cost_cutter/main.sh";
    cpstgupeks = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=up ENV=stg WITH_EKS=true WITH_ECS=false ./scripts/aws_cost_cutter/main.sh";
    cpstgdowneks = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=down ENV=stg ./scripts/aws_cost_cutter/main.sh";
    cpprdup = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-prd MODE=up ENV=prd ./scripts/aws_cost_cutter/main.sh";
    cpprddown = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-prd MODE=down ENV=prd ./scripts/aws_cost_cutter/main.sh";
    cpprdupeks = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-prd MODE=up ENV=prd WITH_EKS=true WITH_ECS=false ./scripts/aws_cost_cutter/main.sh";
    cpprddowneks = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-prd MODE=down ENV=prd ./scripts/aws_cost_cutter/main.sh";
    cpstgssmdbconn = "~/scrips/port_forward_to_cloud_pratica_stg.sh";
    cpprdssmdbconn = "~/scrips/port_forward_to_cloud_pratica_prd.sh";
    ddup = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=up ENV=stg ./scripts/dd_course_cost_cutter/main.sh";
    dddown = "cd ~/Development/CloudPratica/cloud-pratica-backend && AWS_PROFILE=cp-terraform-stg MODE=down ENV=stg ./scripts/dd_course_cost_cutter/main.sh";

    # Terraform
    tf = "terraform fmt --recursive";
    tfimport = "aws-vault exec \${AWS_PROFILE} terraform import";
    tfrefresh = "aws-vault exec \${AWS_PROFILE} -- terraform refresh";
    tfinit = "aws-vault exec \${AWS_PROFILE} -- terraform init";
    tfplan = "aws-vault exec \${AWS_PROFILE} -- terraform plan";
    tfapply = "aws-vault exec \${AWS_PROFILE} -- terraform apply";
    tfslist = "aws-vault exec \${AWS_PROFILE} -- terraform state list";
    tfplang = "aws-vault exec \${AWS_PROFILE} -- terraform plan -generate-config-out=tmp.tf";

    # terraform-tui
    tui = "aws-vault exec \${AWS_PROFILE} -- tftui";

    # ecspresso
    ecspinit = "aws-vault exec \${AWS_PROFILE} -- ecspresso init";
    ecspregister = "aws-vault exec \${AWS_PROFILE} -- ecspresso register";
    ecsprun = "aws-vault exec \${AWS_PROFILE} -- ecspresso run";
    ecspdeploy = "aws-vault exec \${AWS_PROFILE} -- ecspresso deploy";
    ecspverify = "aws-vault exec \${AWS_PROFILE} -- ecspresso verify";
    ecsprender = "aws-vault exec \${AWS_PROFILE} -- ecspresso render";
    ecspdiff = "aws-vault exec \${AWS_PROFILE} -- ecspresso diff";
    ecspexec = "aws-vault exec \${AWS_PROFILE} -- ecspresso exec";

    # Kubernetes
    k = "kubectl";
    ak = "aws-vault exec \${AWS_PROFILE} -- kubectl";
    k9 = "aws-vault exec \${AWS_PROFILE} -- k9s";
    h = "helm";
    ah = "aws-vault exec \${AWS_PROFILE} -- helm";
    kdb = "aws-vault exec \${AWS_PROFILE} -- sh ~/Development/CloudPratica/CI_CD/cloud-pratica-backend/ops/kubernetes/eks/kubernetes-dashboard/scripts/start.sh";
    aisc = "aws-vault exec \${AWS_PROFILE} -- istioctl";

    # gcloud
    gc = "gcloud";
    gccl = "gcloud config configurations list";
    gaal = "gcloud auth application-default login";
    gcsp = "cloud-sql-proxy --port 35432 cp-kengol-stg:asia-northeast1:cloud-pratica-stg";
    gcpup = "cd ~/Development/CloudPratica/cloud-pratica-backend && PROJECT=cp-kengol-stg MODE=up ./scripts/gcp_cost_cutter/main.sh";
    gcpdown = "cd ~/Development/CloudPratica/cloud-pratica-backend && PROJECT=cp-kengol-stg MODE=down ./scripts/gcp_cost_cutter/main.sh";
    gcssh = "gcloud compute ssh --zone \"asia-northeast1-a\" \"bastion-stg\" --tunnel-through-iap --project \"cp-kengol-stg\"";
  };

  # 引数を取る Terraform 用関数群。alias の `(){...}` ハックは Nix では書きにくいので
  # zsh function として initExtra で定義する。
  programs.zsh.initExtra = ''
    # Terraform state operations
    tfsshow() {
      aws-vault exec "''${AWS_PROFILE}" -- terraform state show "$1"
    }
    tfsmv() {
      aws-vault exec "''${AWS_PROFILE}" -- terraform state mv "$1" "$2"
    }
    tfsrm() {
      aws-vault exec "''${AWS_PROFILE}" -- terraform state rm "$1"
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
      aws-vault exec "''${AWS_PROFILE}" -- terraform plan $(printf -- "-target=module.%s " "$@")
    }
    tfapplytm() {
      aws-vault exec "''${AWS_PROFILE}" -- terraform apply $(printf -- "-target=module.%s " "$@")
    }

    # Terraform output (引数なしで全件 / 引数ありで特定 output)
    tfoutput() {
      if [ -z "$1" ]; then
        aws-vault exec "''${AWS_PROFILE}" -- terraform output -json
      else
        aws-vault exec "''${AWS_PROFILE}" -- terraform output -json "$1"
      fi
    }
  '';
}
