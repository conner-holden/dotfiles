return {
  'stevearc/oil.nvim',
  opts = {
    default_file_explorer = false,
    keymaps = {
      ['h'] = { 'actions.parent', mode = 'n' },
      ['l'] = { 'actions.select', mode = 'n' },
      ['q'] = { 'actions.close', mode = 'n' },
      ['<A-E>'] = { 'actions.close', mode = 'n' },
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
}
