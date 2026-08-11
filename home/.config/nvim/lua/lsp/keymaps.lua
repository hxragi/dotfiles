vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set("n", "<Leader>gd", function() vim.lsp.buf.declaration() end,
      vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "<Leader>gi", function() vim.lsp.buf.implementation() end,
      vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "<Leader>go", function() vim.lsp.buf.type_definition() end,
      vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
    vim.keymap.set("n", "<Leader>gr", function() vim.lsp.buf.references() end,
      vim.tbl_extend("force", opts, { desc = "Show references" }))
    vim.keymap.set("n", "<Leader>gs", function() vim.lsp.buf.signature_help() end,
      vim.tbl_extend("force", opts, { desc = "Show signature help" }))
    vim.keymap.set("n", "<Leader>gc", function() vim.lsp.buf.rename() end,
      vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set({ "n", "x" }, "<F3>", function() vim.lsp.buf.format({ async = true }) end,
      vim.tbl_extend("force", opts, { desc = "Format buffer" }))
    vim.keymap.set("n", "<F4>", function() vim.lsp.buf.code_action() end,
      vim.tbl_extend("force", opts, { desc = "Code action" }))
  end,
})
