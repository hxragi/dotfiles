{
  programs.niri.settings.window-rules = [
    {
      open-maximized = true;

      geometry-corner-radius = let
        radius = 8.0;
      in {
        top-left = radius;
        top-right = radius;
        bottom-left = radius;
        bottom-right = radius;
      };

      clip-to-geometry = true;
    }
  ];
}
