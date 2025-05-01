local builtin = require('telescope.builtin')

local utils_grep = require('utils.grep')

-- Custom map function with default silent = true
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc or '', silent = true })
end

-- Mode-specific functions
local function nmap(lhs, rhs, desc)
  map('n', lhs, rhs, desc)
end

local function imap(lhs, rhs, desc)
  map('i', lhs, rhs, desc)
end

local function vmap(lhs, rhs, desc)
  map('v', lhs, rhs, desc)
end

-- Format code and write file
nmap('<A-w>', function()
  require('conform').format()
  vim.cmd('silent write')
  vim.schedule(function()
    vim.cmd('redraw')
  end)
end, 'Write file and format code')

-- Insert mode
imap('jk', '<Esc>', 'Exit insert mode')

-- Normal mode
nmap('<A-q>', ':qa<CR>')
nmap('gd', vim.lsp.buf.definition, 'Go to definition')
nmap('g.', vim.lsp.buf.code_action, 'Code action')
nmap('gj', function()
  vim.diagnostic.goto_next({ buffer = 0 })
end, 'Go to next diagnostic')
nmap('gk', function()
  vim.diagnostic.goto_prev({ buffer = 0 })
end, 'Go to previous diagnostic')

-- Telescope command line
nmap('<leader><leader>', ':Telescope cmdline<CR>', 'Telescope cmdline')

-- Telescope file search
nmap('<leader>f', function()
  require('telescope.builtin').find_files({
    hidden = true,
    prompt_title = false,
    previewer = false,
  })
end, 'Find files')

-- Telescope grep without extra result text and automatic search restoration
nmap('<A-f>', function()
  local pickers = require('telescope.state').get_global_key('cached_pickers')
  if pickers == nil then
    utils_grep.grep_without_snippet()
    return
  end
  for i, v in ipairs(pickers) do
    if v.prompt_title == 'Live Grep' then
      builtin.resume({ cache_index = i, initial_mode = 'normal' })
      return
    end
  end
  utils_grep.grep_without_snippet()
end, 'Search file')

-- Delete buffer
nmap('Q', ':bd<CR>', 'Delete buffer')
-- Previous buffer
nmap('H', ':bp<CR>', 'Go to previous buffer')
-- Next buffer
nmap('L', ':bn<CR>', 'Go to next buffer')

-- Trouble.nvim
nmap('<leader>xp', '<cmd>silent! Trouble diagnostics toggle<cr>', 'Trouble project diagnostics')
nmap('<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', 'Trouble buffer diagnostics')
nmap(
  '<leader>xe',
  '<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>',
  'Trouble errors'
)

-- Outline
nmap('<leader>xs', '<cmd>Outline<cr>', 'Outline symbols')

-- grug-far
nmap('<leader>sp', function()
  require('grug-far').open({ transient = true })
end, 'Search and replace')
nmap('<leader>sw', function()
  require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
end, 'Search and replace current word')
nmap('<leader>sf', function()
  require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
end, 'Search and replace current file')

-- Snacks explorer
nmap('<A-e>', '<cmd>lua Snacks.explorer()<cr>', 'File explorer')

-- Snacks help picker
nmap('<leader>h', '<cmd>lua Snacks.picker.help()<cr>', 'Search help')

-- Snacks keymap picker
nmap('<leader>k', '<cmd>lua Snacks.picker.keymaps()<cr>', 'Search keymaps')

-- Snacks jumps picker
nmap('<leader>j', '<cmd>lua Snacks.picker.jumps()<cr>', 'Search jumps')

-- Snacks buffer picker
nmap('<leader>b', '<cmd>lua Snacks.picker.buffers()<cr>', 'Search buffers')

-- Oil
nmap('<A-E>', '<cmd>Oil<cr>', 'File navigator')

-- Visual mode
vmap('.', '>gv', 'Increase indent')
vmap(',', '<gv', 'Decrease indent')

-- Copy to system clipboard
vmap('<C-c>', '"+y', 'Copy to system clipboard')
vmap('<leader>y', '"+y', 'Copy to system clipboard')
nmap('<leader>y', '"+y', 'Copy to system clipboard')
-- Paste from system clipboard
imap('<C-v>', '<C-o>"+p', 'Paste from system clipboard')
nmap('<C-v>', '"+p', 'Paste from system clipboard')
nmap('<leader>p', '"+p', 'Paste from system clipboard')
