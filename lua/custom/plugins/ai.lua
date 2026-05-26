-- AI layer — complements sidekick.nvim (which handles inline NES).
-- CodeCompanion provides Zed-style buffer-integrated chat + actions.
-- mcphub manages MCP servers used by CodeCompanion (and avante, if you add it).
return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
    keys = {
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>',     mode = { 'n', 'v' }, desc = 'AI: actions' },
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'AI: chat toggle' },
      { '<leader>ai', '<cmd>CodeCompanion<cr>',            mode = { 'n', 'v' }, desc = 'AI: inline' },
      { '<leader>ap', '<cmd>CodeCompanionChat Add<cr>',    mode = 'v',          desc = 'AI: add selection to chat' },
    },
    opts = {
      strategies = {
        chat   = { adapter = 'anthropic' },
        inline = { adapter = 'anthropic' },
      },
      display = {
        chat = { window = { layout = 'vertical', width = 0.4 } },
      },
    },
  },

  {
    'ravitemer/mcphub.nvim',
    cmd = { 'MCPHub', 'MCPHubToggle' },
    build = 'npm install -g mcp-hub@latest',
    opts = {},
  },
}
