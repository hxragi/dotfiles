{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;

    extraPackages = with pkgs; [
      lua-language-server
      yaml-language-server
      nixd
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-autopairs

      blink-cmp

      cord-nvim

      nvim-lspconfig

      mini-statusline
      mini-tabline

      noice-nvim
      nui-nvim

      nvim-tree-lua

      plenary-nvim
      telescope-nvim

      (nvim-treesitter.withPlugins (parsers:
        with parsers; [
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
        ]))
    ];

    initLua = ''
      require("options")
      require("keymaps")
      require("plugins")
      require("lsp")
    '';
  };

  xdg.configFile."nvim/lua".source = ../../.config/nvim/lua;
}
