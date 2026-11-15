{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gzip
    p7zip
    unrar
    unzip
  ];
}
