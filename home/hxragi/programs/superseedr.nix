{ pkgs, ... }:
{
  home.packages = with pkgs; [
    superseedr
  ];
}
