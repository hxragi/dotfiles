final: _prev: {
  dota2-mod-manager = final.callPackage ../packages/dota2-mod-manager.nix { };
  horizon-launcher = final.callPackage ../packages/horizon-launcher.nix { };
  superseedr = final.callPackage ../packages/superseedr.nix { };
}
