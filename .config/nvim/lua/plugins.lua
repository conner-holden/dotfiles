local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        autopairs = { enable = true },
        indent = { enable = true },
      })
    end
  },

  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup({
        transparent = true,
      })
      vim.cmd.colorscheme("nord")
    end,
  },
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jonarrien/telescope-cmdline.nvim",
    },
    lazy = false,
    config = function()
      require("telescope").setup({
        defaults = {
          cache_picker = {
            num_pickers = -1, -- No limits on caching. Change if performance problems occur.
          },
          vimgrep_arguments = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",
            "--smart-case",
            "--glob",
            "!**/.git/*",
          },
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
            },
            n = {
              ["q"] = require("telescope.actions").close,
            },
          },
        },
      })
      require("telescope").load_extension("cmdline")

      -- Open cached live_grep picker if it exists, otherwise spawn a new one
      vim.keymap.set("n", "<A-f>", function()
        local builtin = require("telescope.builtin")
        local pickers = require("telescope.state").get_global_key("cached_pickers")
        if pickers == nil then
          builtin.live_grep()
          return
        end
        for i, v in ipairs(pickers) do
          if v.prompt_title == "Live Grep" then
            builtin.resume({ cache_index = i, initial_mode = "normal" })
            return
          end
        end
        builtin.live_grep()
      end, { silent = true, noremap = true })
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    config = function()
      require("spectre").setup({
        live_update = true,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "spectre_panel" },
        callback = function()
          vim.wo.number = false
        end,
      })
    end
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require("grug-far").setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
        -- be specified
      });
    end
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    }
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer" },
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require("lspconfig")
      lsp.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      lsp.rust_analyzer.setup({})
      lsp.svelte.setup({})
      lsp.vtsls.setup({})
      lsp.tailwindcss.setup({})
    end
  },
  { "lewis6991/gitsigns.nvim",                     config = true },
  { "JoosepAlviste/nvim-ts-context-commentstring", config = true },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        section_separators = '',
        component_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'diff', { 'diagnostics', padding = { left = 0, right = 1 } } },
        lualine_y = { { 'branch', icons_enabled = false, color = { gui = "italic,bold" } } },
        lualine_z = {},
      },
    }
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.files").setup({
        mappings = {
          go_in_plus = "l",
          go_in = "L",
        },
      })

      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          local cur_target = require("mini.files").get_explorer_state().target_window
          local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. ' split')
            return vim.api.nvim_get_current_win()
          end)

          require("mini.files").set_target_window(new_target)
          require("mini.files").go_in({ close_on_file = true })
        end
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          map_split(buf_id, '<C-h>', 'belowright horizontal')
          map_split(buf_id, '<C-v>', 'belowright vertical')
        end,
      })
      require("mini.pick").setup()
      require("mini.completion").setup()
      require("mini.cursorword").setup()
      require("mini.indentscope").setup()
      require("mini.notify").setup()
      require("mini.surround").setup()
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
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
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
    end
  },
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = plugins,
  install = { colorscheme = { "nord" } },
  checker = { enabled = true },
  rocks = { enabled = false },
})
