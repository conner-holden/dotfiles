local plugins = {
  'autopairs',
  -- 'avante',
  'blink',
  'comment',
  'comment_ts',
  'conform',
  'fidget',
  'flash',
  'gitsigns',
  'grugfar',
  'lspconfig',
  'mason',
  'mason_lspconfig',
  'mini',
  'nord',
  'outline',
  'rustaceanvim',
  'showkeys',
  'snacks',
  'telescope',
  'treesitter',
  'trouble',
}

local spec = {
  { 'nvim-tree/nvim-web-devicons', opts = {} },
}
for _, name in ipairs(plugins) do
  if name ~= 'init' then
    table.insert(spec, { import = 'plugins.' .. name })
  end
end

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
  spec = spec,
  install = { colorscheme = { 'nord' } },
  checker = { enabled = true, notify = false },
  rocks = { enabled = false },
  ui = {
    border = 'rounded',
  },
})
