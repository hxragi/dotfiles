return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  lazy = false, -- neo-tree will lazily load itself
  opts = {
    window = {
      position = "right",
    }
  },
  keys = {
    { "<Leader>e", "<cmd>Neotree toggle<cr>", desc = "Neotree" },
  },
}
