{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-autopairs
    blink-cmp
    cord-nvim
    nvim-lspconfig
    mini-statusline
    noice-nvim
    nui-nvim
    mini-tabline
    fzf-lua
    nvim-tree-lua
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
        toml
        vim
        vimdoc
        yaml
      ]
    ))
  ];
}
