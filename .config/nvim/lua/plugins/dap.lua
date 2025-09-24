return {
  'mfussenegger/nvim-dap',
  keys = {
    { '<leader>db', '<cmd>DapToggleBreakpoint<cr>', desc = 'Add breakpoint' },
    { '<leader>dr', '<cmd>DapContinue<cr>', desc = 'Start debugger' },
  },
}
