{
  security.rtkit.enable = true;

  hardware.alsa.enablePersistence = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.codecs" = [
          "sbc_xq"
          "ldac"
          "aac"
          "sbc"
        ];
      };
    };
  };
}
