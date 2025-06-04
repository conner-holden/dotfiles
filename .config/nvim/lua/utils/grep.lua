local M = {}

local builtin = require('telescope.builtin')
local make_entry = require('telescope.make_entry')
local entry_display = require('telescope.pickers.entry_display')
local devicons = require('nvim-web-devicons')
local Path = require('plenary.path')

function M.grep_without_snippet()
  builtin.live_grep({
    hidden = true,
    prompt_title = false,
    preview_title = 'Search',
    entry_maker = function(entry)
      local item = make_entry.gen_from_vimgrep({})(entry)

      if not item or not item.filename or not item.lnum then
        return item
      end

      local relative_filename = Path:new(item.filename):make_relative(vim.loop.cwd())
      local file_line = string.format('%s:%d', relative_filename, item.lnum)

      local icon, iconhl = devicons.get_icon(relative_filename, nil, { default = true })

      local displayer = entry_display.create({
        separator = ' ',
        items = {
          { width = 2 }, -- icon
          { width = 50 }, -- file:line
          { remaining = true }, -- (blank — no snippet)
        },
      })

      item.display = function()
        return displayer({
          { icon, iconhl },
          file_line,
          '', -- no match text
        })
      end

      item.ordinal = file_line
      item.value = entry

      return item
    end,
  })
end

return M
