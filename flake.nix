{
  description = "hxragi's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:epireyn/niri-flake";

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    sops-nix,
    niri,
    ironbar,
    nur,
    disko,
    treefmt-nix,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };

    treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

    shinoa = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/shinoa

        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        niri.nixosModules.niri
        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [
            niri.overlays.niri
            nur.overlays.default
          ];

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-bak";

            extraSpecialArgs = {
              inherit catppuccin ironbar;
            };

            users.hxragi = import ./home/hxragi;
          };
        }
      ];
    };
  in {
    nixosConfigurations.shinoa = shinoa;

    formatter.${system} = treefmtEval.config.build.wrapper;

    checks.${system} = {
      formatting = treefmtEval.config.build.check self;

      lint =
        pkgs.runCommand "nix-lint" {
          nativeBuildInputs = with pkgs; [
            deadnix
            statix
          ];
        } ''
          statix check ${self}
          deadnix --fail ${self}

          touch $out
        '';

      shinoa-eval = pkgs.writeText "shinoa-eval" (
        builtins.unsafeDiscardStringContext
        shinoa.config.system.build.toplevel.drvPath
      );
    };

    devShells.${system} = import ./devShells {
      inherit pkgs;
    };
  };
}
