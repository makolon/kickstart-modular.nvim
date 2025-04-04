return {
  {
    'mrjones2014/legendary.nvim',
    version = '>=2.10.0',
    dependencies = { 'mrjones2014/smart-splits.nvim' }, -- Specify dependency on smart-splits.nvim
    config = function()
      require('legendary').setup {
        -- Enable smart-splits extension
        extensions = {
          smart_splits = {
            directions = { 'h', 'j', 'k', 'l' },
            mods = {
              move = '<C>', -- Modifier for moving between windows
              resize = '<M>', -- Modifier for resizing windows
              swap = false, -- Disable keybindings for swapping buffers
            },
          },
        },
      }
    end,
  },
}
