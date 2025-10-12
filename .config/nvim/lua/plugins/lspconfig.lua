return {
  'neovim/nvim-lspconfig',
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local lsp = vim.lsp

    lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
    lsp.config('pyright', {
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
    lsp.config('ruff', { capabilities = capabilities })
    lsp.config('svelte', {
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
    lsp.config('vtsls', {
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
    lsp.config('tailwindcss', { capabilities = capabilities })
    lsp.config('terraformls', { capabilities = capabilities })
    lsp.enable('tflint')
    lsp.enable('gopls')
    lsp.enable('golangci_lint_ls')
    lsp.config('clangd', {
      on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        -- on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    })

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
