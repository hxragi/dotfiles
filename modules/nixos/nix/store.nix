{
  nix = {
    settings = {
      auto-optimise-store = true;
      keep-derivations = false;
      keep-outputs = false;
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
