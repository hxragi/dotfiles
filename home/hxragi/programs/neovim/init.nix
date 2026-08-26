{
  programs.neovim.initLua = ''
    require("options")
    require("keymaps")
    require("plugins")
    require("lsp")
  '';
  xdg.configFile."nvim/lua".source = ../../../.config/nvim/lua;
}
