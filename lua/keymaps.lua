-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics: open [L]ocation list' })

-- --------------------------------------------------------------------
-- Explorer / Finder (Oil + Telescope)
-- --------------------------------------------------------------------

-- Find files with Telescope (simple, no Neo-tree reveal)
map('n', '<leader>ef', function()
  require('telescope.builtin').find_files()
end, { desc = 'Find file (Telescope)' })

-- Open Oil in the current file's directory (fallback to cwd if no file)
map('n', '<leader>ed', function()
  local ok, oil = pcall(require, 'oil')
  if not ok then
    vim.notify('oil.nvim is not available', vim.log.levels.WARN)
    return
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  local dir
  if bufname == '' then
    dir = vim.fn.getcwd()
  else
    dir = vim.fn.fnamemodify(bufname, ':p:h')
  end

  oil.open(dir)
end, { desc = 'Open directory (Oil)' })

-- (Optional) If you want a dedicated key for opening Oil at cwd:
-- map('n', '<leader>eD', function()
--   local ok, oil = pcall(require, 'oil')
--   if ok then oil.open(vim.fn.getcwd()) end
-- end, { desc = 'Open cwd (Oil)' })

-- --------------------------------------------------------------------
-- Buffers
-- --------------------------------------------------------------------

map('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<leader>bd', ':bdelete<CR>', { desc = 'Close current buffer' })

-- Exit terminal mode in the builtin terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- --------------------------------------------------------------------
-- Window navigation
-- --------------------------------------------------------------------

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- --------------------------------------------------------------------
-- [[ Basic Autocommands ]]
-- --------------------------------------------------------------------

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- --------------------------------------------------------------------
-- Bufferline keymaps (keep if you use bufferline)
-- --------------------------------------------------------------------

map('n', '<leader>wl', '<CMD>BufferLineCloseRight<CR>', { desc = 'BufferLine: close to the right' })
map('n', '<leader>wh', '<CMD>BufferLineCloseLeft<CR>', { desc = 'BufferLine: close to the left' })
map('n', '<leader>wall', '<CMD>BufferLineCloseOthers<CR>', { desc = 'BufferLine: close others' })
map('n', '<leader>we', '<CMD>BufferLinePickClose<CR>', { desc = 'BufferLine: pick close' })
