return {
  'neovim/nvim-lspconfig',
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
    lsp.svelte.setup({
      capabilities = capabilities,
      settings = {
        svelte = {
          plugin = {
            svelte = {
              compilerWarnings = {
                ['a11y-autofocus'] = 'ignore',
              },
            },
          },
        },
      },
    })
    lsp.vtsls.setup({
      capabilities = capabilities,
      settings = {
        typescript = {
          preferences = {
            watchDirectory = 'useFsEvents',
          },
        },
        vtsls = {
          autoUseWorkspaceTsdk = true,
        },
      },
    })
    lsp.tailwindcss.setup({ capabilities = capabilities })
    lsp.terraformls.setup({ capabilities = capabilities })
    lsp.tflint.setup({})
    lsp.kotlin_language_server.setup({})
    lsp.gopls.setup({})
    lsp.golangci_lint_ls.setup({})

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

    -- Generic function to create LSP refresh autocmds
    local function create_lsp_refresh_autocmd(patterns, client_names, description)
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        pattern = patterns,
        callback = function()
          for _, client in pairs(vim.lsp.get_active_clients()) do
            if vim.tbl_contains(client_names, client.name) then
              vim.schedule(function()
                client.notify('workspace/didChangeWatchedFiles', {
                  changes = {
                    {
                      uri = vim.uri_from_fname(vim.fn.expand('%:p')),
                      type = 2, -- Changed
                    },
                  },
                })
              end)
            end
          end
        end,
        desc = description,
      })
    end

    create_lsp_refresh_autocmd(
      { '**/src/**/*.ts', '**/src/**/*.js', '**/*.d.ts' },
      { 'vtsls', 'svelte' },
      'Refresh LSP when TypeScript files change'
    )

    create_lsp_refresh_autocmd(
      { '*.tf', '*.tfvars', '*.hcl' },
      { 'terraformls', 'tflint' },
      'Refresh LSP when Terraform files change'
    )
  end,
}
