local ok, conform = pcall(require, "conform")
if not ok then
  return
end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "ruff_organize_imports" },
    rust = { "rustfmt" },
    nix = { "nixfmt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    toml = { "taplo" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})
