{pkgs, ...}: let
  loginctl = "${pkgs.systemd}/bin/loginctl";
  niri = "${pkgs.niri}/bin/niri";
  swaylock = "${pkgs.swaylock}/bin/swaylock";
in {
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
}
