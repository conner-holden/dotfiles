return {
  'MagicDuck/grug-far.nvim',
  version = '1.6.3',
  lazy = true,
  config = function()
    require('grug-far').setup()
  end,
}
