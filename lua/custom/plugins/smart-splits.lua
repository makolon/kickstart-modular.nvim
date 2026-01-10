return {
  {
    'mrjones2014/smart-splits.nvim',
    version = '>=1.0.0', -- Specify the version if needed
    config = function()
      require('smart-splits').setup {
        -- Customize settings as needed
        default_amount = 5, -- Default resize amount
        at_edge = 'wrap', -- Behavior at window edges
      }

      -- Set key mappings (examples)
      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
    end,
  },
}
