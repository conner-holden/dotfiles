return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'mikavilpas/blink-ripgrep.nvim',
  },
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = { auto_show = false },
    },
    sources = {
      default = { 'lsp', 'path', 'buffer', 'ripgrep', 'snippets' },
      providers = {
        ripgrep = {
          module = 'blink-ripgrep',
          name = 'Ripgrep',
          opts = {
            prefix_min_len = 3,
            project_root_marker = '.git',
            fallback_to_regex_highlighting = true,
            toggles = {
              on_off = nil,
              debug = nil,
            },
            backend = {
              use = 'ripgrep',
              customize_icon_highlight = true,
              ripgrep = {
                context_size = 5,
                max_filesize = '1M',
                project_root_fallback = true,
                search_casing = '--ignore-case',
                additional_rg_options = {},
                ignore_paths = {},
                additional_paths = {},
              },
            },
            debug = false,
          },
        },
      },
    },
    fuzzy = {
      implementation = 'lua',
      sorts = {
        'kind',
        'score',
        'sort_text',
        'label',
      },
    },
  },
  opts_extend = { 'sources.default' },
}
