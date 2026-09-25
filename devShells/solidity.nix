{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    foundry
    solc
    slither-analyzer
    vscode-solidity-server
  ];

  shellHook = ''
    export FOUNDRY_SOLC_PATH="${pkgs.solc}/bin/solc"
    export FOUNDRY_OFFLINE="true"
  '';
}
