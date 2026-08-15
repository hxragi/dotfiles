-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable F1 help
vim.keymap.set({ "n", "v", "i" }, "<F1>", "<Nop>")

-- Buffers
vim.keymap.set(
  "n",
  "<Leader>bdd",
  "<cmd>%bd|edit#|bd#<CR>",
  { desc = "Delete all buffers except current" }
)

vim.keymap.set(
  "n",
  "<Leader><Left>",
  "<cmd>bp<CR>",
  { desc = "Previous buffer" }
)

vim.keymap.set(
  "n",
  "<Leader><Right>",
  "<cmd>bn<CR>",
  { desc = "Next buffer" }
)

-- Clipboard
vim.keymap.set(
  "v",
  "<Leader>y",
  '"+y',
  { desc = "Yank to clipboard" }
)

-- File Explorer
vim.keymap.set(
  "n",
  "<leader>e",
  "<cmd>NvimTreeToggle<CR>",
  { desc = "Toggle file explorer" }
)

vim.keymap.set(
  "n",
  "<leader>o",
  "<cmd>NvimTreeFocus<CR>",
  { desc = "Focus file explorer" }
)

-- FzfLua
vim.keymap.set(
  "n",
  "<leader>ff",
  function()
    require("fzf-lua").files()
  end,
  { desc = "Find files" }
)

vim.keymap.set(
  "n",
  "<leader>fg",
  function()
    require("fzf-lua").grep_project()
  end,
  { desc = "Fuzzy grep project" }
)
