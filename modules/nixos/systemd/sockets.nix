{
  systemd.sockets = {
    "systemd-coredump".enable = false;
    "systemd-machined".enable = false;
    "systemd-importd".enable = false;
    "systemd-hostnamed".enable = false;
    "systemd-pstore".enable = false;
  };
}
