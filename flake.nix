{
  description = "hxragi's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    sops-nix.url = "github:Mic92/sops-nix";
    niri.url = "github:sodiboo/niri-flake";

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    catppuccin,
    sops-nix,
    niri,
    ironbar,
    nur,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.shinoa = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/shinoa

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

    devShells.${system} = import ./devShells {
      inherit pkgs;
    };
  };
}
