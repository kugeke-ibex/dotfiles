{
  description = "kugeke's dotfiles - macOS Apple Silicon (personal/work)";

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
      url = "github:idoavrah/homebrew";
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
    inputs@{ self
    , nixpkgs
    , nix-darwin
    , home-manager
    , nix-homebrew
    , treefmt-nix
    , ...
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
            inherit inputs username hostname profile dotfilesRelative;
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
                  inherit inputs username profile dotfilesRelative;
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

      apps.${system} = {
        switch = mkApp "darwin-switch" ''
          host="''${1:-personal}"
          sudo darwin-rebuild switch --flake "${flakeDir}#$host"
        '';
        build = mkApp "darwin-build" ''
          host="''${1:-personal}"
          darwin-rebuild build --flake "${flakeDir}#$host"
        '';
        check = mkApp "darwin-check" ''
          host="''${1:-personal}"
          darwin-rebuild check --flake "${flakeDir}#$host"
        '';
        update = mkApp "darwin-update" ''
          host="''${1:-personal}"
          nix flake update --flake "${flakeDir}"
          sudo darwin-rebuild switch --flake "${flakeDir}#$host"
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
      };
    };
}
