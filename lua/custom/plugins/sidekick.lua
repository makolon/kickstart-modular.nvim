-- ~/.config/nvim/lua/custom/plugins/sidekick.lua
return {
  {
    'folke/sidekick.nvim',
    event = 'VeryLazy',

    -- NOTE:
    -- sidekick.nvim requires Neovim >= 0.11.2.
    -- This config focuses on the CLI workflow (Codex/Claude/etc.) and disables Copilot NES.

    opts = function(_, opts)
      opts = opts or {}

      -- Disable Copilot NES (we only use the CLI features here).
      opts.nes = opts.nes or {}
      opts.nes.enabled = false

      -- Persist CLI sessions via tmux (works nicely with your tmux workflow).
      -- "create" can be "split" or "window" depending on preference.
      opts.cli = opts.cli or {}
      opts.cli.mux = vim.tbl_deep_extend('force', opts.cli.mux or {}, {
        enabled = true,
        backend = 'tmux',
        create = 'split',
        split = { size = 0.33 },
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
