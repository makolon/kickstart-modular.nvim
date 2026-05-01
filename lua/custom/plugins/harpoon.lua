-- Harpoon v2: pin a few files per project, jump between them instantly.
--
-- Workflow:
--   <leader>ha   add current file to the harpoon list
--   <leader>hh   open the menu (edit/reorder/delete entries)
--   <leader>1..4 jump to the 1st..4th harpooned file
--   <C-S-P>/<C-S-N> previous / next harpoon item
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = function()
    local harpoon = require 'harpoon'
    local keys = {
      { '<leader>ha', function() harpoon:list():add() end,                                desc = 'Harpoon: add file' },
      { '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,        desc = 'Harpoon: toggle menu' },
      { '<C-S-P>',    function() harpoon:list():prev() end,                               desc = 'Harpoon: prev item' },
      { '<C-S-N>',    function() harpoon:list():next() end,                               desc = 'Harpoon: next item' },
    }
    for i = 1, 4 do
      table.insert(keys, {
        '<leader>' .. i,
        function() harpoon:list():select(i) end,
        desc = 'Harpoon: go to file ' .. i,
      })
    end
    return keys
  end,
  config = function()
    require('harpoon'):setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    }
  end,
}
