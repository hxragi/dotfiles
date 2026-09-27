{
  catppuccin,
  ...
}:
{
  imports = [
    catppuccin.homeModules.catppuccin
  ];
  home.pointerCursor.enable = true;
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "lavender";
    cursors.enable = true;
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
