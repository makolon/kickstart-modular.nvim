-- ~/.config/nvim/lua/custom/plugins/sidekick.lua
return {
  {
    'folke/sidekick.nvim',
    lazy = false,

    -- NOTE:
    -- sidekick.nvim requires Neovim >= 0.11.2.
    -- This config focuses on the CLI workflow (Codex/Claude/etc.) and disables Copilot NES.

    opts = function(_, opts)
      opts = opts or {}

      -- ROOT FIX for "which Claude to select" flicker + E21 over SSH:
      --
      -- We run every CLI in Neovim's own terminal (`mux.enabled = false` below),
      -- so each nvim owns its Claude as an in-process job. BUT sidekick's session
      -- discovery still registers the tmux/zellij backends whenever those binaries
      -- exist, and `Session.sessions()` then walks the process tree of EVERY
      -- multiplexer pane looking for CLI tools. Inside tmux over SSH a *second*
      -- nvim therefore discovers the *first* nvim's Claude as an "external"
      -- session, so `cli.show{name='claude'}` sees 2 candidates, skips the
      -- single-match auto-launch, and pops the "Select CLI tool" picker instead
      -- (the flickering tab) — and the layout's retry loop re-pops it every 500ms.
      --
      -- Drop those discovery backends so each nvim only ever sees and launches its
      -- OWN Claude. Idempotent and applied before sidekick.setup() runs.
      local Session = require 'sidekick.cli.session'
      if not Session._no_mux_discovery then
        Session._no_mux_discovery = true
        local orig_setup = Session.setup
        Session.setup = function()
          orig_setup()
          Session.backends.tmux = nil
          Session.backends.zellij = nil
        end
      end

      -- Disable Copilot NES (we only use the CLI features here).
      opts.nes = opts.nes or {}
      opts.nes.enabled = false

      -- Use Neovim's built-in terminal on the right side (VSCode-like layout).
      opts.cli = opts.cli or {}
      opts.cli.win = vim.tbl_deep_extend('force', opts.cli.win or {}, {
        layout = 'right',
        split = { width = 40 },
      })
      opts.cli.mux = vim.tbl_deep_extend('force', opts.cli.mux or {}, {
        enabled = false,
      })

      -- Add a couple of practical prompts.
      -- {quickfix} expands the current quickfix list.
      -- {selection} expands the current visual selection.
      opts.cli.prompts = vim.tbl_deep_extend('force', opts.cli.prompts or {}, {
        fix_quickfix = table.concat({
          'I ran tests/commands and got errors.',
          'Please fix the root cause in this repo, then rerun the relevant command to confirm.',
          '',
          '{quickfix}',
        }, '\n'),
        fix_selection = table.concat({
          'Please fix the issue described below. If code changes are needed, apply the minimal diff.',
          '',
          '{selection}',
        }, '\n'),
      })

      return opts
    end,

    keys = {
      -- Toggle the Sidekick CLI panel.
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle { focus = true }
        end,
        desc = 'Sidekick: Toggle CLI',
        mode = { 'n', 't', 'i', 'x' },
      },

      -- Select an installed CLI tool (Codex/Claude/etc.).
      {
        '<leader>as',
        function()
          require('sidekick.cli').select { filter = { installed = true }, focus = true }
        end,
        desc = 'Sidekick: Select CLI Tool',
        mode = { 'n' },
      },

      -- Open prompt selector UI.
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt { focus = true }
        end,
        desc = 'Sidekick: Select Prompt',
        mode = { 'n', 'x' },
      },

      -- One-shot "fix" from quickfix (normal mode).
      -- Tip: populate quickfix via your test runner integration, then press F8.
      {
        '<F8>',
        function()
          local cli = require 'sidekick.cli'
          cli.toggle { focus = true }
          -- Send the prompt by name; Sidekick resolves it from opts.cli.prompts.
          cli.send { msg = 'fix_quickfix' }
        end,
        desc = 'Sidekick: Fix from quickfix',
        mode = { 'n' },
      },

      -- One-shot "fix" from selection (visual mode).
      -- Tip: visually select the traceback/log snippet, then press F8.
      {
        '<F8>',
        function()
          local cli = require 'sidekick.cli'
          cli.toggle { focus = true }
          cli.send { msg = 'fix_selection' }
        end,
        desc = 'Sidekick: Fix from selection',
        mode = { 'x' },
      },
    },
  },
}
