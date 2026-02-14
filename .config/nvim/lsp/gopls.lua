return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = {
    'go.work',
    'go.mod',
    '.git',
  },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      gofumpt = true, -- использует gofumpt вместо gofmt
      completeUnimported = true,
      usePlaceholders = true,
      semanticTokens = true,
      hints = { -- inlay hints, как в GoLand
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
