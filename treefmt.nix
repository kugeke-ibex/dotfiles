{ ... }:
{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    stylua.enable = true;
    shfmt.enable = true;
    taplo.enable = true;
    yamlfmt.enable = true;
    prettier.enable = true;
  };

  settings.formatter = {
    nixfmt.includes = [
      "*.nix"
      "**/*.nix"
    ];

    stylua.includes = [
      "config/wezterm/**/*.lua"
      "config/nvim/**/*.lua"
    ];

    shfmt.includes = [
      "bootstrap.sh"
      "**/*.sh"
    ];

    taplo.includes = [
      "*.toml"
      "config/**/*.toml"
    ];

    yamlfmt.includes = [
      "*.yaml"
      "*.yml"
      "**/*.yaml"
      "**/*.yml"
    ];

    prettier = {
      includes = [
        "*.md"
        "docs/**/*.md"
        "config/vscode/**/*.json"
      ];
      # JSONC (Cursor) や Karabiner UI が触る JSON は対象外
      excludes = [
        "config/cursor/**/*.json"
        "karabiner/**/*.json"
        "flake.lock"
        "config/raycast/**/*"
      ];
    };
  };
}
