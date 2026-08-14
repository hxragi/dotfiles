{pkgs}: {
  rust = import ./rust.nix {
    inherit pkgs;
  };
}
