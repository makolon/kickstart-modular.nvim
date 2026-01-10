-- diffview.nvim (Git diff UI)
return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git: Diffview open' },
    { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = 'Git: Diffview close' },
    { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = 'Git: File history (repo)' },
    { '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git: File history (current file)' },
  },
  config = function()
    local actions = require 'diffview.actions'

    require('diffview').setup {
      enhanced_diff_hl = true, -- nicer diff highlights (works best with treesitter)
      view = {
        merge_tool = {
          layout = 'diff3_mixed',
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = 'tree', -- "list" | "tree"
        win_config = { position = 'left', width = 35 },
      },
      keymaps = {
        -- Disable default mappings if you want full control:
        -- disable_defaults = true,

        view = {
          -- Close Diffview with q (handy)
          { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },

          -- Navigate hunks (like gitsigns)
          { 'n', ']c', actions.next_conflict, { desc = 'Next conflict' } },
          { 'n', '[c', actions.prev_conflict, { desc = 'Prev conflict' } },
        },
        file_panel = {
          { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
          { 'n', '<cr>', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', 'o', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', 's', actions.toggle_stage_entry, { desc = 'Stage/unstage the selected entry' } },
          { 'n', 'S', actions.stage_all, { desc = 'Stage all' } },
          { 'n', 'U', actions.unstage_all, { desc = 'Unstage all' } },
          { 'n', 'R', actions.refresh_files, { desc = 'Refresh' } },
          { 'n', 'L', actions.open_commit_log, { desc = 'Open commit log' } },
          { 'n', 'tf', actions.toggle_files, { desc = 'Toggle file panel' } },
        },
        file_history_panel = {
          { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
          { 'n', '<cr>', actions.select_entry, { desc = 'Open diff for entry' } },
          { 'n', 'y', actions.copy_hash, { desc = 'Copy commit hash' } },
          { 'n', 'L', actions.open_commit_log, { desc = 'Open commit log' } },
          { 'n', 'R', actions.refresh_files, { desc = 'Refresh' } },
        },
      },
    }
  end,
}
