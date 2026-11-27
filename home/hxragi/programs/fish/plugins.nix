{ pkgs, ... }: {
  programs.fish.plugins = [
    {
      name = "tide";
      inherit (pkgs.fishPlugins.tide) src;
    }
  ];
}
