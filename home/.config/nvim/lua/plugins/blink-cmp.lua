-- Blink CMP
local cmp = require('blink.cmp')

cmp.setup({
  keymap = { preset = 'enter' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 5000 },
    menu = {
      border = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    },
    trigger = { prefetch_on_insert = false },
  },
  signature = {
    enabled = false,
    trigger = {
      enabled = false,
      show_on_trigger_character = false,
      show_on_insert_on_trigger_character = false,
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'rust' },
})
