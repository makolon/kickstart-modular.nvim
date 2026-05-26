-- edgy.nvim — IDE-style window layout (VSCode-like).
-- Ensures Neo-tree spans full height and the terminal stays within the editor area.
return {
  'folke/edgy.nvim',
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd('TermOpen', {
      group = vim.api.nvim_create_augroup('edgy_tag_sidekick', { clear = true }),
      callback = function(ev)
        vim.defer_fn(function()
          if not vim.api.nvim_buf_is_valid(ev.buf) then return end
          if vim.bo[ev.buf].filetype == 'toggleterm' then return end
          local name = vim.api.nvim_buf_get_name(ev.buf)
          if name:match('claude') or name:match('codex') or name:match('sidekick') then
            vim.bo[ev.buf].filetype = 'sidekick'
          end
        end, 100)
      end,
    })
  end,
  config = function(_, opts)
    require('edgy').setup(opts)

    local sidebar_ft = { ['neo-tree'] = true, toggleterm = true, sidekick = true }
    vim.api.nvim_create_autocmd('QuitPre', {
      group = vim.api.nvim_create_augroup('edgy_auto_quit', { clear = true }),
      callback = function()
        local dominated = 0
        local real = 0
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(win).relative == '' then
            local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
            if sidebar_ft[ft] then
              dominated = dominated + 1
            else
              real = real + 1
            end
          end
        end
        if real <= 1 then
          vim.cmd 'qa'
        end
      end,
    })
  end,
  opts = {
    animate = { enabled = false },
    left = {
      {
        title = 'Explorer',
        ft = 'neo-tree',
        size = { width = 30 },
        pinned = true,
        open = 'Neotree show',
      },
    },
    bottom = {
      {
        ft = 'toggleterm',
        size = { height = 0.3 },
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ''
        end,
      },
    },
    right = {
      {
        title = 'Claude',
        ft = 'sidekick',
        size = { width = 40 },
      },
    },
  },
}
