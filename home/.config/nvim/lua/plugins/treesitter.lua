-- Treesitter
require('nvim-treesitter').setup()

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust", "java", "lua", "python", "bash", "yaml", "toml", "vim", "vimdoc", "markdown" },
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    if vim.treesitter.language.add(lang) then
      vim.treesitter.start()
    end
  end,
})
