vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.wo.number = true -- Enable absolute line numbers

vim.opt.showcmd = true
vim.opt.nu = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.laststatus = 2
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.updatetime = 700

vim.opt.signcolumn = "yes"

vim.opt.list = true

vim.g.termguicolors = true
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.wildmenu = true
vim.opt.listchars = "tab:»·,trail:·,nbsp:·"
vim.diagnostic.config({ virtual_text = true })

vim.opt.laststatus = 3

vim.lsp.set_log_level("info")

vim.opt.mousescroll = "ver:0,hor:0"
vim.opt.mouse = ""

vim.lsp.set_log_level("warn")
