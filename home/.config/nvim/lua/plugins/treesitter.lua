-- Treesitter
require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "java",
    "lua",
    "markdown",
    "nix",
    "python",
    "rust",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
  },

  callback = function()
    vim.treesitter.start()
  end,
})
