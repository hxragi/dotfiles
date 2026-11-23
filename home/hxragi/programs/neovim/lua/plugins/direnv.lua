local direnv = require("direnv")

direnv.setup({
  autoload_direnv = true,
  auto_restart_lsp = true,
  merge_path = true,
  notifications = {
    silent_autoload = true,
  },
})

-- Если файл открыт в другом проекте, переключаем cwd через vim.schedule,
-- чтобы не конфликтовать с внутренним процессом загрузки буфера (избегая E201).
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("DirenvAutoRoot", { clear = true }),
  callback = function(args)
    local file = args.file
    if file == "" or vim.startswith(file, "term://") or vim.startswith(file, "nofile") then
      return
    end
    local root = vim.fs.root(file, { ".envrc", ".git" })
    if root and root ~= vim.uv.cwd() then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) and root ~= vim.uv.cwd() then
          pcall(vim.api.nvim_set_current_dir, root)
        end
      end)
    end
  end,
})
