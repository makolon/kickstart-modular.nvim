return {
  'akinsho/toggleterm.nvim',
  version = '*',
  lazy = false,
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm<cr>',                   desc = 'Terminal: toggle (horizontal)' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>',   desc = 'Terminal: float' },
    { '<leader>th', '<cmd>ToggleTerm direction=horizontal size=15<cr>', desc = 'Terminal: horizontal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<cr>',   desc = 'Terminal: vertical' },
    { '<leader>gg', function() _lazygit_toggle() end,        desc = 'Git: lazygit (float)' },
    { '<leader>lg', function() _lazygit_toggle() end,        desc = 'Git: lazygit (alias)' },
  },
  config = function()
    require('toggleterm').setup {
      size = 15,
      open_mapping = [[<leader>tt]],
      hide_numbers = true,
      shade_filetypes = {},
      autochdir = false,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = false,
      direction = 'horizontal',
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

    vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'TermOpen' }, {
      pattern = 'term://*',
      callback = function()
        if vim.g._layout_loading then return end
        if vim.bo.buftype == 'terminal' then
          vim.schedule(function()
            vim.cmd 'startinsert'
          end)
        end
      end,
    })

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
