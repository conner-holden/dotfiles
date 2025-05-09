return {
  'neovim/nvim-lspconfig',
  version = 'v1.8.0',
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local lsp = require('lspconfig')
    lsp.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    })
    lsp.svelte.setup({ capabilities = capabilities })
    lsp.vtsls.setup({ capabilities = capabilities })
    lsp.tailwindcss.setup({ capabilities = capabilities })
    lsp.terraformls.setup({ capabilities = capabilities })
    lsp.tflint.setup({})
  end,
}
