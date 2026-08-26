{ ironbar, ... }: {
  imports = [
    ironbar.homeManagerModules.default
    ./config.nix
    ./style.nix
  ];
}
