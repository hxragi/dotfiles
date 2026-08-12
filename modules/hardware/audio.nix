{
  security.rtkit.enable = true;

  hardware.alsa.enablePersistence = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig."10-fifine-mic" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {"device.name" = "alsa_card.usb-3142_Fifine_Microphone-00";}
          ];
          actions = {
            update-props = {
              "api.alsa.soft-mixer" = true;
            };
          };
        }
      ];
    };
  };
}
