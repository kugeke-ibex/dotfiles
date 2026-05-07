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
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... }:
    let
      username = "kugeke";
      system = "aarch64-darwin";

      mkDarwin = { hostname, profile }: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs username hostname profile; };
        modules = [
          ./modules/darwin
          ./hosts/${hostname}

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "before-nix-darwin";
              extraSpecialArgs = { inherit inputs username profile; };
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
    in {
      darwinConfigurations = {
        personal = mkDarwin { hostname = "personal"; profile = "personal"; };
        work = mkDarwin { hostname = "work"; profile = "work"; };
      };
    };
}
