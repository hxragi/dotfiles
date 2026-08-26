{ catppuccin, ... }: {
  imports = [
    catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "lavender";
    cursors.enable = true;
    gtk.icon.enable = true;
    nvim = {
      enable = true;
      settings = {
        transparent_background = true;
        float = {
          transparent = true;
        };
      };
    };
    kvantum = {
      enable = true;
      apply = true;
    };
  };
}
