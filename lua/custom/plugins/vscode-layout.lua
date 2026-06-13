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
          -- True if `win` holds a normal, modifiable editor buffer.
          local function is_editor_win(win)
            if vim.api.nvim_win_get_config(win).relative ~= '' then
              return false -- floating window
            end
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            local bt = vim.bo[buf].buftype
            return ft ~= 'neo-tree'
              and ft ~= 'toggleterm'
              and ft ~= 'sidekick'
              and ft ~= 'sidekick_terminal'
              and ft ~= 'edgy'
              and bt ~= 'terminal'
              and vim.bo[buf].modifiable
          end

          -- Focus a real, modifiable editor window. If none exists (e.g. nvim
          -- opened straight onto a directory), create a scratch one so that
          -- sidekick's `jobstart(term=true)` is NEVER issued while the current
          -- window holds a non-modifiable buffer (the direct cause of E21).
          -- Returns the focused window, or nil if it could not be guaranteed.
          local function ensure_editor()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if is_editor_win(win) then
                vim.api.nvim_set_current_win(win)
                pcall(vim.cmd, 'stopinsert')
                return win
              end
            end
            -- No editor window exists: create one without clobbering a sidebar.
            -- If the current window is a managed/special panel, split off a new
            -- scratch window; otherwise just swap in a scratch buffer here.
            local cur = vim.api.nvim_get_current_win()
            local curft = vim.bo[vim.api.nvim_win_get_buf(cur)].filetype
            local sidebar = curft == 'neo-tree'
              or curft == 'toggleterm'
              or curft == 'sidekick'
              or curft == 'sidekick_terminal'
              or curft == 'edgy'
            local ok = pcall(vim.cmd, sidebar and 'botright vsplit | enew' or 'enew')
            if ok and is_editor_win(vim.api.nvim_get_current_win()) then
              pcall(vim.cmd, 'stopinsert')
              return vim.api.nvim_get_current_win()
            end
            return nil
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

          -- Start Claude on the right. Two preconditions must hold to avoid the
          -- E21 race (especially over SSH, where a *second* nvim's startup is
          -- slowed by the first nvim's running Claude and overruns fixed delays):
          --   1) focus is on a real modifiable editor window, and
          --   2) edgy's relayout has gone idle (no pending UI churn).
          -- We poll for these instead of trusting fixed timers, and re-check
          -- after launching, retrying only if Claude did not actually come up.
          local function show_claude(attempts)
            attempts = attempts or 1

            -- Bail out cleanly if Claude is already up (avoids stacking shows).
            if claude_running() then
              ensure_editor()
              vim.g._layout_loading = false
              return
            end

            local editor = ensure_editor()
            if not editor and attempts < 12 then
              -- Layout not settled enough to find/make an editor window yet.
              vim.defer_fn(function()
                show_claude(attempts + 1)
              end, 300)
              return
            end

            local ok, cli = pcall(require, 'sidekick.cli')
            if ok and is_editor_win(vim.api.nvim_get_current_win()) then
              pcall(cli.show, { name = 'claude', focus = false })
            end

            vim.defer_fn(function()
              if not claude_running() and attempts < 12 then
                show_claude(attempts + 1)
              else
                ensure_editor()
                vim.g._layout_loading = false
              end
            end, 500)
          end

          -- Wait until the bottom terminal has actually opened (or a budget
          -- elapses) before launching Claude, rather than guessing with a
          -- fixed delay that a loaded SSH host can blow past.
          local function wait_then_claude(attempts)
            attempts = attempts or 1
            local term_open = false
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == 'toggleterm' or vim.bo[buf].buftype == 'terminal' then
                term_open = true
                break
              end
            end
            if term_open or attempts >= 10 then
              show_claude()
            else
              vim.defer_fn(function()
                wait_then_claude(attempts + 1)
              end, 200)
            end
          end

          local function setup_layout()
            vim.g._layout_loading = true

            vim.cmd 'Neotree show'

            -- Bottom terminal first, then Claude LAST (after it is confirmed
            -- open and an editor window is focused).
            vim.defer_fn(function()
              pcall(vim.cmd, 'ToggleTerm direction=horizontal')
              wait_then_claude()
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
