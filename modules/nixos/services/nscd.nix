{ lib, ... }: {
  services.nscd.enable = false;
  system.nssModules = lib.mkForce [ ];
}
