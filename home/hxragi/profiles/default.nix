{lib, ...}: {
  imports = [
    ./desktop.nix
    ./development.nix
  ];

  hxragi.profiles = {
    desktop.enable = lib.mkDefault true;
    development.enable = lib.mkDefault true;
  };
}
