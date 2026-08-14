{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = [
      pkgs.intel-media-driver
    ];
  };
}
