return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline' },
  keys = { '<leader>o', '<cmd>Outline<cr>', desc = 'Outline symbols' },
  opts = {
    outline_window = {
      position = 'left',
      auto_jump = true,
      width = 25,
      relative_width = false,
    },
    outline_items = {
      show_symbol_details = false,
    },
  },
}
