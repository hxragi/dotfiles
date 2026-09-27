{ fonts, ... }: {
  programs.foot.settings.main = {
    font = "${fonts.mono}:size=${toString fonts.size}";
  };
}
