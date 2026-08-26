{ inputs, ... }: {
  imports = [
    inputs.helium.homeModules.default
    ./helium.nix
    ./policies.nix
  ];
}
