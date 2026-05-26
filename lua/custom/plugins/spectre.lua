-- Project-wide search and replace (sed-style preview).
-- Note: <leader>sw and <leader>sr are reserved for telescope (grep_string / resume),
-- so spectre lives under <leader>sp / <leader>sP.
return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = 'Spectre',
  keys = {
    { '<leader>sp', function() require('spectre').toggle() end,                                  desc = 'Spectre: search/replace (project)' },
    { '<leader>sP', function() require('spectre').open_file_search { select_word = true } end,   desc = 'Spectre: search/replace (current file)' },
    { '<leader>sp', function() require('spectre').open_visual() end, mode = 'v',                 desc = 'Spectre: search selection' },
  },
  opts = {},
}
