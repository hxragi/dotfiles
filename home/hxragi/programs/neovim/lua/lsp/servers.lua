local capabilities = require("lsp.capabilities")

local servers = {
  "rust_analyzer",
  "jdtls",
  "lua_ls",
  "basedpyright",
  "ruff",
  "yamlls",
  "nixd",
  "solidity_ls",
  "forge_lsp",
}

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("forge_lsp", {
  cmd = { "forge", "lsp" },
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable(servers)
