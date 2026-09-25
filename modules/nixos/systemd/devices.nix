{
  # The firmware advertises four 8250 serial ports that never produce a working
  # device here. udev still SYSTEMD_WANTS their .device units, and each one
  # burns a job timeout on the critical path. The matching gettys are already
  # disabled in ./services.nix and no console=ttyS* kernel parameter is set, so
  # masking is safe and reclaims the delay.
  systemd.units = {
    "dev-ttyS0.device".enable = false;
    "dev-ttyS1.device".enable = false;
    "dev-ttyS2.device".enable = false;
    "dev-ttyS3.device".enable = false;
  };
}
