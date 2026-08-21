{pkgs, ...}:
{
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [
    "i915.force_probe=!a7a8"
    "xe.force_probe=a7a8"
  ];
}
