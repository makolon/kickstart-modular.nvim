-- VSCode-like startup layout (managed by edgy.nvim):
-- Left: Neo-tree (full height) | Center-top: Editor | Center-bottom: Terminal | Right: Claude
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('vscode_layout', { clear = true }),
        callback = function()
          vim.g._layout_loading = true
          vim.schedule(function()
            vim.cmd 'Neotree show'

            vim.schedule(function()
              vim.cmd 'ToggleTerm direction=horizontal'

              vim.schedule(function()
                local ok, cli = pcall(require, 'sidekick.cli')
                if ok then
                  cli.show { name = 'claude', focus = false }
                end

                vim.defer_fn(function()
                  for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    local ft = vim.bo[buf].filetype
                    local bt = vim.bo[buf].buftype
                    if ft ~= 'neo-tree' and ft ~= 'toggleterm' and ft ~= 'sidekick' and bt ~= 'terminal' then
                      vim.api.nvim_set_current_win(win)
                      vim.cmd 'stopinsert'
                      break
                    end
                  end
                  vim.g._layout_loading = false
                end, 300)
              end)
            end)
          end)
        end,
      })
    end,
  },
}
