return {
  'github/copilot.vim',
  lazy = false,
  config = function()
    -- Disable default Tab mapping to prevent conflicts
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ''
  end,
}
