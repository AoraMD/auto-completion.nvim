# auto-completion

Neovim inline completion plugin powered by Deepseek FIM Beta API.

The plugin wraps the Deepseek FIM HTTP endpoint as a minimal LSP server
(stdin/stdout, JSON-RPC 2.0) so that Neovim's native `vim.lsp.inline_completion`
renders ghost-text suggestions as you type.

## Requirements

- Neovim >= 0.12
- Python >= 3.10 (no packages needed -- stdlib only)
- `DEEPSEEK_API_KEY` environment variable

## Install

```lua
-- lazy.nvim
{
  "AoraMD/auto-completion.nvim",
  config = function()
    require("auto-completion").setup()
  end,
}
```

## Setup

```lua
require("auto-completion").setup(
  {
    -- filetypes to attach (defaults shown)
    filetypes = {
      "c", "cpp", "go", "java", "javascript", "kotlin",
      "lua", "php", "python", "ruby", "rust", "swift",
      "typescript", "zig",
    },
    -- override the server command (auto-resolved by default)
    -- server_cmd = { "python3", "/custom/path/to/deepseek-fim-server" },
  }
)
```

## Keymaps

The plugin does not set keymaps.  Add your own:

```lua
-- Accept the current ghost-text suggestion (returns true if applied)
vim.keymap.set(
  "i",
  "<Tab>",
  function()
    if vim.lsp.inline_completion.get() then
      return ""
    end
    return "<Tab>"
  end,
  { expr = true },
)
```

There is no public dismiss API -- the suggestion auto-hides when you
continue typing or leave insert mode.

## Commands

| Command | Action |
|---|---|
| `:LspStart auto-completion` | Start the client manually |
| `:LspStop auto-completion` | Stop the client |

## How it works

```
Insert mode keystroke
  -> Neovim sends textDocument/inlineCompletion (LSP, stdio)
  -> deepseek-fim-server extracts prefix/suffix near cursor
  -> POST https://api.deepseek.com/beta/completions (FIM)
  -> returns InlineCompletionItem
  -> vim.lsp.inline_completion renders ghost text
```
