-- VSCode-like startup layout (managed by edgy.nvim):
-- Left: Neo-tree (full height) | Center-top: Editor | Center-bottom: Terminal | Right: Claude
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        group = vim.api.nvim_create_augroup('vscode_layout', { clear = true }),
        callback = function()
          -- Move focus to a real editor window (normal, modifiable buffer).
          -- Returns true if such a window was found and focused.
          local function focus_editor()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_config(win).relative == '' then
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype
                local bt = vim.bo[buf].buftype
                if ft ~= 'neo-tree' and ft ~= 'toggleterm' and ft ~= 'sidekick' and ft ~= 'edgy' and bt ~= 'terminal' then
                  vim.api.nvim_set_current_win(win)
                  pcall(vim.cmd, 'stopinsert')
                  return true
                end
              end
            end
            return false
          end

          -- Whether a sidekick (Claude) terminal is actually running.
          local function claude_running()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == 'terminal' and (vim.b[buf].sidekick_cli ~= nil or vim.bo[buf].filetype == 'sidekick') then
                return true
              end
            end
            return false
          end

          -- Start Claude on the right. Crucially, focus a normal editor window
          -- FIRST so sidekick's `jobstart(term=true)` never runs while the current
          -- window holds a non-modifiable buffer (which triggers E21 over SSH,
          -- where the slower startup lets edgy's relayout race the terminal setup).
          -- Retries a few times to absorb SSH/remote timing jitter.
          local function show_claude(attempts)
            attempts = attempts or 1
            focus_editor()
            local ok, cli = pcall(require, 'sidekick.cli')
            if ok then
              pcall(cli.show, { name = 'claude', focus = false })
            end
            vim.defer_fn(function()
              if not claude_running() and attempts < 5 then
                show_claude(attempts + 1)
              else
                focus_editor()
                vim.g._layout_loading = false
              end
            end, 500)
          end

          local function setup_layout()
            vim.g._layout_loading = true

            vim.cmd 'Neotree show'

            -- Bottom terminal first, then Claude LAST (after focusing the editor).
            vim.defer_fn(function()
              pcall(vim.cmd, 'ToggleTerm direction=horizontal')

              vim.defer_fn(function()
                show_claude()
              end, 400)
            end, 400)
          end

          -- If Lazy's window is open, wait for it to close
          local lazy_win_open = false
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'lazy' then
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
                  return true
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
