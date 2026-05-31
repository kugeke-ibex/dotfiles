{
  description = "kugeke's dotfiles - macOS Apple Silicon (personal + one-or-more work hosts)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-hashicorp = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
    homebrew-idoavrah = {
      # 元リポジトリ idoavrah/homebrew は 2026 年に削除済み。
      # 公式の命名規則 (<user>/homebrew-<tap>) に揃えた idoavrah/homebrew-homebrew が後継。
      # brew 側の tap 名 ("idoavrah/homebrew") は変わらないので、URL だけ差し替えれば良い。
      url = "github:idoavrah/homebrew-homebrew";
      flake = false;
    };
    homebrew-kayac = {
      url = "github:kayac/homebrew-tap";
      flake = false;
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      treefmt-nix,
      ...
    }:
    let
      system = "aarch64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      flakeDir = "${self}";

      mkApp = name: script: {
        type = "app";
        program = "${
          pkgs.writeShellApplication {
            inherit name;
            text = script;
          }
        }/bin/${name}";
      };

      # username / dotfilesRelative はホストごとに上書き可（例: 社用 PC のログイン名や clone 先が異なる場合）。
      mkDarwin =
        {
          hostname,
          profile,
          username ? "kugeke",
          dotfilesRelative ? "Development/dotfiles",
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              username
              hostname
              profile
              dotfilesRelative
              ;
          };
          modules = [
            ./modules/darwin
            ./hosts/${hostname}

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "before-nix-darwin";
                extraSpecialArgs = {
                  inherit
                    inputs
                    username
                    profile
                    dotfilesRelative
                    ;
                };
                users.${username} = import ./modules/home;
              };
            }

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = username;
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                  "hashicorp/homebrew-tap" = inputs.homebrew-hashicorp;
                  "idoavrah/homebrew" = inputs.homebrew-idoavrah;
                  "kayac/homebrew-tap" = inputs.homebrew-kayac;
                };
                mutableTaps = false;
              };
            }
          ];
        };
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      checks.${system}.formatting = treefmtEval.config.build.check self;

      # 初回適用前は `darwin-rebuild` がまだ PATH に無いため、
      # bootstrap.sh と同じく `nix run nix-darwin -- ...` で fallback する。
      apps.${system} = {
        switch = mkApp "darwin-switch" ''
          host="''${1:-personal}"
          if command -v darwin-rebuild >/dev/null 2>&1; then
            sudo darwin-rebuild switch --flake "${flakeDir}#$host"
          else
            sudo nix run nix-darwin -- switch --flake "${flakeDir}#$host"
          fi
        '';
        build = mkApp "darwin-build" ''
          host="''${1:-personal}"
          if command -v darwin-rebuild >/dev/null 2>&1; then
            darwin-rebuild build --flake "${flakeDir}#$host"
          else
            nix run nix-darwin -- build --flake "${flakeDir}#$host"
          fi
        '';
        check = mkApp "darwin-check" ''
          host="''${1:-personal}"
          if command -v darwin-rebuild >/dev/null 2>&1; then
            darwin-rebuild check --flake "${flakeDir}#$host"
          else
            nix run nix-darwin -- check --flake "${flakeDir}#$host"
          fi
        '';
        update = mkApp "darwin-update" ''
          host="''${1:-personal}"
          nix flake update --flake "${flakeDir}"
          if command -v darwin-rebuild >/dev/null 2>&1; then
            sudo darwin-rebuild switch --flake "${flakeDir}#$host"
          else
            sudo nix run nix-darwin -- switch --flake "${flakeDir}#$host"
          fi
        '';
      };

      darwinConfigurations = {
        personal = mkDarwin {
          hostname = "personal";
          profile = "personal";
        };
        work = mkDarwin {
          hostname = "work";
          profile = "work";
          # 例: 社用 PC でユーザー名や clone 先だけ違うとき
          # username = "corpuser";
          # dotfilesRelative = "Projects/dotfiles";
        };
        # 2 台目以降の社用 Mac。hosts/work-office を複製して増やし、ここに flake エントリを追加する。
        work-office = mkDarwin {
          hostname = "work-office";
          profile = "work";
        };
      };
    };
}
