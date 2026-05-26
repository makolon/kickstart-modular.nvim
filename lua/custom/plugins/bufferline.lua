return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      mode = 'buffers',
      themable = true,
      numbers = 'none',
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = ' ', warning = ' ', info = ' ' }
        local ret = (diag.error and icons.error .. diag.error .. ' ' or '')
          .. (diag.warning and icons.warning .. diag.warning or '')
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = 'oil',
          text = 'Files',
          highlight = 'Directory',
          text_align = 'left',
          separator = true,
        },
      },
      show_buffer_close_icons = true,
      show_close_icon = false,
      separator_style = 'thin',
      always_show_bufferline = true,
      show_tab_indicators = true,
      enforce_regular_tabs = false,
      color_icons = true,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
    },
  },
  config = function(_, opts)
    require('bufferline').setup(opts)
  end,
}
