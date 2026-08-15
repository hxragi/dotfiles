{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hxragi.profiles.desktop;

  swaylock = "${pkgs.swaylock}/bin/swaylock";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  niri = "${pkgs.niri}/bin/niri";

  firefoxDesktop = "firefox.desktop";
in {
  options.hxragi.profiles.desktop.enable =
    lib.mkEnableOption "hxragi desktop profile";

  config = lib.mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = firefoxDesktop;
        "application/xhtml+xml" = firefoxDesktop;
        "application/pdf" = firefoxDesktop;
        "image/svg+xml" = firefoxDesktop;

        "x-scheme-handler/http" = firefoxDesktop;
        "x-scheme-handler/https" = firefoxDesktop;
        "x-scheme-handler/ftp" = firefoxDesktop;
      };
    };

    services.mako = {
      enable = true;

      settings = {
        anchor = "top-right";
        layer = "top";

        width = 360;
        height = 120;

        margin = "8";
        padding = "10";

        border-size = 2;
        border-radius = 8;

        default-timeout = 5000;

        icons = true;
        markup = true;
        actions = true;
      };
    };

    programs.swaylock.enable = true;

    services.swayidle = {
      enable = true;

      timeouts = [
        {
          timeout = 300;
          command = "${loginctl} lock-session";
        }

        {
          timeout = 330;
          command = "${niri} msg action power-off-monitors";
          resumeCommand = "${niri} msg action power-on-monitors";
        }
      ];

      events = {
        "lock" = "${swaylock} -f";

        "before-sleep" = "${swaylock} -f";

        "after-resume" = "${niri} msg action power-on-monitors";
      };
    };
  };
}
