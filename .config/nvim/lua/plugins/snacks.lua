return {
  'folke/snacks.nvim',
  opts = {
    explorer = {
      replace_netrw = true,
    },
    picker = {
      prompt = '❯ ',
      sources = {
        explorer = {
          hidden = true,
          layout = {
            cycle = true,
            layout = {
              box = 'vertical',
              height = 0.50,
              width = 0.50,
              position = 'float',
              {
                win = 'input',
                height = 1,
                title = '',
                border = 'rounded',
              },
              { win = 'list', border = 'rounded' },
            },
            { win = 'preview', width = 0, border = 'left' },
          },
          focus = 'input',
          config = function(opts)
            local actions = require('snacks.explorer.actions')
            function actions.actions.confirm(picker, item, action)
              if not item then
                return
              elseif item.dir then
                require('snacks.explorer.tree'):toggle(item.file)
                actions.update(picker, { refresh = true })
              else
                require('snacks').picker.actions.jump(picker, item, action)
                require('snacks').picker.actions.close(picker, item, action)
              end
            end
            vim.api.nvim_set_hl(0, 'SnacksPickerPathHidden', { bg = 'none', fg = '#7b818e' })
            return require('snacks.picker.source.explorer').setup(opts)
          end,
          win = {
            input = {
              keys = {
                ['l'] = 'confirm',
                ['h'] = 'explorer_close',
                ['a'] = 'explorer_add',
                ['d'] = 'explorer_del',
                ['r'] = 'explorer_rename',
                ['m'] = 'explorer_move',
                ['<A-e>'] = { 'close', mode = 'i' },
              },
            },
          },
        },
        projects = {
          win = {},
        },
      },
    },
  },
}
