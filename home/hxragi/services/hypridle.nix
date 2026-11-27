{
  config,
  pkgs,
  ...
}:
let
  niri = "${config.programs.niri.package}/bin/niri";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock --immediate";
  pidof = "${pkgs.procps}/bin/pidof";
  loginctl = "${pkgs.systemd}/bin/loginctl";
in
{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "${pidof} hyprlock || ${hyprlock}";
        before_sleep_cmd = "${loginctl} lock-session";
        after_sleep_cmd = "${niri} msg action power-on-monitors";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "${loginctl} lock-session";
        }
      ];
    };
  };
}
