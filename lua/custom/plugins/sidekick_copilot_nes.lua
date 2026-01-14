-- Copilot NES: ensure Sidekick is initialized BEFORE enabling Copilot LSP.
-- This avoids "Sidekick is not handling Copilot LSP status notifications".

return {
  {
    'folke/sidekick.nvim',
    lazy = false, -- load on startup so it can register Copilot status handlers early

    opts = function(_, opts)
      opts = opts or {}
      opts.nes = opts.nes or {}
      opts.nes.enabled = true
      return opts
    end,

    config = function(_, opts)
      require('sidekick').setup(opts)

      -- Sidekick requires Copilot LSP enabled via vim.lsp.enable(...)
      -- Do this AFTER sidekick.setup so status notifications are handled.
      vim.lsp.enable 'copilot'
    end,
  },

  -- Install copilot-language-server via Mason (optional but recommended)
  {
    'williamboman/mason-lspconfig.nvim',
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, 'copilot') then
        table.insert(opts.ensure_installed, 'copilot')
      end
      return opts
    end,
  },
}
