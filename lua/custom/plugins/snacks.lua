-- snacks.nvim by folke — only enabling lightweight modules to avoid stepping
-- on plugins we already use (telescope, bufferline, noice).
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },     -- disable expensive features for huge files
    quickfile = { enabled = true },   -- render the file before plugins load
    dashboard = {
      preset = {
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File',     action = ':Telescope find_files' },
          { icon = ' ', key = 'o', desc = 'Open Folder',   action = function()
              local path = vim.fn.input({ prompt = 'Open folder: ', default = vim.fn.getcwd() .. '/', completion = 'dir' })
              if path == nil or path == '' then return end
              path = vim.fn.fnamemodify(path, ':p')
              if vim.fn.isdirectory(path) ~= 1 then
                vim.notify('Not a directory: ' .. path, vim.log.levels.WARN)
                return
              end
              vim.cmd('cd ' .. vim.fn.fnameescape(path))
              vim.cmd('Neotree show dir=' .. vim.fn.fnameescape(path))
            end },
          { icon = ' ', key = 'r', desc = 'Recent Files',  action = ':Telescope oldfiles' },
          { icon = ' ', key = 'g', desc = 'Find Text',     action = ':Telescope live_grep' },
          { icon = ' ', key = 'c', desc = 'Config',        action = ":lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })" },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy',         action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit',          action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
    -- Modules deliberately disabled to avoid conflicts with current plugins:
    --   notifier (have noice + nvim-notify)
    --   picker   (have telescope)
    --   indent   (have indent-blankline)
    --   statuscolumn / scroll / scope: skip for now, can opt in later
  },
}
