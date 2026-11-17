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

  pantheon = import ./pantheon.nix {
    inherit
      pkgs
      rust
      java
      python
      ;
  };
in
{
  inherit
    rust
    java
    python
    solidity
    pantheon
    pentest
    ;

  default = rust;
}
