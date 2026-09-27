{
  config,
  pkgs,
  ...
}:
let
  themeName = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-standard";
in
{
  gtk = {
    enable = true;
    theme = {
      name = themeName;
      package = pkgs.catppuccin-gtk.override {
        accents = [ config.catppuccin.accent ];
        size = "standard";
        variant = config.catppuccin.flavor;
      };
    };
  };
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${themeName}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${themeName}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${config.gtk.theme.package}/share/themes/${themeName}/gtk-4.0/gtk-dark.css";
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = themeName;
  };
}
