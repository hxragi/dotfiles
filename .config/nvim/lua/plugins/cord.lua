return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  opts = {
    editor = {
      tooltip = '💻 Neovim <3',
    },
    idle = { enabled = false },
    display = { theme = 'catppuccin' },
  }
}
