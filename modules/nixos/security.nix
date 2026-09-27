{
  lib,
  ...
}:
{
  security = {
    protectKernelImage = lib.mkForce true;
    lockKernelModules = lib.mkForce true;

    auditd = {
      enable = true;
      settings = {
        num_logs = 8;
        max_log_file = 10;
        max_log_file_action = "ROTATE";
        space_left = 75;
        space_left_action = "SYSLOG";
        admin_space_left = 50;
        admin_space_left_action = "SUSPEND";
        disk_full_action = "SUSPEND";
      };
    };
  };

  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "fs.suid_dumpable" = 0;
    "kernel.sysrq" = 0;

    "kernel.kexec_load_disabled" = 1;

    "kernel.yama.ptrace_scope" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;

    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;

    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
  };
}
