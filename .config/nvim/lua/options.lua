local o = vim.opt
local g = vim.g

o.cursorline = true
o.cmdheight = 0
o.hlsearch = false
o.ignorecase = false
o.expandtab = true
o.fillchars = { eob = ' ' }
o.number = true
o.shiftwidth = 2
o.signcolumn = 'yes'
o.smartcase = false
o.smartindent = true
o.tabstop = 2
o.timeoutlen = 200
o.undofile = true
g.mapleader = ' '
g.maplocalleader = ' '
o.shada = '\'1000,<100'
o.updatetime = 300
o.lazyredraw = true

-- disable builtin plugins
g.loaded_netrw = 1
g.loaded_gzip = 1
g.loaded_man = 1
g.loaded_matchit = 1
g.loaded_netrwPlugin = 1
g.loaded_osc52 = 1
g.loaded_rplugin = 1
g.loaded_spellfile = 1
g.loaded_tarPlugin = 1
g.loaded_tohtml = 1
g.loaded_tutor = 1
g.loaded_zipPlugin = 1
