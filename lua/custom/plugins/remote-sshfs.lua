return {
  'nosduco/remote-sshfs.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('remote-sshfs').setup {
      connections = {
        ssh_configs = {
          vim.fn.expand '$HOME/.ssh/config',
        },
        sshfs_args = {
          '-o',
          'reconnect',
          '-o',
          'ConnectTimeout=5',
          '-o',
          'IdentityFile=/Users/username/.ssh/id_rsa',
          '-o',
          'IdentitiesOnly=yes',
        },
      },
      mounts = {
        base_dir = vim.fn.expand '$HOME/.sshfs/',
        unmount_on_exit = true,
      },
      handlers = {
        on_connect = { change_dir = true },
        on_disconnect = { clean_mount_folders = false },
        on_edit = {},
      },
      ui = {
        select_prompts = false,
        confirm = {
          connect = true,
          change_dir = false,
        },
      },
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          util = false,
          handler = false,
          sshfs = false,
        },
      },
    }

    require('telescope').load_extension 'remote-sshfs'
  end,
}
