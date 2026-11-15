{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    warn-dirty = false;
    builders-use-substitutes = true;
  };
}
