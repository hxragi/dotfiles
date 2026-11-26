{ inputs, ... }:
{
  nix = {
    channel.enable = false;

    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
