return {
  'williamboman/mason.nvim',
  opts = {
    ensure_installed = { 'tflint', 'terraform-ls', 'clangd', 'codelldb' },
    ui = { border = 'rounded' },
  },
}
