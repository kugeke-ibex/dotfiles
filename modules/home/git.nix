{ ... }:
{
  programs.git = {
    enable = true;

    # 最新 home-manager では programs.git.{userName, userEmail, aliases, extraConfig}
    # は deprecated。すべて `programs.git.settings.*` に統合された。
    # email はホスト profile (modules/home/profiles/{personal,work}.nix) で上書きする。
    settings = {
      user.name = "Kenjiro Kuge";

      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      color.ui = "auto";
      rebase.autosquash = true;
      rerere.enabled = true;

      alias = {
        st = "status -sb";
        co = "checkout";
        sw = "switch";
        br = "branch";
        ci = "commit";
        cm = "commit -m";
        lg = "log --oneline --graph --decorate --all";
        last = "log -1 HEAD --stat";
      };
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".idea/"
      ".vscode/"
      ".direnv/"
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.lazygit.enable = true;
}
