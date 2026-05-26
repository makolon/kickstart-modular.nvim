return {
  'akinsho/toggleterm.nvim',
  version = '*',
  lazy = false,
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = 'Terminal: toggle (horizontal)' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Terminal: float' },
    { '<leader>th', '<cmd>ToggleTerm direction=horizontal size=15<cr>', desc = 'Terminal: horizontal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=80<cr>', desc = 'Terminal: vertical' },
    {
      '<leader>gg',
      function()
        _lazygit_toggle()
      end,
      desc = 'Git: lazygit (float)',
    },
    {
      '<leader>lg',
      function()
        _lazygit_toggle()
      end,
      desc = 'Git: lazygit (alias)',
    },
    {
      '<C-`>',
      function()
        _term_new()
      end,
      mode = { 'n', 't' },
      desc = 'Terminal: new tab',
    },
    {
      '<C-A-]>',
      function()
        _term_cycle(1)
      end,
      mode = { 'n', 't' },
      desc = 'Terminal: next tab',
    },
    {
      '<C-A-[>',
      function()
        _term_cycle(-1)
      end,
      mode = { 'n', 't' },
      desc = 'Terminal: prev tab',
    },
    {
      '<leader>tx',
      function()
        _term_close_current()
      end,
      desc = 'Terminal: close current tab',
    },
    {
      '<leader>t1',
      function()
        _term_focus(1)
      end,
      desc = 'Terminal: go to #1',
    },
    {
      '<leader>t2',
      function()
        _term_focus(2)
      end,
      desc = 'Terminal: go to #2',
    },
    {
      '<leader>t3',
      function()
        _term_focus(3)
      end,
      desc = 'Terminal: go to #3',
    },
    {
      '<leader>t4',
      function()
        _term_focus(4)
      end,
      desc = 'Terminal: go to #4',
    },
    {
      '<leader>t5',
      function()
        _term_focus(5)
      end,
      desc = 'Terminal: go to #5',
    },
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
        enabled = true,
        name_formatter = function(term)
          return 'Term #' .. term.id
        end,
      },
    }
    vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'TermOpen' }, {
      pattern = 'term://*',
      callback = function()
        if vim.g._layout_loading then
          return
        end
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
    local terms_mod = require 'toggleterm.terminal'
    local function get_visible_terms()
      local visible = {}
      for _, t in pairs(terms_mod.get_all()) do
        if t:is_open() and t.direction ~= 'float' then
          table.insert(visible, t)
        end
      end
      return visible
    end
    function _G._term_focus(id)
      for _, t in ipairs(get_visible_terms()) do
        if t.id ~= id then
          t:close()
        end
      end
      vim.cmd(id .. 'ToggleTerm direction=horizontal')
    end
    function _G._term_new()
      local max_id = 0
      for _, t in pairs(terms_mod.get_all()) do
        if t.id and t.id > max_id and t.direction ~= 'float' then
          max_id = t.id
        end
      end
      _G._term_focus(max_id + 1)
    end
    function _G._term_cycle(dir)
      local all = {}
      for _, t in pairs(terms_mod.get_all()) do
        if t.direction ~= 'float' then
          table.insert(all, t)
        end
      end
      if #all == 0 then
        return
      end
      table.sort(all, function(a, b)
        return a.id < b.id
      end)
      local current_id = nil
      for _, t in ipairs(get_visible_terms()) do
        current_id = t.id
        break
      end
      local idx = 1
      if current_id then
        for i, t in ipairs(all) do
          if t.id == current_id then
            idx = i
            break
          end
        end
      end
      local next_idx = ((idx - 1 + dir) % #all) + 1
      _G._term_focus(all[next_idx].id)
    end
    function _G._term_close_current()
      local current = get_visible_terms()[1]
      if not current then
        return
      end
      current:shutdown()
    end
  end,
}
