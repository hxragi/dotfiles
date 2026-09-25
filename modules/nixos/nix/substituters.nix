{
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://jakestanger.cachix.org"
      "https://catppuccin.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];

    # Retry a cache that reported "not found" within minutes rather than the
    # default hour, so a newly published binary cache becomes usable right
    # after a flake update instead of after a wait.
    narinfo-cache-negative-ttl = 300;
  };
}
