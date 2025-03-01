local o = vim.opt
local g = vim.g

o.ignorecase = false
o.clipboard = "unnamedplus"
o.fillchars = { eob = " " }
o.number = true
o.statuscolumn = "%l  "
o.smartcase = true
o.smartindent = true
o.smarttab = true
o.expandtab = true
o.tabstop = 2
o.timeoutlen = 200
o.undofile = true
g.mapleader = " "
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_winsize = 15

vim.cmd [[
  inoremap jk <Esc>
  nnoremap <A-e> :Lexplore %:p:h<CR>
  nnoremap <A-w> :w<CR>
  nnoremap <A-q> :qa<CR>
  vnoremap jk <Esc>
  vnoremap . >gv
  vnoremap , <gv
  vnoremap <C-c> "+y
  nnoremap <C-v> "+p
  inoremap <C-v> <C-o>"+p
]]

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "netrw" },
  callback = function()
    vim.cmd [[
      nmap <buffer> l <CR>
      nmap <buffer> L <CR>:Lexplore<CR>
    ]]
  end,
})

require("plugins")

