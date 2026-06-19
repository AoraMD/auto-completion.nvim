local M = {}

local _DEFAULT_FILETYPES = {
  "c",
  "cpp",
  "go",
  "java",
  "javascript",
  "kotlin",
  "lua",
  "markdown",
  "python",
  "rust",
  "swift",
  "typescript",
}

---Configure and start the auto-completion LSP client.
---
---Registers a vim.lsp client named "auto-completion" that talks to the
---deepseek-fim-server binary via stdio.  When the client attaches,
---vim.lsp.inline_completion is automatically enabled so that ghost-text
---suggestions appear as you type in insert mode.
---
---@param opts? {filetypes?: string[], server_cmd?: string[], debounce_ms?: integer}
function M.setup(
  opts
)
  opts = opts or {}

  local script_dir = debug.getinfo(1, "S").source:sub(2)
  script_dir = vim.fn.fnamemodify(script_dir, ":h:h:h")
  local server_cmd = opts.server_cmd
    or { script_dir .. "/lsp-server/deepseek-fim-server" }

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup(
      "AutoCompletionInline",
      { clear = true }
    ),
    callback = function(
      ev
    )
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client.name == "auto-completion" then
        vim.lsp.inline_completion.enable(true)
      end
    end,
  })

  vim.lsp.config("auto-completion", {
    cmd = server_cmd,
    cmd_env = {
      AUTO_COMPLETION_DEBOUNCE_MS = tostring(opts.debounce_ms or 250),
    },
    filetypes = opts.filetypes or _DEFAULT_FILETYPES,
  })

  vim.lsp.enable("auto-completion")
end

return M
