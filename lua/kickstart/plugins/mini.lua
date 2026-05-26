return {
  { -- Collection of small, focused mini.nvim modules.
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --   va) [V]isually select [A]round [)]paren
      --   yinq [Y]ank [I]nside [N]ext [Q]uote
      --   ci'  [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings
      --   saiw) [S]urround [A]dd [I]nner [W]ord [)]Paren
      --   sd'   [S]urround [D]elete [']quotes
      --   sr)'  [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Treesitter-aware comment toggling via gc / gcc (line) / gc<motion>.
      require('mini.comment').setup()

      -- Note: statusline is provided by lualine.nvim (see custom/plugins/lualine.lua).
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
