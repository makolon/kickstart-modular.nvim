-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`
--
-- Leader prefix conventions (see which-key for the full menu):
--   <leader>f  Find/File   (telescope file pickers)
--   <leader>s  Search      (telescope grep / symbols / diagnostics)
--   <leader>g  Git         (gitsigns / diffview / lazygit)
--   <leader>b  Buffer      (close, pick, list)
--   <leader>w  Window      (split / close / resize)
--   <leader>t  Toggle      (terminal, lazygit, hidden files…)
--   <leader>x  Diagnostics (loclist / quickfix)
--   <leader>e  Explorer    (oil)
--   <leader>c  Code        (LSP code actions, rename — set elsewhere)

local map = vim.keymap.set

-- ── General ─────────────────────────────────────────────────────────
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })
map('n', '<leader>Q', '<cmd>qa!<CR>', { desc = 'Quit all (force)' })

-- Stay centered when paging / searching
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Move selected lines in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Better indent in visual mode (keep selection)
map('v', '<', '<gv')
map('v', '>', '>gv')

-- ── Diagnostics ────────────────────────────────────────────────────
map('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Diagnostics: location list' })
map('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, { desc = 'Prev diagnostic' })
map('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, { desc = 'Next diagnostic' })

-- ── Explorer ───────────────────────────────────────────────────────
-- <leader>e   open oil in the *current* window (vim-vinegar style)
-- <leader>E   same, but at cwd
-- <leader>fe / \   toggle a neo-tree sidebar on the left
--   Inside neo-tree: <CR>/o opens the file in the previously-focused
--   window (the main editor), <C-s> (vsplit), <C-h> (hsplit),
--   <C-t> (new tab).
local function oil_dir_for_current_buf()
  local bufname = vim.api.nvim_buf_get_name(0)
  return bufname == '' and vim.fn.getcwd() or vim.fn.fnamemodify(bufname, ':p:h')
end

map('n', '<leader>e', function()
  local ok, oil = pcall(require, 'oil')
  if not ok then
    vim.notify('oil.nvim is not available', vim.log.levels.WARN)
    return
  end
  oil.open(oil_dir_for_current_buf())
end, { desc = 'Explorer (oil) at file dir' })

map('n', '<leader>E', function()
  local ok, oil = pcall(require, 'oil')
  if ok then oil.open(vim.fn.getcwd()) end
end, { desc = 'Explorer (oil) at cwd' })

map('n', '<leader>fe', '<cmd>Neotree toggle reveal<CR>', { desc = 'Explorer: toggle neo-tree sidebar' })
map('n', '\\',         '<cmd>Neotree toggle reveal<CR>', { desc = 'Explorer: toggle neo-tree sidebar' })

-- ── Buffers ────────────────────────────────────────────────────────
map('n', '<Tab>',   '<cmd>bnext<CR>',     { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<leader>bd', '<cmd>bdelete<CR>',         { desc = 'Buffer: delete' })
map('n', '<leader>bD', '<cmd>bdelete!<CR>',        { desc = 'Buffer: force delete' })
map('n', '<leader>bo', '<cmd>BufferLineCloseOthers<CR>',  { desc = 'Buffer: close others' })
map('n', '<leader>bl', '<cmd>BufferLineCloseRight<CR>',   { desc = 'Buffer: close to right' })
map('n', '<leader>bh', '<cmd>BufferLineCloseLeft<CR>',    { desc = 'Buffer: close to left' })
map('n', '<leader>bp', '<cmd>BufferLinePickClose<CR>',    { desc = 'Buffer: pick & close' })
map('n', '<leader>bP', '<cmd>BufferLineTogglePin<CR>',    { desc = 'Buffer: pin/unpin' })

-- ── Windows ────────────────────────────────────────────────────────
map('n', '<C-h>', '<C-w>h', { desc = 'Window: focus left' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window: focus right' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window: focus below' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window: focus above' })

map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Window: focus left' })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Window: focus right' })
map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Window: focus below' })
map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Window: focus above' })

map('i', '<C-h>', '<Esc><C-w>h', { desc = 'Window: focus left' })
map('i', '<C-l>', '<Esc><C-w>l', { desc = 'Window: focus right' })
map('i', '<C-j>', '<Esc><C-w>j', { desc = 'Window: focus below' })
map('i', '<C-k>', '<Esc><C-w>k', { desc = 'Window: focus above' })

map('n', '<leader>wv', '<cmd>vsplit<CR>',  { desc = 'Window: vertical split' })
map('n', '<leader>ws', '<cmd>split<CR>',   { desc = 'Window: horizontal split' })
map('n', '<leader>wq', '<C-w>q',           { desc = 'Window: close' })
map('n', '<leader>wo', '<C-w>o',           { desc = 'Window: only (close others)' })
map('n', '<leader>w=', '<C-w>=',           { desc = 'Window: equalize sizes' })

-- ── Terminal ───────────────────────────────────────────────────────
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Terminal: exit insert' })
-- (toggleterm registers <leader>tt itself; lazygit at <leader>gg below)

-- ── Autocommands ───────────────────────────────────────────────────
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  desc = 'Trim trailing whitespace on save',
  group = vim.api.nvim_create_augroup('kickstart-trim-ws', { clear = true }),
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(save)
  end,
})
