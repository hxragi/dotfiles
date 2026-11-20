{ pkgs, ... }:
{
  home.packages = [
    pkgs.horizon-launcher
  ];

  xdg.desktopEntries.horizon-launcher = {
    name = "Horizon";
    genericName = "Game launcher";
    comment = "Install, prepare and play Horizon, Minecraft: Java Edition 26.3 rewritten in Rust";
    exec = "horizon-launcher";
    icon = "horizon";
    terminal = false;
    categories = [ "Game" ];
    settings = {
      StartupWMClass = "horizon-launcher";
    };
  };
}
