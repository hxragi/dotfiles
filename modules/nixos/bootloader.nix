{lib, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    binfmt.emulatedSystems = lib.mkForce [];
  };
}
