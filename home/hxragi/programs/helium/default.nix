{ inputs, ... }: {
  imports = [
    inputs.helium.homeModules.default
    ./extensions.nix
    ./helium.nix
    ./policies.nix
  ];
}
