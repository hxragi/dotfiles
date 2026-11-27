{ config, lib, ... }:
let
  inherit (config.catppuccin) flavor accent;
  themeName = "catppuccin-${flavor}-${accent}.theme";
in
{
  programs.equibop = {
    settings = {
      minimizeToTray = true;
      discordBranch = "stable";
      arRPC = true;
      plugins = {
        VolumeBooster.enable = true;
        FakeNitro.enable = true;
        ShowHiddenChannels.enable = true;
      };
    };

    equicord = {
      settings.enabledThemes = [ "${themeName}.css" ];
      themes.${themeName} = ''
        /**
         * @name Catppuccin ${lib.toSentenceCase flavor} (${lib.toSentenceCase accent})
         * @author Catppuccin
         * @description Soothing pastel theme for Discord
         * @website https://github.com/catppuccin/discord
        **/
        @import url("https://catppuccin.github.io/discord/dist/${themeName}.css");
      '';
    };
  };
}
