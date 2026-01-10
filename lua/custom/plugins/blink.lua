return {
  {
    'saghen/blink.cmp',
    version = '*',
    event = 'InsertEnter',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    },
    opts = {
      keymap = {
        preset = 'default',
      },
      sources = {
        default = { 'lsp', 'path', 'buffer', 'snippets' },
      },
      snippets = {
        preset = 'luasnip',
      },
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
  },
}
