{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Kenjiro Kuge";
    # userEmail は modules/home/profiles/{personal,work}.nix で設定

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      color.ui = "auto";
      rebase.autosquash = true;
      rerere.enabled = true;
    };

    aliases = {
      st = "status -sb";
      co = "checkout";
      sw = "switch";
      br = "branch";
      ci = "commit";
      cm = "commit -m";
      lg = "log --oneline --graph --decorate --all";
      last = "log -1 HEAD --stat";
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
