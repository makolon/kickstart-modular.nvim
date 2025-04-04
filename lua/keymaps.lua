-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Open a file via Telescope and reveal it in Neo-tree
vim.keymap.set('n', '<leader>ef', function()
  local builtin = require 'telescope.builtin'
  builtin.find_files {
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local actions = require 'telescope.actions'
        local action_state = require 'telescope.actions.state'
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Open the selected file
        vim.cmd('edit ' .. entry.path)

        -- Reveal the file location in Neo-tree
        vim.cmd 'Neotree reveal'
      end)
      return true
    end,
  }
end, { desc = 'Find file and reveal in Neo-tree' })

-- Open Telescope file browser, and reveal the selected directory in Neo-tree
vim.keymap.set('n', '<leader>ed', function()
  local fb = require('telescope').extensions.file_browser
  fb.file_browser {
    prompt_title = 'Browse Directories',
    select_buffer = true,
    depth = 1,
    hijack_netrw = false,
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local actions = require 'telescope.actions'
        local action_state = require 'telescope.actions.state'
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- If selected is a file, extract its parent directory
        local path = entry.path or entry.filename
        local dir = vim.fn.isdirectory(path) == 1 and path or vim.fn.fnamemodify(path, ':h')

        -- Reveal that directory in Neo-tree
        vim.cmd('Neotree reveal dir=' .. dir)
      end)
      return true
    end,
  }
end, { desc = 'Browse and reveal directory in Neo-tree' })

-- Move between buffers (VSCode-style tab switching)
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Close current buffer' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
