{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
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
    "vm.page-cluster" = 0;
    "vm.vfs_cache_pressure" = 150;
    "vm.swappiness" = 160;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };
}
