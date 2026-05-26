return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      ensure_installed = {
        'bash', 'c', 'cpp', 'diff', 'html', 'css', 'json', 'jsonc', 'yaml', 'toml',
        'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'regex',
        'vim', 'vimdoc', 'python', 'rust', 'go', 'javascript', 'typescript', 'tsx',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'a function' },
            ['if'] = { query = '@function.inner', desc = 'inner function' },
            ['ac'] = { query = '@class.outer',    desc = 'a class' },
            ['ic'] = { query = '@class.inner',    desc = 'inner class' },
            ['aa'] = { query = '@parameter.outer', desc = 'a parameter' },
            ['ia'] = { query = '@parameter.inner', desc = 'inner parameter' },
            ['ai'] = { query = '@conditional.outer', desc = 'a conditional' },
            ['ii'] = { query = '@conditional.inner', desc = 'inner conditional' },
            ['al'] = { query = '@loop.outer', desc = 'a loop' },
            ['il'] = { query = '@loop.inner', desc = 'inner loop' },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start     = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
          goto_next_end       = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
          goto_previous_end   = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
        },
        swap = {
          enable = true,
          swap_next     = { ['<leader>cs'] = { query = '@parameter.inner', desc = 'Swap with next parameter' } },
          swap_previous = { ['<leader>cS'] = { query = '@parameter.inner', desc = 'Swap with prev parameter' } },
        },
      },
    },
  },
}
