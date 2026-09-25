{
  boot.initrd.systemd = {
    # systemd in the initrd gives correct ordering, lets udev settle devices in
    # parallel, and is a prerequisite for shipping networkd or netplan config
    # into the initrd later.
    enable = true;
  };
}
