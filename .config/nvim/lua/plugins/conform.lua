return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      rust = { 'rustfmt' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
  },
}
