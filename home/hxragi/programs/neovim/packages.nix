{ pkgs, ... }: {
  programs.neovim.extraPackages = with pkgs; [
    lua-language-server
    yaml-language-server
    nixd
    fzf
  ];
}
