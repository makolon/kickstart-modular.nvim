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

          -- Start/landing screens (snacks dashboard, alpha, mini.starter…)
          -- sit in the center on a NON-modifiable buffer. We KEEP them as the
          -- center content, so they count as a valid "editor area" to focus —
          -- we just must not run sidekick's jobstart while one is the current
          -- window without first making it modifiable (see show_claude).
          local PLACEHOLDER_FT = {
            snacks_dashboard = true,
            dashboard = true,
            alpha = true,
            starter = true,
            ministarter = true,
          }

          -- True if `win` is a non-floating window holding a start/landing
          -- screen (the dashboard).
          local function is_placeholder_win(win)
            if vim.api.nvim_win_get_config(win).relative ~= '' then
              return false
            end
            return PLACEHOLDER_FT[vim.bo[vim.api.nvim_win_get_buf(win)].filetype] == true
          end

          -- Turn the current window into a throwaway scratch editor. Kept out
          -- of the bufferline (no stray `[No Name]` tab) and wiped once a real
          -- file replaces it.
          local function make_scratch()
            local scratch = vim.api.nvim_get_current_buf()
            vim.bo[scratch].buflisted = false
            vim.bo[scratch].bufhidden = 'wipe'
            pcall(vim.cmd, 'stopinsert')
            return vim.api.nvim_get_current_win()
          end

          -- Focus the center editor area. Preference order:
          --   1) a real, modifiable editor window;
          --   2) the dashboard/start screen (kept as-is — NOT replaced, so the
          --      Find File / Open Folder / Recent Files menu survives);
          --   3) otherwise (e.g. nvim opened straight onto a directory) create
          --      a scratch window so we never leave focus on a sidebar.
          -- Returns the focused window, or nil if none could be guaranteed.
          local function ensure_editor()
            -- 1) A real editor window already exists: just focus it.
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if is_editor_win(win) then
                vim.api.nvim_set_current_win(win)
                pcall(vim.cmd, 'stopinsert')
                return win
              end
            end

            -- 2) Keep the dashboard in the center; just focus its window. The
            -- E21 guard around jobstart is handled by show_claude, so we do not
            -- need to manufacture a scratch pane next to it.
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if is_placeholder_win(win) then
                vim.api.nvim_set_current_win(win)
                pcall(vim.cmd, 'stopinsert')
                return win
              end
            end

            -- 3) No editor or dashboard window: create one without clobbering a sidebar.
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
              return make_scratch()
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

            -- Launch Claude. sidekick's `jobstart(term=true)` must not fire
            -- while the current window holds a non-modifiable buffer (E21).
            -- The current window is now either a real editor or the dashboard;
            -- for the dashboard (non-modifiable) we flip 'modifiable' on just
            -- for the call and restore it, so the menu stays read-only and no
            -- extra pane is created (which would itself race edgy's relayout).
            local ok, cli = pcall(require, 'sidekick.cli')
            local cur = vim.api.nvim_get_current_win()
            if ok and (is_editor_win(cur) or is_placeholder_win(cur)) then
              local buf = vim.api.nvim_win_get_buf(cur)
              local was_modifiable = vim.bo[buf].modifiable
              if not was_modifiable then
                vim.bo[buf].modifiable = true
              end
              pcall(cli.show, { name = 'claude', focus = false })
              if not was_modifiable and vim.api.nvim_buf_is_valid(buf) then
                vim.bo[buf].modifiable = false
              end
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
