return {
  'folke/trouble.nvim',
  opts = {
    modes = {
      lsp_references = {
        focus = true,
        format = '{text:ts}',
      },
    },
  },

  cmd = 'Trouble',
}
