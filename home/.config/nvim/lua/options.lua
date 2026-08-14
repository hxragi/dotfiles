local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.showcmd = true
opt.signcolumn = "yes"
opt.laststatus = 3
opt.scrolloff = 8
opt.termguicolors = true
opt.fillchars = { eob = " " }
opt.list = true
opt.listchars = {
  tab = "»·",
  trail = "·",
  nbsp = "·",
}
opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"

-- Editing
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.clipboard = "unnamedplus"

-- Performance & Behavior
opt.backup = false
opt.swapfile = false
opt.writebackup = false
opt.updatetime = 300
opt.timeoutlen = 500
opt.fixeol = true
opt.mousescroll = "ver:0,hor:0"
opt.mouse = ""

-- Providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Diagnostics & LSP Logs
vim.diagnostic.config({ virtual_text = true })
vim.lsp.log.set_level("warn")
