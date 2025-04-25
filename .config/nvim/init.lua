local o = vim.opt
local g = vim.g

o.cursorline = true
o.cmdheight = 0
o.hlsearch = false
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
g.maplocalleader = " "
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_winsize = 15

vim.cmd [[
  inoremap jk <Esc>
  nnoremap <A-w> :w<CR>
  nnoremap <A-q> :qa<CR>
  nnoremap gd :lua vim.lsp.buf.definition()<CR>
  nnoremap g. :lua vim.lsp.buf.code_action()<CR>
  nnoremap gj :lua vim.diagnostic.goto_next({buffer=0})<CR>
  nnoremap gk :lua vim.diagnostic.goto_prev({buffer=0})<CR>
  vnoremap . >gv
  vnoremap , <gv
  vnoremap <C-c> "+y
  nnoremap <C-v> "+p
  inoremap <C-v> <C-o>"+p
  nnoremap <leader><leader> :Telescope cmdline<CR>
  nnoremap <leader>f :Telescope find_files<CR>
  nnoremap Q :bd<CR>
  nnoremap <C-E> :windo normal! <C-e>
  nnoremap <C-Y> :windo normal! <C-y>
  nnoremap <leader>xp <cmd>Trouble diagnostics toggle<cr>
  nnoremap <leader>xb <cmd>Trouble diagnostics toggle filter.buf=0<cr>
  nnoremap <leader>xe <cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>
  nnoremap <leader>xs <cmd>Trouble symbols toggle focus=false<cr>
  nnoremap <leader>sp <cmd>lua require("grug-far").open({ transient = true })<cr>
  nnoremap <leader>sw <cmd>lua require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })<cr>
  nnoremap <leader>sf <cmd>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })<cr>
]]

vim.api.nvim_set_keymap('n', '<A-e>',
  ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false); MiniFiles.reveal_cwd()<CR>',
  { noremap = true, silent = true })

vim.diagnostic.config({
  signs = false,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.filetype.add({
  extension = {
    postcss = "css",
  },
})

local original_text_document_definition = vim.lsp.handlers['textDocument/definition']
local function test_definition(err, result, ...)
  if result and #result > 1 then
    local seen = {}
    local unique_results = {}

    for _, res in ipairs(result) do
      local uri = res.targetUri
      if not seen[uri] then
        table.insert(unique_results, res)
        seen[uri] = true
      end
    end
    return original_text_document_definition(err, unique_results, ...)
  end
  return original_text_document_definition(err, result, ...)
end

vim.lsp.handlers["textDocument/definition"] = test_definition

require("plugins")
