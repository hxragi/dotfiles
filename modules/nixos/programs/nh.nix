{
  # The flake path is machine-specific and lives in the host directory; see
  # hosts/shinoa/nh.nix.
  programs.nh = {
    enable = true;

    clean = {
      enable = true;
      dates = "weekly";

      extraArgs = "--keep-since 1d --keep 5";
    };
  };
}
