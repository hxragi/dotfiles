{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

    kernelModules = [ "ntsync" ];

    kernelParams = [
      "i915.force_probe=!a7a8"
      "xe.force_probe=a7a8"
    ];
  };

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
