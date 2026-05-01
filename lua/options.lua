-- [[ Setting options ]]
-- See `:help vim.o`

-- Line numbers (relative makes vertical motion easier)
vim.o.number = true
vim.o.relativenumber = true

-- True color support (required by most modern colorschemes/plugins)
vim.o.termguicolors = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Indentation
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

-- Save undo history
vim.o.undofile = true
vim.o.swapfile = false
vim.o.backup = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Whitespace rendering
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Keep more context around the cursor
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- A single-line cmdline reduces visual noise
vim.o.cmdheight = 1

-- Smoother completion menu behavior
vim.o.completeopt = 'menu,menuone,noselect'

-- No annoying "press enter to continue"
vim.o.shortmess = vim.o.shortmess .. 'cI'

-- Confirm before discarding unsaved changes on quit
vim.o.confirm = true

-- Wrap behavior
vim.o.wrap = false
vim.o.linebreak = true

-- Folding (treesitter-based, but start unfolded)
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- shada history
vim.opt.shada:remove '<'
vim.opt.shada:append '<10000'
