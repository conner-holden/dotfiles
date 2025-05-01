local plugins = {
  {
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
  },
  {
    'folke/snacks.nvim',
    opts = {
      explorer = {
        replace_netrw = true,
      },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            layout = {
              cycle = true,
              layout = {
                box = 'horizontal',
                position = 'float',
                height = 0.50,
                width = 0.50,
                border = 'rounded',
                {
                  box = 'vertical',
                  {
                    win = 'input',
                    height = 1,
                    title = '',
                    border = 'single',
                  },
                  { win = 'list' },
                },
                { win = 'preview', width = 0, border = 'left' },
              },
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
                  ['c'] = 'explorer_copy',
                  ['m'] = 'explorer_move',
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
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'simonmclean/triptych.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'nvim-tree/nvim-web-devicons', -- optional for icons
      'antosha417/nvim-lsp-file-operations', -- optional LSP integration
    },
    config = function()
      require('triptych').setup({
        options = {
          backdrop = 100,
          transparency = 0,
        },
      })
    end,
    keys = {
      { '<leader>-', ':Triptych<CR>' },
    },
  },
  {
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
  },
  { 'nvim-lua/plenary.nvim' },
  {
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
          prompt_prefix = '',
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
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        server = {
          handlers = {
            -- Hide indexing logs
            ['$/progress'] = function() end,
          },
        },
      }
    end,
  },
  {
    'MagicDuck/grug-far.nvim',
    version = '1.6.3',
    lazy = true,
    config = function()
      require('grug-far').setup()
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      ui = { border = 'rounded' },
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'lua_ls', 'rust_analyzer' },
    },
  },
  {
    'neovim/nvim-lspconfig',
    version = 'v1.8.0',
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lsp = require('lspconfig')
      lsp.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })
      lsp.svelte.setup({ capabilities = capabilities })
      lsp.vtsls.setup({ capabilities = capabilities })
      lsp.tailwindcss.setup({ capabilities = capabilities })
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
    },
  },
  { 'lewis6991/gitsigns.nvim', config = true, version = '1.0.2' },
  { 'JoosepAlviste/nvim-ts-context-commentstring', config = true },
  {
    'numToStr/Comment.nvim',
    lazy = true,
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    opts = {
      outline_window = {
        auto_jump = true,
        width = 25,
        relative_width = false,
      },
      outline_items = {
        show_symbol_details = false,
      },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {
      -- focus = true,
      -- auto_preview = false,
      -- win = {
      --   type = 'float',
      --   border = 'rounded',
      -- },
      -- keys = {
      --   ['<cr>'] = 'jump_close',
      -- },
    },
    cmd = 'Trouble',
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  -- {
  --   'lukas-reineke/indent-blankline.nvim',
  --   main = 'ibl',
  --   config = function()
  --     vim.api.nvim_set_hl(0, 'IndentMuted', { fg = '#3b4252', nocombine = true }) -- very muted gray (Nord palette)
  --     require('ibl').setup({
  --       indent = {
  --         char = '╎',
  --         highlight = { 'IndentMuted' },
  --       },
  --       scope = {
  --         enabled = false,
  --       },
  --     })
  --   end,
  -- },
  {
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
    -- dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    lazy = false,
  },
  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.pick').setup()
      require('mini.cursorword').setup()
      require('mini.notify').setup()
      require('mini.surround').setup()
      local miniclue = require('mini.clue')
      miniclue.setup({
        window = {
          config = {
            width = 40,
          },
        },
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = '\'' },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = '\'' },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },
        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
  },
}

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out =
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = plugins,
  install = { colorscheme = { 'nord' } },
  checker = { enabled = true, notify = false, concurrency = 1 },
  rocks = { enabled = false },
})
