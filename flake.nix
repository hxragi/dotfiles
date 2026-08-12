{
  description = "hxragi's nixos config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    sops-nix.url = "github:Mic92/sops-nix";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    sops-nix,
    ...
  }: {
    nixosConfigurations.shinoa = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.extraSpecialArgs = {inherit catppuccin;};
          home-manager.users.hxragi = import ./home.nix;
        }
      ];
    };
  };
}
