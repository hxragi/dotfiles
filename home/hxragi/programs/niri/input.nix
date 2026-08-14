{
  programs.niri.settings.input = {
    keyboard = {
      xkb = {
        layout = "us,ru";
        options = "grp:win_space_toggle";
      };

      repeat-delay = 400;
      repeat-rate = 25;
      numlock = true;
    };

    touchpad = {
      tap = true;
      natural-scroll = true;
      accel-profile = "flat";
      scroll-method = "two-finger";
      disabled-on-external-mouse = true;
    };

    mouse = {
      accel-profile = "flat";
      middle-emulation = true;
    };

    focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "0%";
    };
  };
}
