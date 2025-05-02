return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'jonarrien/telescope-cmdline.nvim',
  },
  lazy = false,
  config = function()
    require('telescope').setup({
      defaults = {
        layout_strategy = 'vertical',
        results_title = false,
        prompt_title = false,
        prompt_prefix = '❯ ',
        selection_caret = '  ',
        cache_picker = {
          num_pickers = -1, -- No limits on caching. Change if performance problems occur.
        },
        vimgrep_arguments = {
          'rg',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--hidden',
          '--smart-case',
          '--glob',
          '!**/.git/*',
        },
        mappings = {
          i = {
            ['<esc>'] = require('telescope.actions').close,
          },
          n = {
            ['q'] = require('telescope.actions').close,
          },
        },
      },
    })
    require('telescope').load_extension('cmdline')
  end,
}
