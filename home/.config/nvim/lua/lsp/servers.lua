local capabilities = require("lsp.capabilities")

local servers = {
  'rust_analyzer',
  'jdtls',
  'lua_ls',
  'basedpyright',
  'ruff',
  'yamlls',
  'nixd',
}

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable(servers)
