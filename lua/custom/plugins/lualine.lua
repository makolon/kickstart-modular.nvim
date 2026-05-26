return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'catppuccin',
      icons_enabled = vim.g.have_nerd_font,
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'oil', 'alpha', 'TelescopePrompt' },
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } } },
      lualine_c = {
        {
          'diagnostics',
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        },
        { 'filename', path = 1, symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' } },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if #clients == 0 then return '' end
            local names = {}
            for _, c in ipairs(clients) do table.insert(names, c.name) end
            return ' ' .. table.concat(names, ',')
          end,
        },
        'encoding',
        { 'fileformat', symbols = { unix = '', dos = '', mac = '' } },
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    extensions = { 'lazy', 'mason', 'oil', 'quickfix', 'toggleterm', 'trouble' },
  },
}
