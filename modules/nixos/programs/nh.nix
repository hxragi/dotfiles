{
  programs.nh = {
    enable = true;

    flake = "/home/hxragi/.dotfiles";

    clean = {
      enable = true;
      dates = "weekly";

      extraArgs = "--keep-since 1d --keep 5";
    };
  };
}
