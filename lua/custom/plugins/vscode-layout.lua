-- VSCode-like startup layout:
-- Left: Neo-tree | Center-top: Editor | Center-bottom: Terminal | Right: Claude (sidekick)
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('vscode_layout', { clear = true }),
        callback = function()
          vim.schedule(function()
            -- 1. Open Neo-tree on the left
            vim.cmd 'Neotree show'

            -- 2. Open horizontal terminal at the bottom
            vim.cmd 'ToggleTerm direction=horizontal size=15'

            -- 3. Open sidekick (Claude) on the right
            local ok, cli = pcall(require, 'sidekick.cli')
            if ok then
              cli.show { name = 'claude', focus = false }
            end

            -- 4. Focus Neo-tree
            vim.schedule(function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype
                if ft == 'neo-tree' then
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end)
          end)
        end,
      })
    end,
  },
}
