-- High-value editing plugins (2026 stack).
return {
  -- Project-wide find/replace with live preview (replaces spectre).
  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
      { '<leader>sr', function() require('grug-far').open() end,                   desc = 'Search & Replace (project)' },
      { '<leader>sw', function() require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } }) end, desc = 'Replace word under cursor' },
      { '<leader>sR', function() require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } }) end,        desc = 'Replace in current file' },
    },
    opts = { headerMaxWidth = 80 },
  },

  -- In-buffer markdown rendering (essential for AI chat windows).
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown', 'codecompanion', 'Avante' },
    opts = {
      file_types = { 'markdown', 'codecompanion' },
      code = { sign = false, width = 'block', right_pad = 1 },
      heading = { sign = false, icons = {} },
    },
  },

  -- Sticky function/class header at the top of the window.
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPost',
    opts = { max_lines = 3, multiline_threshold = 1, mode = 'cursor' },
    keys = {
      { '[c', function() require('treesitter-context').go_to_context(vim.v.count1) end, desc = 'Jump to context' },
    },
  },

  -- Multiple cursors (2026 winner over vim-visual-multi).
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    keys = {
      { '<C-n>',     function() require('multicursor-nvim').matchAddCursor(1) end, mode = { 'n', 'v' }, desc = 'Add cursor: next match' },
      { '<C-p>',     function() require('multicursor-nvim').matchSkipCursor(1) end, mode = { 'n', 'v' }, desc = 'Skip: next match' },
      { '<leader>A', function() require('multicursor-nvim').matchAllAddCursors() end, desc = 'Multicursor: all matches' },
      { '<Esc>',     function()
          local mc = require('multicursor-nvim')
          if mc.hasCursors() then mc.clearCursors() else vim.cmd('nohlsearch') end
        end },
    },
    config = function() require('multicursor-nvim').setup() end,
  },

  -- Yank ring + put-and-cycle.
  {
    'gbprod/yanky.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    keys = {
      { 'y',  '<Plug>(YankyYank)',           mode = { 'n', 'x' } },
      { 'p',  '<Plug>(YankyPutAfter)',       mode = { 'n', 'x' } },
      { 'P',  '<Plug>(YankyPutBefore)',      mode = { 'n', 'x' } },
      { '<C-n>', '<Plug>(YankyCycleForward)' },
      { '<C-p>', '<Plug>(YankyCycleBackward)' },
      { '<leader>p', function() require('telescope').extensions.yank_history.yank_history() end, desc = 'Yank history' },
    },
    opts = { ring = { storage = 'shada' } },
  },

  -- 30+ extra text objects (subword, argument, indent, etc.).
  {
    'chrisgrieser/nvim-various-textobjs',
    event = 'VeryLazy',
    opts = { keymaps = { useDefaults = true } },
  },

  -- Undo history visualizer.
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = { { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Undotree' } },
  },

  -- Distraction-free writing.
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen mode' } },
    opts = { window = { width = 100 } },
  },

  -- Composable status column (signs + number + fold).
  {
    'luukvbaal/statuscol.nvim',
    event = 'BufReadPost',
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup({
        relculright = true,
        segments = {
          { text = { builtin.foldfunc },      click = 'v:lua.ScFa' },
          { text = { '%s' },                  click = 'v:lua.ScSa' },
          { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
        },
      })
    end,
  },
}
