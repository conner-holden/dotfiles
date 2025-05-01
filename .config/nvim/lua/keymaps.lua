local builtin = require('telescope.builtin')

local utils_grep = require('utils.grep')

-- Custom map function with default silent = true
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent == nil and true or opts.silent -- Default silent = true if not provided
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Mode-specific functions
local function nmap(lhs, rhs, opts)
  map('n', lhs, rhs, opts)
end

local function imap(lhs, rhs, opts)
  map('i', lhs, rhs, opts)
end

local function vmap(lhs, rhs, opts)
  map('v', lhs, rhs, opts)
end

-- Format code and write file
nmap('<A-w>', function()
  require('conform').format()
  vim.cmd('silent write')
  vim.schedule(function()
    vim.cmd('redraw')
  end)
end)

-- Insert mode
imap('jk', '<Esc>')
imap('<C-v>', '<C-o>"+p')

-- Normal mode
nmap('<A-q>', ':qa<CR>')
nmap('gd', vim.lsp.buf.definition)
nmap('g.', vim.lsp.buf.code_action)
nmap('gj', function()
  vim.diagnostic.goto_next({ buffer = 0 })
end)
nmap('gk', function()
  vim.diagnostic.goto_prev({ buffer = 0 })
end)

-- Telescope command line
nmap('<leader><leader>', ':Telescope cmdline<CR>')

-- Telescope file search
nmap('<leader>f', function()
  require('telescope.builtin').find_files({
    hidden = true,
    prompt_title = false,
    previewer = false,
  })
end)

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
end)

-- Delete buffer
nmap('Q', ':bd<CR>')
-- Previous buffer
nmap('H', ':bp<CR>')
-- Next buffer
nmap('L', ':bn<CR>')

-- Trouble.nvim
nmap('<leader>xp', '<cmd>silent! Trouble diagnostics toggle<cr>')
nmap('<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>')
nmap(
  '<leader>xe',
  '<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>'
)

-- Outline
nmap('<leader>xs', '<cmd>Outline<cr>')

-- grug-far
nmap('<leader>sp', function()
  require('grug-far').open({ transient = true })
end)
nmap('<leader>sw', function()
  require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
end)
nmap('<leader>sf', function()
  require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
end)

-- Snacks explorer
nmap('<A-e>', '<cmd>lua Snacks.explorer()<cr>')

-- Snacks help picker
nmap('<leader>h', '<cmd>lua Snacks.picker.help()<cr>')

-- Snacks keymap picker
nmap('<leader>k', '<cmd>lua Snacks.picker.keymaps()<cr>')

-- Snacks jumps picker
nmap('<leader>j', '<cmd>lua Snacks.picker.jumps()<cr>')

-- Snacks buffer picker
nmap('<leader>b', '<cmd>lua Snacks.picker.buffers()<cr>')

-- Oil
nmap('<A-E>', '<cmd>Oil<cr>')

-- Visual mode
vmap('.', '>gv')
vmap(',', '<gv')

-- Copy to system clipboard
vmap('<C-c>', '"+y')
vmap('<leader>y', '"+y')
nmap('<leader>y', '"+y')
-- Paste from system clipboard
nmap('<C-v>', '"+p', { silent = true })
nmap('<leader>p', '"+p', { silent = true })
