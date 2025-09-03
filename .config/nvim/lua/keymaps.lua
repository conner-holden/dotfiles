local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')

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

local function xmap(lhs, rhs, desc)
  map('x', lhs, rhs, desc)
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
nmap('<A-q>', ':qa<cr>', 'Quit Neovim')
nmap('gd', vim.lsp.buf.definition, 'Go to definition')
nmap('g.', vim.lsp.buf.code_action, 'Code action')
nmap('gj', function()
  vim.diagnostic.goto_next({ buffer = 0 })
end, 'Go to next diagnostic')
nmap('gk', function()
  vim.diagnostic.goto_prev({ buffer = 0 })
end, 'Go to previous diagnostic')
-- Replace all instances of a word
nmap('<leader>r', function()
  local word = vim.fn.expand('<cword>')
  if word ~= '' then
    -- Save current cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    -- Create the pattern
    local pattern = '\\<' .. vim.fn.escape(word, '/\\') .. '\\>'

    -- Use feedkeys to simulate typing the search command
    vim.cmd('set hlsearch')
    vim.api.nvim_feedkeys('/' .. pattern .. '\n', 'n', false)

    -- Small delay to let the search complete, then restore position and get count
    vim.defer_fn(function()
      -- Restore cursor position
      vim.api.nvim_win_set_cursor(0, cursor_pos)

      local count = vim.fn.searchcount({ pattern = pattern, maxcount = 999 }).total

      if count > 0 then
        vim.ui.input({
          prompt = 'Replace ' .. count .. ' instances of "' .. word .. '" with: ',
        }, function(replacement)
          if replacement then
            local escaped_replacement = vim.fn.escape(replacement, '/\\')
            vim.cmd('%s/' .. pattern .. '/' .. escaped_replacement .. '/g')
            vim.cmd('nohlsearch')
            -- Restore cursor position after replacement
            vim.api.nvim_win_set_cursor(0, cursor_pos)
          else
            vim.cmd('nohlsearch')
          end
        end)
      else
        print('No instances of "' .. word .. '" found')
        vim.cmd('nohlsearch')
      end
    end, 10)
  end
end)

-- Telescope command line
nmap('<leader><leader>', ':Telescope cmdline<cr>', 'Telescope cmdline')

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
  for _, p in ipairs(pickers) do
    if p.preview_title == 'Search' then
      utils_grep.grep_without_snippet({ default_text = p.default_text, initial_mode = 'normal' })
      -- builtin.resume({ cache_index = i, initial_mode = 'normal' })

      -- Refresh results (taken from git picker)
      -- vim.defer_fn(function()
      --   local prompt_bufnr = vim.api.nvim_get_current_buf()
      --
      --   local picker = action_state.get_current_picker(prompt_bufnr)
      --
      --   -- temporarily register a callback which keeps selection on refresh
      --   -- local selection = picker:get_selection_row()
      --   -- local callbacks = { unpack(picker._completion_callbacks) } -- shallow copy
      --   -- picker:register_completion_callback(function(self)
      --   --   self:set_selection(selection)
      --   --   self._completion_callbacks = callbacks
      --   -- end)
      --
      --   -- refresh
      --   picker:refresh(nil, { reset_prompt = false })
      -- end, 50)

      return
    end
  end
  utils_grep.grep_without_snippet()
end, 'Search file')

-- Delete buffer
nmap('Q', ':bd<cr>', 'Delete buffer')
-- Previous buffer
nmap('H', ':bp<cr>', 'Go to previous buffer')
-- Next buffer
nmap('L', ':bn<cr>', 'Go to next buffer')

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

-- Snacks project picker
nmap('<leader>p', '<cmd>lua Snacks.picker.projects()<cr>', 'Search projects')

-- Flash
nmap('s', function()
  require('flash').jump()
end, 'Flash')

-- Oil
nmap('<A-E>', '<cmd>Oil<cr>', 'File navigator')

-- Visual mode
xmap('.', '>gv', 'Increase indent')
xmap(',', '<gv', 'Decrease indent')

-- Copy to system clipboard
xmap('<C-c>', '"+y', 'Copy to system clipboard')
xmap('<leader>y', '"+y', 'Copy to system clipboard')
nmap('<leader>y', '"+y', 'Copy to system clipboard')
-- Paste from system clipboard
imap('<C-v>', '<C-o>"+p', 'Paste from system clipboard')
nmap('<C-v>', '"+p', 'Paste from system clipboard')
