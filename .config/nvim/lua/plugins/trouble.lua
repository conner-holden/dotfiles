return {
  'folke/trouble.nvim',
  config = function()
    require('trouble').setup({
      modes = {
        lsp_references = {
          focus = true,
          format = '{text:ts}',
          groups = {
            { 'filename', format = '{filename}' },
          },
        },
        lsp_implementations = {
          focus = true,
          format = '{text:ts}',
          groups = {
            { 'filename', format = '{filename}' },
          },
        },
      },
      win = {
        position = 'right',
        size = { width = vim.o.columns / 2 },
      },
    })
    vim.api.nvim_set_hl(0, 'TroubleFilename', { bold = true, italic = true, fg = '#616e88' })
  end,
  cmd = 'Trouble',
}
