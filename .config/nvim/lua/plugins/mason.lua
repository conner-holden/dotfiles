return {
  'williamboman/mason.nvim',
  opts = {
    ensure_installed = { 'tflint', 'terraform-ls' },
    ui = { border = 'rounded' },
  },
}
