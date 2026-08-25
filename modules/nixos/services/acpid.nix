{lib, ...}: {
  services.acpid.enable = lib.mkForce false;
}
