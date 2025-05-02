return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        handlers = {
          ['$/progress'] = function() end, -- Hide indexing logs
        },
      },
    }
  end,
}
