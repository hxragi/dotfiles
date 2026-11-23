local direnv = require("direnv")

direnv.setup({
  autoload_direnv = true,
  auto_restart_lsp = true,
  merge_path = true,
  notifications = {
    silent_autoload = true,
  },
})

-- Если файл открывается вне текущего cwd (например, nvim /path/to/project/file),
-- переключаем cwd на корень проекта до определения FileType, чтобы direnv успел
-- инициализировать окружение для LSP.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("DirenvAutoRoot", { clear = true }),
  callback = function(args)
    local file = args.file
    if file == "" or vim.startswith(file, "term://") or vim.startswith(file, "nofile") then
      return
    end
    local root = vim.fs.root(file, { ".envrc", ".git" })
    if root and root ~= vim.uv.cwd() then
      vim.api.nvim_set_current_dir(root)
    end
  end,
})
