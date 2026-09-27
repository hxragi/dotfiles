{
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (_final: prev: {
        espeak-ng = prev.espeak-ng.override { mbrolaSupport = false; };
      })
    ];
  };
}
