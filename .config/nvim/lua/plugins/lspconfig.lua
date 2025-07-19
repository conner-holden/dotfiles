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
    lsp.pyright.setup({
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            ignore = { '*' },
          },
        },
      },
    })
    lsp.ruff.setup({ capabilities = capabilities })
    lsp.svelte.setup({ capabilities = capabilities })
    lsp.vtsls.setup({ capabilities = capabilities })
    lsp.tailwindcss.setup({ capabilities = capabilities })
    lsp.terraformls.setup({ capabilities = capabilities })
    lsp.tflint.setup({})

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end
        if client.name == 'ruff' then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end
      end,
      desc = 'LSP: Disable hover capability from Ruff',
    })
  end,
}
