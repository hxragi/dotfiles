{
  config,
  pkgs,
  ...
}:
let
  niri = "${config.programs.niri.package}/bin/niri";
  swaylock = "${pkgs.swaylock}/bin/swaylock -f";
in
{
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 300;
        command = swaylock;
      }
    ];

    events = {
      "before-sleep" = swaylock;
      "after-resume" = "${niri} msg action power-on-monitors";
    };
  };
}
