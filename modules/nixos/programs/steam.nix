{ pkgs, ... }: {
  programs.steam = {
    enable = true;

    extraCompatPackages = [
      (pkgs.callPackage ../../../packages/proton-cachyos.nix { })
    ];
  };
}
