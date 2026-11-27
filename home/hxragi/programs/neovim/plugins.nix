{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    direnv-nvim
    nvim-autopairs
    blink-cmp
    cord-nvim
    nvim-lspconfig
    mini-statusline
    fidget-nvim
    mini-tabline
    fzf-lua
    nvim-tree-lua
    conform-nvim
    (nvim-treesitter.withPlugins (
      parsers: with parsers; [
        bash
        java
        lua
        markdown
        markdown_inline
        nix
        python
        rust
        solidity
        toml
        vim
        vimdoc
        yaml
      ]
    ))
  ];
}
