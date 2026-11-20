local fzf = require("fzf-lua")

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set("n", "gd", function()
      fzf.lsp_definitions()
    end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))

    vim.keymap.set("n", "<Leader>gd", function()
      fzf.lsp_definitions()
    end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))

    vim.keymap.set("n", "gD", function()
      vim.lsp.buf.declaration()
    end, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

    vim.keymap.set("n", "<Leader>gD", function()
      vim.lsp.buf.declaration()
    end, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

    vim.keymap.set("n", "<Leader>gi", function()
      fzf.lsp_implementations()
    end, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))

    vim.keymap.set("n", "<Leader>go", function()
      fzf.lsp_typedefs()
    end, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

    vim.keymap.set("n", "<Leader>gr", function()
      fzf.lsp_references()
    end, vim.tbl_extend("force", opts, { desc = "Show references" }))

    vim.keymap.set("n", "<Leader>gs", function()
      vim.lsp.buf.signature_help()
    end, vim.tbl_extend("force", opts, { desc = "Show signature help" }))

    vim.keymap.set("n", "<Leader>gc", function()
      vim.lsp.buf.rename()
    end, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

    vim.keymap.set("n", "<Leader>ds", function()
      fzf.lsp_document_symbols()
    end, vim.tbl_extend("force", opts, { desc = "Document symbols" }))

    vim.keymap.set("n", "<Leader>ws", function()
      fzf.lsp_live_workspace_symbols()
    end, vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))

    vim.keymap.set("n", "<Leader>ld", function()
      fzf.diagnostics_document()
    end, vim.tbl_extend("force", opts, { desc = "Document diagnostics" }))

    vim.keymap.set({ "n", "x" }, "<F3>", function()
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ async = true, lsp_format = "fallback" })
      else
        vim.lsp.buf.format({ async = true })
      end
    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))

    vim.keymap.set({ "n", "x" }, "<F4>", function()
      fzf.lsp_code_actions()
    end, vim.tbl_extend("force", opts, { desc = "Code action" }))

    vim.keymap.set({ "n", "x" }, "<Leader>ca", function()
      fzf.lsp_code_actions()
    end, vim.tbl_extend("force", opts, { desc = "Code action" }))
  end,
})
