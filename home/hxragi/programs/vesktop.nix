{pkgs, ...}: {
  programs.vesktop = {
    enable = true;

    package = pkgs.vesktop.overrideAttrs (old: {
      postFixup =
        (old.postFixup or "")
        + ''
          wrapProgram $out/bin/vesktop \
            --add-flags "--use-gl=angle --use-angle=gl --enable-features=UseOzonePlatform,VaapiVideoEncoder,VaapiVideoDecoder --ozone-platform=wayland --enable-zero-copy"
        '';
    });

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
  };
}
