return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec' },
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm<cr>',                   desc = 'Terminal: toggle (float)' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>',   desc = 'Terminal: float' },
    { '<leader>th', '<cmd>ToggleTerm direction=horizontal size=15<cr>', desc = 'Terminal: horizontal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<cr>',   desc = 'Terminal: vertical' },
    { '<leader>gg', function() _lazygit_toggle() end,        desc = 'Git: lazygit (float)' },
    { '<leader>lg', function() _lazygit_toggle() end,        desc = 'Git: lazygit (alias)' },
  },
  config = function()
    require('toggleterm').setup {
      size = 20,
      open_mapping = [[<leader>tt]],
      hide_numbers = true,
      shade_filetypes = {},
      autochdir = false,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = 'float',
      close_on_exit = true,
      clear_env = false,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = 'curved',
        winblend = 3,
        title_pos = 'center',
      },
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end,
      },
    }

    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      hidden = true,
      direction = 'float',
      float_opts = { border = 'curved' },
    }

    function _G._lazygit_toggle()
      lazygit:toggle()
    end
  end,
}
