{
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  boot.initrd.kernelModules = [
    "nvidia"
  ];

  services.xserver.videoDrivers = [
    "nvidia"
  ];
}
