{
  config,
  pkgs,
  ...
}:
let
  niri = "${config.programs.niri.package}/bin/niri";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock --immediate";
in
{
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 300;
        command = hyprlock;
      }
    ];

    events = {
      "before-sleep" = hyprlock;
      "after-resume" = "${niri} msg action power-on-monitors";
    };
  };
}
