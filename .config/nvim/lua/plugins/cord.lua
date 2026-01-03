return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  opts = {
    idle = {
      enabled = false,
    },
    display = {
      theme = 'catppuccin',
    },
    text = {
      workspace = function(opts)
        local hour = tonumber(os.date('%H'))
        local status =
          hour >= 22 and '🌙 Late night coding' or
          hour >= 18 and '🌆 Evening session' or
          hour >= 12 and '☀️ Afternoon coding' or
          hour >= 5 and '🌅 Morning productivity'

        return string.format('%s: %s', status, opts.filename)
      end
    }
  },
}
