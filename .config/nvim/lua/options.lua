local o = vim.opt
local g = vim.g

function FilterFiletypes()
  local ft = vim.bo.filetype
  if ft == 'Trouble' then
    return ''
  end
  return vim.fn.expand('%:t')
end

function _G.TabLine()
  local s = ''
  local tab_count = vim.fn.tabpagenr('$')
  local current_tab = vim.fn.tabpagenr()

  for i = 1, tab_count do
    local highlight = (i == current_tab) and '%#TabLineSel#' or '%#TabLine#'
    local tab_cwd = vim.fn.getcwd(-1, i) -- CWD for tab i
    -- local tab_cwd = vim.fn.systemlist('git -C ' .. vim.fn.getcwd(-1, i) .. ' rev-parse --show-toplevel')[1]
    --   or vim.fn.getcwd(-1, i)
    local project_name = vim.fn.fnamemodify(tab_cwd, ':t') or '[No Name]'

    s = s .. string.format('%s%%%dT %s %%T', highlight, i, project_name)
  end

  s = s .. '%#TabLineFill#'
  return s
end

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
o.laststatus = 3
g.mapleader = ' '
g.maplocalleader = ' '
o.shada = '\'1000,<100'
o.statusline = '%{%v:lua.FilterFiletypes()%}%r%h%w'
o.updatetime = 300
o.lazyredraw = true
o.tabline = '%!v:lua.TabLine()'

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

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local is_empty = bufname == '' and vim.bo.filetype == ''

    if is_empty then
      vim.wo.number = false
      vim.wo.cursorline = false
    else
      vim.wo.number = true
      vim.wo.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.tf',
  callback = function()
    vim.bo.filetype = 'terraform'
  end,
})
