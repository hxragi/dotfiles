{
  catppuccin,
  pkgs,
  ...
}: let
  gtkThemeName = "catppuccin-mocha-mauve-standard";

  gtkTheme = pkgs.catppuccin-gtk.override {
    accents = ["mauve"];
    size = "standard";
    variant = "mocha";
  };
in {
  imports = [
    catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    autoEnable = true;

    flavor = "mocha";
    accent = "mauve";

    cursors.enable = true;
    gtk.icon.enable = true;

    kvantum = {
      enable = true;
      apply = true;
    };

    firefox = {
      enable = true;
      profiles.default.enable = true;
    };
  };

  home.packages = [
    gtkTheme
  ];

  gtk = {
    enable = true;

    theme = {
      name = gtkThemeName;
      package = gtkTheme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source =
      "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/assets";

    "gtk-4.0/gtk.css".source =
      "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/gtk.css";

    "gtk-4.0/gtk-dark.css".source =
      "${gtkTheme}/share/themes/${gtkThemeName}/gtk-4.0/gtk-dark.css";
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = gtkThemeName;
  };
}
