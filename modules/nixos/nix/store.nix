{
  nix.settings = {
    auto-optimise-store = false;

    keep-derivations = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
