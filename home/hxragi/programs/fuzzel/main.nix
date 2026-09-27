{ fonts, ... }: {
  programs.fuzzel.settings.main = {
    font = "${fonts.mono}:size=${toString fonts.scale}";
    width = 45;
    lines = 7;
    horizontal-pad = 15;
    vertical-pad = 15;
    inner-pad = 15;
    prompt = "run: ";
    icons-enabled = "no";
  };
}
