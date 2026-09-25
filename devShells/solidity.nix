{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    foundry
    solc
    slither-analyzer
  ];
}
