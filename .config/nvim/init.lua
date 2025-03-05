local o = vim.opt
local g = vim.g

o.ignorecase = false
o.expandtab = true
o.fillchars = { eob = " " }
o.number = true
o.shiftwidth = 2
o.signcolumn = "yes"
o.smartcase = false
o.smartindent = true
o.tabstop = 2
o.timeoutlen = 200
o.undofile = true
g.mapleader = " "
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_winsize = 15

vim.cmd [[
  inoremap jk <Esc>
  nnoremap <A-e> :lua MiniFiles.open()<CR>
  nnoremap <A-w> :w<CR>
  nnoremap <A-q> :qa<CR>
  nnoremap gd :lua vim.lsp.buf.definition()<CR>
  nnoremap gj :lua vim.diagnostic.goto_next({buffer=0})<CR>
  nnoremap gk :lua vim.diagnostic.goto_prev({buffer=0})<CR>
  vnoremap . >gv
  vnoremap , <gv
  vnoremap <C-c> "+y
  nnoremap <C-v> "+p
  inoremap <C-v> <C-o>"+p
  nnoremap <leader><leader> :Telescope cmdline<CR>
]]

vim.diagnostic.config({
  signs = false,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

require("plugins")
