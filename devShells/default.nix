{ pkgs }:
let
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

  pentest = import ./pentest.nix {
    inherit pkgs;
  };
in
{
  inherit
    rust
    java
    python
    solidity
    pentest
    ;

  default = rust;
}
