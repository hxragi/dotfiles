{
  lib,
  ...
}:
{
  networking = {
    hostName = "shinoa";

    networkmanager.enable = lib.mkForce false;
    dhcpcd.enable = lib.mkForce false;

    useNetworkd = lib.mkForce true;
    useDHCP = lib.mkForce false;

    resolvconf.enable = false;
  };

  systemd.network = {
    enable = true;

    wait-online = {
      enable = true;
      anyInterface = true;
    };

    networks."10-wired" = {
      matchConfig.Name = "en*";
      DHCP = "yes";
    };
  };
}
