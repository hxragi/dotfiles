{
  systemd = {
    services = {
      "systemd-coredump@".enable = false;
      "getty@tty2".enable = false;
      "getty@tty3".enable = false;
      "getty@tty4".enable = false;
      "getty@tty5".enable = false;
      "getty@tty6".enable = false;
      "getty@tty7".enable = false;
      "getty@tty8".enable = false;
      "getty@tty9".enable = false;
      "getty@tty10".enable = false;
      "getty@tty11".enable = false;
      "getty@tty12".enable = false;

      "serial-getty@ttyS0".enable = false;
      "serial-getty@ttyS1".enable = false;
    };

    sockets = {
      "systemd-coredump".enable = false;
      "systemd-machined".enable = false;
      "systemd-importd".enable = false;
      "systemd-hostnamed".enable = false;
      "systemd-pstore".enable = false;
    };

    timers = {
      "systemd-tmpfiles-clean".enable = false;
    };

    targets.getty.wants = [];
  };
}
