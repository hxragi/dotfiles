{ pkgs, ... }:
{
  home.packages = [
    pkgs.comma
  ];

  programs.nix-index = {
    enable = true;
    enableFishIntegration = false;
  };
}
