{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    xdgOpenUsePortal = false;

    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    configPackages = lib.mkForce [ ];

    config.common = {
      default = [
        "gnome"
      ];
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.Settings" = "gtk";
    };
  };

  systemd.user.services.xdg-desktop-portal.restartTriggers = [
    config.environment.etc."xdg/xdg-desktop-portal/portals.conf".source
  ]
  ++ config.xdg.portal.extraPortals;
}
