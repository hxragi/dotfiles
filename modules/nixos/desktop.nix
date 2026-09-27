{ lib, ... }: {
  services.graphical-desktop.enable = lib.mkForce false;

  fonts.enableDefaultPackages = lib.mkForce false;
}
