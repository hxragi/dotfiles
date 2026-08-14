{
  security.rtkit.enable = true;

  hardware.alsa.enablePersistence = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
