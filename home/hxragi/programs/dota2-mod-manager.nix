{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dota2-mod-manager
  ];
}
