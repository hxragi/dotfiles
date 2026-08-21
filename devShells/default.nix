{pkgs}: {
  rust = import ./rust.nix {
    inherit pkgs;
  };

  java = import ./java.nix {
    inherit pkgs;
  };
}
