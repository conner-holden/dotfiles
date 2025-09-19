return {
  'yetone/avante.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  event = 'VeryLazy',
  version = false,
  opts = {
    provider = 'bedrock',
    providers = {
      bedrock = {
        model = 'us.anthropic.claude-sonnet-4-20250514-v1:0',
        aws_profile = 'bedrock',
        aws_region = 'us-east-1',
      },
    },
  },
}
