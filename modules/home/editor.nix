{ pkgs, config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/Development/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  # Neovim 本体は home.packages で管理。
  # programs.neovim を使うと init.lua が自動生成され、LazyVim の
  # `require("config.lazy")` パターンと衝突するため、本体パッケージのみ Nix で
  # 入れて、init.lua / lua/ は dotfiles から symlink する構成にしている。
  home.packages = with pkgs; [
    neovim

    # LazyVim / Mason / treesitter / Lua LSP が必要とする補助ツール
    tree-sitter
    nodejs_22
    stylua
    shellcheck
    shfmt
  ];

  # LazyVim 設定 (~/.config/nvim/) を dotfiles から live symlink。
  # mkOutOfStoreSymlink を使うので dotfiles 編集が即時反映される (rebuild 不要)。
  xdg.configFile = {
    "nvim/init.lua".source = mkLink "config/nvim/init.lua";
    "nvim/lua".source = mkLink "config/nvim/lua";
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
