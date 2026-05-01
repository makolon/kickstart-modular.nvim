return {
  {
    'mrjones2014/smart-splits.nvim',
    version = '>=1.0.0', -- Specify the version if needed
    config = function()
      require('smart-splits').setup {
        -- Customize settings as needed
        default_amount = 5, -- Default resize amount
        multiplexer_integration = 'kitty', -- Declear the used multiplexer
        at_edge = 'stop', -- Behavior at window edges
      }

      -- Set key mappings (examples)
      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
    end,
  },
}
