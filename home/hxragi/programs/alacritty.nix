{
  programs.alacritty = {
    enable = true;

    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        opacity = 0.91;
        blur = false;
        decorations = "Transparent";
        decorations_theme_variant = "Dark";
      };

      font = {
        size = 16.0;

        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };

        bold = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold";
        };

        italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Italic";
        };

        bold_italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold Italic";
        };
      };

      mouse = {
        hide_when_typing = true;
      };
    };
  };
}
