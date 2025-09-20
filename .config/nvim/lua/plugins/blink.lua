return {
  'saghen/blink.cmp',
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = { auto_show = false },
      ghost_text = {
        enabled = true,
      },
      menu = {
        border = 'rounded',
        scrollbar = false,
        -- Disable normal background
        winhighlight = 'Normal:None,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
      },
    },
    sources = {
      default = { 'lsp', 'path', 'buffer' },
    },
    fuzzy = {
      implementation = 'lua',
      sorts = {
        'score',
        'sort_text',
        'label',
        -- 'exact',
        -- 'kind',
      },
    },
  },
  opts_extend = { 'sources.default' },
}
