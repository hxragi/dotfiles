{
  programs.nh = {
    enable = true;

    clean = {
      enable = true;
      dates = "weekly";

      extraArgs = "--keep-since 1d --keep 5";
    };
  };
}
