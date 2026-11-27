{
  services.thermald.enable = true;

  services.tuned = {
    enable = true;
    ppdSupport = true;
  };
}
