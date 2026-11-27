local capabilities = require("lsp.capabilities")

local servers = {
  "rust_analyzer",
  "jdtls",
  "lua_ls",
  "ty",
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

vim.lsp.config("jdtls", {
  root_markers = {
    { ".project", "src" },
    { "build.gradle", "build.gradle.kts", "pom.xml" },
    { "settings.gradle", "settings.gradle.kts", ".git" },
  },
})

vim.api.nvim_create_user_command("JdtlsClean", function()
  local cache_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace"
  vim.fn.delete(cache_dir, "rf")
  vim.notify("JDTLS workspace cache cleared", vim.log.levels.INFO)
  vim.cmd("LspRestart jdtls")
end, { desc = "Clear JDTLS workspace cache and restart" })

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
