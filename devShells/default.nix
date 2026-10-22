{ pkgs }: {
  rust = import ./rust.nix {
    inherit pkgs;
  };

  java = import ./java.nix {
    inherit pkgs;
  };

  python = import ./python.nix {
    inherit pkgs;
  };

  solidity = import ./solidity.nix {
    inherit pkgs;
  };
}
