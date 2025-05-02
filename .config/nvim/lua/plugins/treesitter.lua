return {
  'nvim-treesitter/nvim-treesitter',
  tag = 'v0.9.3',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      highlight = { enable = true },
      autopairs = { enable = true },
      indent = { enable = true },
    })
  end,
}
