-- Colorscheme: Catppuccin (Mocha)
-- See `:Telescope colorscheme` to preview installed themes.
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    opts = {
      flavour = 'mocha', -- latte | frappe | macchiato | mocha
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { 'italic' },
        keywords = { 'italic' },
        functions = { 'bold' },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
        mason = true,
        noice = true,
        notify = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        indent_blankline = { enabled = true },
        bufferline = true,
        diffview = true,
        flash = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
