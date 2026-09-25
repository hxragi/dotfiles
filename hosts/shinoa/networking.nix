{
  lib,
  ...
}:
{
  networking = {
    hostName = "shinoa";

    networkmanager.enable = lib.mkForce false;
    dhcpcd.enable = lib.mkForce false;

    # Tell the script-based networking modules that networkd owns the
    # interfaces, otherwise they compete for the same address.
    useNetworkd = lib.mkForce true;
    useDHCP = lib.mkForce false;

    # systemd-networkd writes /etc/resolv.conf itself. Leaving resolvconf
    # enabled would hand the file to a daemon that nothing feeds once dhcpcd
    # is gone, silently emptying DNS.
    resolvconf.enable = false;
  };

  systemd.network = {
    enable = true;

    wait-online = {
      enable = true;
      anyInterface = true;
    };

    networks."10-wired" = {
      # "en*" is systemd's predictable-naming prefix for physical NICs, so this
      # does not pick up virtual interfaces such as docker0.
      matchConfig.Name = "en*";
      DHCP = "yes";
    };
  };
}
