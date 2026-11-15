{ inputs }:
{
  host,
  user ? "hxragi",
  system ? "x86_64-linux",
  extraModules ? [ ],
  extraSpecialArgs ? { },
}:
let
  inherit (inputs)
    nixpkgs
    home-manager
    disko
    sops-nix
    catppuccin
    niri
    nur
    helium
    obsidian-extensions
    ironbar
    ;
in
nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit inputs host user;
  }
  // extraSpecialArgs;

  modules = [
    ../hosts/${host}

    disko.nixosModules.disko
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager

    {
      networking.hostName = nixpkgs.lib.mkDefault host;

      nixpkgs.overlays = [
        niri.overlays.niri
        nur.overlays.default
        helium.overlays.default
        obsidian-extensions.overlays.default
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-bak";

        extraSpecialArgs = {
          inherit
            inputs
            catppuccin
            ironbar
            host
            user
            ;
          fonts = import ./fonts.nix;
          palette = import ./palette.nix;
        }
        // extraSpecialArgs;

        users.${user} = import ../home/${user};
      };
    }
  ]
  ++ extraModules;
}
