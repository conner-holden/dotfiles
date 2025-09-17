return {
  'folke/snacks.nvim',
  opts = {
    explorer = {
      replace_netrw = true,
    },
    picker = {
      prompt = ' ❯',
      sources = {
        explorer = {
          hidden = true,
          layout = {
            cycle = true,
            layout = {
              box = 'vertical',
              height = 0.80,
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
            local Snacks = require('snacks')
            local Actions = require('snacks.picker.actions')
            local Explorer = require('snacks.explorer.actions')

            function Explorer.actions.confirm(picker, item, action)
              if not item then
                return
              elseif item.dir then
                require('snacks.explorer.tree'):toggle(item.file)
                Explorer.update(picker, { refresh = true })
              else
                Actions.jump(picker, item, action)
                Actions.close(picker, item, action)
              end
            end

            function Actions.load_session(picker, item)
              picker:close()
              if not item then
                return
              end
              local dir = item.file
              local session_loaded = false
              vim.api.nvim_create_autocmd('SessionLoadPost', {
                once = true,
                callback = function()
                  session_loaded = true
                end,
              })
              vim.defer_fn(function()
                if not session_loaded then
                  Snacks.picker.explorer()
                end
              end, 100)
              vim.fn.chdir(dir)
              local session = Snacks.dashboard.sections.session()
              if session then
                vim.cmd(session.action:sub(2))
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
                ['<C-a>'] = 'explorer_add',
                ['<C-d>'] = 'explorer_del',
                ['r'] = 'explorer_rename',
                ['m'] = 'explorer_move',
                ['<C-i>'] = 'toggle_ignored',
                ['<C-h>'] = 'toggle_hidden',
                ['<A-e>'] = { 'close', mode = 'i' },
                ['<esc>'] = { 'close', mode = 'i' },
              },
            },
          },
        },
        projects = {
          win = {
            input = {
              keys = {
                ['<c-t>'] = {
                  function(picker)
                    local snacks = require('snacks')
                    vim.cmd('tabnew')
                    snacks.notify('New tab opened')
                    picker:close()
                    -- snacks.picker.projects()
                  end,
                  mode = { 'n', 'i' },
                },
              },
            },
          },
        },
      },
    },
  },
}
