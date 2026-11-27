{ pkgs, ... }: {
  home.packages = with pkgs; [
    scc
  ];
}
