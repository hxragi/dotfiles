{
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    algorithm = "zstd";
    priority = 100;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
      priority = 10;
    }
  ];

  boot.kernel.sysctl = {
    # Low latency page clustering for compressed in-RAM zram swap
    "vm.page-cluster" = 0;
  };
}
