-- VSCode-like startup layout (managed by edgy.nvim):
-- Left: Neo-tree (full height) | Center-top: Editor | Center-bottom: Terminal | Right: Claude
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('vscode_layout', { clear = true }),
        callback = function()
          local function setup_layout()
            vim.g._layout_loading = true

            pcall(vim.cmd, 'Neotree show')

            vim.defer_fn(function()
              pcall(vim.cmd, 'ToggleTerm direction=horizontal')
            end, 300)

            vim.defer_fn(function()
              local ok, cli = pcall(require, 'sidekick.cli')
              if ok then
                pcall(cli.show, { name = 'claude', focus = false })
              end
            end, 600)

            vim.defer_fn(function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype
                local bt = vim.bo[buf].buftype
                if ft ~= 'neo-tree' and ft ~= 'toggleterm' and ft ~= 'sidekick' and bt ~= 'terminal' then
                  vim.api.nvim_set_current_win(win)
                  vim.cmd 'stopinsert'
                  break
                end
              end
              vim.g._layout_loading = false
            end, 900)
          end

          -- If Lazy's window is open, wait for it to close before setting up
          local lazy_win_open = false
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == 'lazy' then
              lazy_win_open = true
              break
            end
          end

          if lazy_win_open then
            vim.api.nvim_create_autocmd('WinClosed', {
              group = vim.api.nvim_create_augroup('vscode_layout_after_lazy', { clear = true }),
              callback = function()
                local still_open = false
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.bo[buf].filetype == 'lazy' then
                    still_open = true
                    break
                  end
                end
                if not still_open then
                  vim.defer_fn(setup_layout, 100)
                  return true -- delete this autocmd
                end
              end,
            })
          else
            setup_layout()
          end
        end,
      })
    end,
  },
}
