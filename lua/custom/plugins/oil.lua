-- lua/plugins/oil.lua
return {
  'stevearc/oil.nvim',
  -- Optional: provides file icons in the column view
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  -- Lazy-loading options (enable if desired)
  -- event = "VeryLazy",
  cmd = { 'Oil' },

  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Oil: Open parent directory' },
    { '<leader>o', '<cmd>Oil<cr>', desc = 'Oil: Open' },
  },

  config = function()
    require('oil').setup {
      -- Use Oil as the default file explorer
      default_file_explorer = true,

      -- Columns to display in the file list
      columns = {
        'icon',
        -- "permissions",
        -- "size",
        -- "mtime",
      },

      -- Buffer-local options for Oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },

      -- Window-local options for Oil buffers
      win_options = {
        wrap = false,
        signcolumn = 'no',
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },

      -- File operation behavior
      delete_to_trash = false,
      skip_confirm_for_simple_edits = false,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms = 2000,

      -- LSP-based file operations (rename, move, etc.)
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = false,
      },

      -- Cursor behavior
      constrain_cursor = 'editable',

      -- Disable filesystem change watching
      watch_for_changes = false,

      -- Custom keymaps inside Oil buffers
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },

      -- Whether to enable Oil's default keymaps
      use_default_keymaps = true,

      -- View and sorting options
      view_options = {
        show_hidden = false,

        -- Define what counts as a hidden file
        is_hidden_file = function(name, bufnr)
          return name:match '^%.' ~= nil
        end,

        -- Define files that should always be hidden
        is_always_hidden = function(name, bufnr)
          return false
        end,

        natural_order = 'fast',
        case_insensitive = false,

        -- Sorting rules
        sort = {
          { 'type', 'asc' },
          { 'name', 'asc' },
        },

        -- Optional filename highlight override
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
          return nil
        end,
      },

      -- Extra arguments for remote protocols
      extra_scp_args = {},
      extra_s3_args = {},

      -- Git integration hooks (disabled here)
      git = {
        add = function(path)
          return false
        end,
        mv = function(src_path, dest_path)
          return false
        end,
        rm = function(path)
          return false
        end,
      },

      -- Floating window configuration
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = nil,
        win_options = {
          winblend = 0,
        },
        get_win_title = nil,
        preview_split = 'auto',
        override = function(conf)
          return conf
        end,
      },

      -- Preview window behavior
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = 'fast_scratch',
        disable_preview = function(filename)
          return false
        end,
        win_options = {},
      },

      -- Confirmation dialog configuration
      confirmation = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = nil,
        win_options = {
          winblend = 0,
        },
      },

      -- Progress window configuration
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = nil,
        minimized_border = 'none',
        win_options = {
          winblend = 0,
        },
      },

      -- SSH-related UI options
      ssh = {
        border = nil,
      },

      -- Help window options for keymaps
      keymaps_help = {
        border = nil,
      },
    }
  end,
}
