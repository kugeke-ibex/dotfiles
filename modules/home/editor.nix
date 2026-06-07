{
  pkgs,
  config,
  inputs,
  dotfilesRelative,
  profile,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
  neovimPkg =
    if profile == "work" then
      pkgs.neovim
    else
      inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
in
{
  # Neovim 本体: work は nixpkgs 安定版（flake update の影響を狭める）、personal は nightly。
  home.packages = with pkgs; [
    neovimPkg

    # LazyVim / Mason / treesitter / Lua LSP が必要とする補助ツール
    tree-sitter
    nodejs_22
    stylua
    shellcheck
    shfmt
    nixfmt-rfc-style
  ];

  # LazyVim 設定 (~/.config/nvim/) を dotfiles から live symlink。
  # mkOutOfStoreSymlink を使うので dotfiles 編集が即時反映される (rebuild 不要)。
  xdg.configFile = {
    "nvim/init.lua".source = mkLink "config/nvim/init.lua";
    "nvim/lua".source = mkLink "config/nvim/lua";
    # lazy-lock.json も live symlink。:Lazy sync が dotfiles 内の lock を直接更新するので
    # git diff で版を確認してコミットできる（複数 Mac でプラグイン版を固定するため）。
    "nvim/lazy-lock.json".source = mkLink "config/nvim/lazy-lock.json";
    "nvim/ftdetect".source = mkLink "config/nvim/ftdetect";
    "nvim/spell".source = mkLink "config/nvim/spell";
    "nvim/.neoconf.json".source = mkLink "config/nvim/.neoconf.json";
    "nvim/stylua.toml".source = mkLink "config/nvim/stylua.toml";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less -R";
  };
}
