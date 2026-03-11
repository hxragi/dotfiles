vim.g.mapleader = " "

local opt = vim.opt

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.updatetime = 200

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.number = true
opt.signcolumn = "yes"
opt.showcmd = true
opt.laststatus = 3
opt.termguicolors = true
opt.winborder = "rounded"
opt.wildmenu = true
opt.list = true
opt.listchars = "tab:»·,trail:·,nbsp:·"
opt.mouse = ""
opt.mousescroll = "ver:0,hor:0"

opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.confirm = true
opt.completeopt = "menu,menuone,noinsert"

vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.diagnostic.config({ virtual_text = true })
vim.lsp.log.set_level("warn")

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim.git" },
  { src = "https://github.com/akinsho/bufferline.nvim.git" },
  { src = "https://github.com/nvim-lualine/lualine.nvim.git" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim.git", cmd = "Neotree" },
  { src = "https://github.com/MunifTanjim/nui.nvim.git" },
  { src = "https://github.com/nvim-telescope/telescope.nvim.git", cmd = "Telescope" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter.git" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context.git" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/folke/which-key.nvim.git" },
  { src = "https://github.com/nvim-mini/mini.pairs" },
  { src = "https://github.com/vyfor/cord.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim.git" }
})

vim.loader.enable()

local telescope = require("telescope")
local builtin = require("telescope.builtin")

require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  no_italic = false,
  no_bold = false,
  no_underline = false,
})

telescope.setup({
  defaults = {
    preview = { treesitter = true },
    color_devicons = true,
    sorting_strategy = "ascending",
    borderchars = { "", "", "", "", "", "", "", "" },
    path_displays = { "smart" },
    layout_config = {
      height = 0.9,
      width = 0.85,
      prompt_position = "top",
      preview_cutoff = 40,
    },
  },
})

require("neo-tree").setup({
  window = { position = "right" },
})

require("blink.cmp").setup({
  keymap = { preset = "enter" },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 5000 },
    trigger = { prefetch_on_insert = false },
  },
  signature = {
    enabled = false,
    trigger = {
      enabled = false,
      show_on_trigger_character = false,
      show_on_insert_on_trigger_character = false,
    },
  },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  fuzzy = { implementation = "lua" },
})

require("cord").setup({
  editor = { tooltip = "💻 Neovim <3" },
  idle = { enabled = false },
  display = { theme = "catppuccin" },
})

require("lualine").setup({
  options = {
    theme = "catppuccin",
    icons_enabled = true,
    component_separators = "",
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics" },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})

require("bufferline").setup({
  highlights = {
    fill = { bg = "NONE" },
    background = { bg = "NONE" },
    tab = { bg = "NONE" },
    tab_selected = { bg = "NONE" },
    tab_separator = { bg = "NONE" },
    tab_separator_selected = { bg = "NONE" },
    separator = { bg = "NONE" },
    separator_selected = { bg = "NONE" },
    separator_visible = { bg = "NONE" },
    buffer_visible = { bg = "NONE" },
    buffer_selected = { bg = "NONE", bold = true, italic = false },
    close_button = { bg = "NONE" },
    close_button_visible = { bg = "NONE" },
    close_button_selected = { bg = "NONE" },
    numbers = { bg = "NONE" },
    numbers_visible = { bg = "NONE" },
    numbers_selected = { bg = "NONE" },
    diagnostic = { bg = "NONE" },
    diagnostic_visible = { bg = "NONE" },
    diagnostic_selected = { bg = "NONE" },
    modified = { bg = "NONE" },
    modified_visible = { bg = "NONE" },
    modified_selected = { bg = "NONE" },
    duplicate = { bg = "NONE" },
    duplicate_visible = { bg = "NONE" },
    duplicate_selected = { bg = "NONE" },
    indicator_selected = { bg = "NONE" },
    indicator_visible = { bg = "NONE" },
    offset_separator = { bg = "NONE" },
  },
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    show_buffer_close_icons = true,
    show_close_icon = false,
    always_show_bufferline = true,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
      },
    },
  },
})

require('mini.pairs').setup({
  modes = { insert = true, command = false, terminal = false },
  mappings = {
    ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
    ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
    ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

    [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
    [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
    ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

    ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
    ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
    ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
  },
})

require("nvim-treesitter").setup({
  ensure_installed = {
    "lua",
    "python",
    "rust",
    "java",
    "json",
    "bash",
    "markdown"
  },
  highlight = { enable = true },
  indent = { enable = true }
})

require("treesitter-context").setup({
  max_lines = 0,
  min_window_height = 1,
  line_numbers = true,
  multiline_threshold = 1,
  trim_scope = "outer",
  mode = "topline",
  zindex = 20,
})

require("which-key").setup()

vim.lsp.enable({ "basedpyright", "ruff", "jdtls", "rust_analyzer", "lua_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local o = { buffer = event.buf }
    local map = vim.keymap.set

    map("n", "<Leader>gd", vim.lsp.buf.declaration, o)
    map("n", "<Leader>gi", vim.lsp.buf.implementation, o)
    map("n", "<Leader>go", vim.lsp.buf.type_definition, o)
    map("n", "<Leader>gr", vim.lsp.buf.references, o)
    map("n", "<Leader>gs", vim.lsp.buf.signature_help, o)
    map("n", "<Leader>gc", vim.lsp.buf.rename, o)
    map({ "n", "x" }, "<F3>", function() vim.lsp.buf.format({ 
      async = false,
      filter = function(client)
        return client.name ~= "ruff"
      end
    }) end, o)
    map("n", "<F4>", vim.lsp.buf.code_action, o)
    -- Explicit hover mapping
    map("n", "K", vim.lsp.buf.hover, o)
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go", "*.rs", "*.lua", "*.java" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
  desc = "Format Go files on save with gopls",
})

-- vim.defer_fn(function()  if vim.fn.exists(":Cord") == 2 then vim.cmd("Cord update") end end, 1000)

local map = vim.keymap.set

map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map({ "n", "x" }, "<leader>d", '"+d', { desc = "Delete to clipboard" })

map("n", "<leader><Left>", "<cmd>bp<cr>", { desc = "Previous buffer" })
map("n", "<leader><Right>", "<cmd>bn<cr>", { desc = "Next buffer" })
map("n", "<leader>bdd", "<cmd>%bd|edit#|bd#<cr>", { desc = "Close all buffers" })

map("n", "<leader>w", "<cmd>update<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "File explorer" })

map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fx", builtin.diagnostics, { desc = "Diagnostics" })

map({ "n", "v", "i" }, "<F1>", "<Nop>")

map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
map("n", "<leader>xx", vim.diagnostic.open_float)

vim.cmd.colorscheme("catppuccin-mocha")
vim.api.nvim_set_hl(0, "@lsp.type.number", { italic = true })
