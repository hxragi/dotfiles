{lib, ...}: {
  services.gnome.gnome-keyring.enable = lib.mkForce false;
}
