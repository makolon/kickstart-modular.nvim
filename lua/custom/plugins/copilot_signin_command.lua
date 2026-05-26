-- Adds :LspCopilotSignIn even if nvim-lspconfig's command is not defined.
-- This calls Copilot LSP's "signIn" request (same idea as lsp/copilot.lua in nvim-lspconfig).

local function get_copilot_client()
  local clients = vim.lsp.get_clients and vim.lsp.get_clients() or {}
  for _, c in ipairs(clients) do
    if c.name == 'copilot' then
      return c
    end
  end
  return nil
end

local function sign_in()
  local client = get_copilot_client()
  if not client then
    vim.notify('Copilot LSP client is not running. Open a file in a git repo and try again.', vim.log.levels.ERROR)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()

  client:request('signIn', vim.empty_dict(), function(err, result)
    if err then
      vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
      return
    end
    if not result then
      vim.notify('Copilot sign-in returned no result.', vim.log.levels.ERROR)
      return
    end

    -- Some responses provide a command and userCode (device flow).
    if result.command then
      local code = result.userCode or ''
      local command = result.command

      -- Copy code to clipboard registers.
      vim.fn.setreg('+', code)
      vim.fn.setreg('*', code)

      local ok = vim.fn.confirm('Copied one-time code to clipboard.\nOpen the browser to complete sign-in?', '&Yes\n&No')
      if ok == 1 then
        -- Prefer client:exec_cmd if available (matches lspconfig implementation),
        -- otherwise fall back to vim.lsp.buf.execute_command.
        if client.exec_cmd then
          client:exec_cmd(command, { bufnr = bufnr }, function(cmd_err, cmd_result)
            if cmd_err then
              vim.notify(cmd_err.message or tostring(cmd_err), vim.log.levels.ERROR)
              return
            end
            if cmd_result and cmd_result.status == 'OK' then
              vim.notify('Signed in as ' .. (cmd_result.user or '?') .. '.')
            else
              vim.notify('Copilot sign-in command executed.', vim.log.levels.INFO)
            end
          end)
        else
          vim.lsp.buf.execute_command(command)
          vim.notify('Copilot sign-in command executed. Follow the browser flow.', vim.log.levels.INFO)
        end
      end
    end

    -- Fallback informational statuses.
    if result.status == 'PromptUserDeviceFlow' then
      vim.notify(('Enter code %s in %s'):format(result.userCode or '?', result.verificationUri or '?'))
    elseif result.status == 'AlreadySignedIn' then
      vim.notify('Already signed in as ' .. (result.user or '?') .. '.')
    end
  end)
end

return {
  {
    -- No dependency is strictly required; this just defines a user command.
    'folke/sidekick.nvim',
    optional = true,
    init = function()
      vim.api.nvim_create_user_command('LspCopilotSignIn', sign_in, {})
    end,
  },
}
