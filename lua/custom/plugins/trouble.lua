return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    focus = true,
    auto_close = true,
    modes = {
      diagnostics = { auto_open = false },
    },
  },
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',                         desc = 'Trouble: workspace diagnostics' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',            desc = 'Trouble: buffer diagnostics' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>',                 desc = 'Trouble: symbols' },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',  desc = 'Trouble: LSP refs/defs' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                             desc = 'Trouble: location list' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>',                              desc = 'Trouble: quickfix list' },
    { '<leader>xt', '<cmd>Trouble todo toggle<cr>',                                desc = 'Trouble: TODOs (todo-comments)' },
  },
}
