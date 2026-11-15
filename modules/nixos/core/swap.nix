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
    # Aggressively reclaim directory and inode cache
    "vm.vfs_cache_pressure" = 150;
    # Prefer swapping anonymous pages into in-RAM compressed zram
    "vm.swappiness" = 160;
    # Prevent disk write spikes
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };
}
