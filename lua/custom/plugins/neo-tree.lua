-- lua/custom/plugins/neo-tree.lua
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  opts = {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf', 'oil', 'neo-tree' },
    default_component_configs = {
      indent = {
        with_markers = true,
        with_expanders = true,
      },
    },
    window = {
      position = 'left',
      width = 30,
      mappings = {
        ['<CR>']  = 'open',
        ['o']     = 'open',
        ['<C-s>'] = 'open_vsplit',
        ['<C-h>'] = 'open_split',
        ['<C-t>'] = 'open_tabnew',
        ['P']     = { 'toggle_preview', config = { use_float = true } },
        ['H']     = 'toggle_hidden',
        ['R']     = 'refresh',
        ['a']     = { 'add', config = { show_path = 'relative' } },
        ['A']     = 'add_directory',
        ['d']     = 'delete',
        ['r']     = 'rename',
        ['y']     = 'copy_to_clipboard',
        ['x']     = 'cut_to_clipboard',
        ['p']     = 'paste_from_clipboard',
        ['c']     = 'copy',
        ['m']     = 'move',
        ['q']     = 'close_window',
        ['?']     = 'show_help',
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = false,
      },
    },
    buffers = {
      follow_current_file = { enabled = true },
    },
  },
}
