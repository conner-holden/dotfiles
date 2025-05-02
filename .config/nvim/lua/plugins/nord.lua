return {
  'gbprod/nord.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('nord').setup({
      transparent = true,
    })
    vim.cmd.colorscheme('nord')

    vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none', bold = true, italic = true })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none', italic = true })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none', fg = '#d8dee9' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = '#4c566a' })
    vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'none', fg = '#3b4252' })
  end,
}
