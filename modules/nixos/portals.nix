{
  lib,
  pkgs,
  ...
}: {
  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      niri = lib.mkForce {
        default = [
          "gtk"
        ];

        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.Settings" = "gtk";

        "org.freedesktop.impl.portal.Screencast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };

      common = {
        default = [
          "gtk"
        ];

        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.Settings" = "gtk";
      };
    };
  };
}
