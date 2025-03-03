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
    end
  },
  { "lewis6991/gitsigns.nvim", config = true },
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
      require("mini.files").setup()
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
