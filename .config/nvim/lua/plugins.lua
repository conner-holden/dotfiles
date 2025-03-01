local plugins = {
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
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
  {"williamboman/mason.nvim", opts = {
    ui = { border = "rounded" },
  }},
  {"williamboman/mason-lspconfig.nvim", opts = {
    ensure_installed = {"lua_ls", "rust_analyzer"},
  }},
  {"neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      require("lspconfig").rust_analyzer.setup({})
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
      { out, "WarningMsg" },
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

