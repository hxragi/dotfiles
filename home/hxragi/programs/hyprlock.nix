{ fonts, ... }:
{
  catppuccin.hyprlock.useDefaultConfig = false;

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          color = "$base";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "$text";
          font_size = 42;
          font_family = fonts.mono;
          position = "0, 76";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "280, 48";
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = false;
          placeholder_text = "";
          hide_input = false;
          check_color = "$accent";
          fail_color = "$red";
          fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
          capslock_color = "$yellow";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
