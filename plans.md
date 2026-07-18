# Neovim Setup Simplification Plan

> **SUPERSEDED (2026-07-18)** — this plan is complete/stale. The active plan
> for the rest of the setup is **`ide-plan.md`**. This file is kept for
> history only; checkboxes below were the original simplification roadmap.

**Goal:** Simplify AstroNvim v5 config for Go, Python, and TypeScript development.
**Style:** Emulate PyCharm — dead simple keybindings, minimal config.

## Current State
- Running stock AstroNvim v5 with ~40 plugins
- Almost zero custom config enabled (all files return `{}` due to guard line)
- No language-specific tooling configured

---

## Keybindings

**Leader key = `Space`**
Press `Space` then the key to execute any `<leader>` binding.

### File Explorer
| Key | Action |
|---|---|
| `<leader>e` | Toggle file explorer (neo-tree sidebar) |
| — | Files open as **buffers** (displayed as tabs in the tabline) |

**Note:** Neovim buffers ≠ tabs. Buffers are files in memory. AstroNvim displays open buffers as a tabline at the top (via heirline), which looks and feels like PyCharm's editor tabs. Neovim "tabs" are actually workspace layouts — we won't use those.

### Buffer Navigation (visual "tabs")
| Key | Action |
|---|---|
| `<Tab>` | Next buffer (next "tab") |
| `<S-Tab>` | Previous buffer |
| `<leader>x` | Close buffer |
| `<leader>1-9` | Jump to buffer 1-9 in tabline |

### Debugging
| Key | Action |
|---|---|
| `<leader>b` | Toggle breakpoint |
| `F5` / `<leader>r` | Start / continue debugging |
| `F10` / `<leader>n` | Step over |
| `F11` / `<leader>i` | Step into |
| `<S-F12>` / `<leader>o` | Step out |
| `<leader>d` | Toggle debug UI (dap-ui: stack, vars, breakpoints) |

### Running
| Key | Action |
|---|---|
| `<leader>R` | Run current file (no debugger) |

### Formatting
| Key | Action |
|---|---|
| `<leader>f` | Format current file |

### Navigation
| Key | Action |
|---|---|
| `gd` | Go to definition (including site-packages, node_modules, Go module cache) |
| `gr` | Find references |
| `K` | Hover documentation |

---

## Implementation Plan

### 1. Enable `community.lua` — Language Packs
- [ ] `astrocommunity.pack.go`
- [ ] `astrocommunity.pack.python`
- [ ] `astrocommunity.pack.typescript`
- [ ] `astrocommunity.pack.lua`

### 2. Enable `mason.lua` — Tool Installer
- [ ] `gopls` (Go LSP)
- [ ] `gofumpt` (Go formatter)
- [ ] `goimports` (Go import organizer)
- [ ] `delve` (Go debugger)
- [ ] `pyright` (Python LSP — indexes venv/site-packages)
- [ ] `ruff` (Python linter/formatter)
- [ ] `debugpy` (Python debugger)
- [ ] `typescript-language-server` (TS/JS LSP)
- [ ] `js-debug-adapter` (TS/JS debugger)
- [ ] `prettier` (TS/JS formatter)
- [ ] `stylua` (Lua formatter)
- [ ] `lua-language-server` (Lua LSP)

### 3. Enable `treesitter.lua` — Parsers
- [ ] `go`
- [ ] `python`
- [ ] `typescript`
- [ ] `tsx`
- [ ] `lua`
- [ ] `vim`

### 4. Enable `astrolsp.lua` — LSP Config
- [ ] Format on save for Go, Python, TypeScript
- [ ] Enable inlay hints (PyCharm-style)
- [ ] Keep codelens on
- [ ] Register `pyright`, `gopls`, `tsserver` as servers

### 5. Configure neo-tree
- [ ] Files open as buffers (displayed in tabline)
- [ ] `<leader>e` to toggle sidebar
- [ ] Auto-refresh when files change on disk

### 6. Configure DAP + dap-ui
- [ ] Python: launch configs for `python file.py`, `fastapi dev main.py`, attach
- [ ] Go: launch configs for `go run`, debug test
- [ ] TypeScript: launch configs for `node`, `ts-node`
- [ ] dap-ui panels: scopes, call stack, breakpoints, REPL
- [ ] Wire up keybindings (F5-F12, leader keys)

### 7. Completion (blink.cmp)
- [ ] Auto-import: typing an unresolved name shows import suggestions (LSP-driven — pyright, gopls, tsserver all provide this)
- [ ] Member discovery: typing `a.` shows all members/functions of `a` (LSP-driven, works out of the box)
- [ ] Both require zero extra plugins — blink.cmp + LSP servers handle it

### 8. Quality of Life
- [ ] `vim-illuminate` — highlight word under cursor (already installed)
- [ ] `nvim-autopairs` — auto-close brackets (already installed)

#### Auto-save
In `astrocore.lua` options:
- `vim.opt.autowrite = true` — save on `:make`, buffer switch, etc.
- Autocommand: save on `CursorHold` (after 1s idle) and `FocusLost` (window loses focus)

```
vim.api.nvim_create_autocmd({ "CursorHold", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and vim.bo.buflisted then vim.cmd "silent! write" end
  end,
})
```

#### Auto-refresh (files changed outside editor)
In `astrocore.lua` options:
- `vim.opt.autoread = true` — auto-reload when Neovim detects file changed
- Autocommand: check for changes on `FocusGained` and `BufEnter`

```
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function()
    if vim.bo.buflisted and not vim.bo.modified then vim.cmd "checktime" end
  end,
})
```

### 9. Keybindings Cheatsheet
- [ ] Create `KEYBINDINGS.md` in config root with all custom and navigation bindings
- [ ] Add `<leader>?` mapping to open it quickly

### 10. Clean Up
- [ ] Strip boilerplate from `user.lua`
- [ ] Strip boilerplate from `astrocore.lua`
- [ ] Leave `none-ls.lua` disabled (community packs handle formatters/linters)
- [ ] Remove `gD` mapping from `polish.lua` (redundant with `gd`)

---

## Plugins: Keep vs Prune

### Keep
| Plugin | Reason |
|---|---|
| AstroNvim core (astrocore, astrolsp, astroui, astrotheme) | Framework |
| `lazy.nvim`, `plenary.nvim`, `nui.nvim` | Dependencies |
| `blink.cmp` + `blink.compat` | Completion |
| `cmp-dap` | Completion in DAP debug repl |
| `neo-tree.nvim` | File explorer sidebar |
| `nvim-lspconfig` | LSP |
| `mason.nvim` + mason ecosystem | Tool installer |
| `nvim-dap` + `nvim-dap-ui` + `nvim-nio` | Debugging |
| `nvim-treesitter` | Syntax highlighting |
| `nvim-autopairs` | Auto-close brackets |
| `vim-illuminate` | Highlight word under cursor |
| `mini.icons` | File icons |
| `heirline.nvim` | Statusline |

### Prune
| Plugin | Why |
|---|---|
| `neoconf.nvim` | Per-project config — overkill |
| `resession.nvim` | Session restore — not needed |
| `lazydev.nvim` | Lua dev — not needed |
| `LuaSnip` + `friendly-snippets` | Snippets — not in workflow |
| `nvim-ts-autotag` | HTML/JSX tag stuff — only React |
| `aerial.nvim` | Code outline — not asked for |
| `todo-comments.nvim` | TODO highlighting — not asked for |
| `better-escape.nvim` | jk escape — not asked for |
| `nvim-highlight-colors` | Color previews — not asked for |
| `snacks.nvim` | Dashboard/notifications — eye candy |
| `nvim-window-picker.nvim` | Pick window — not asked for |
| `nvim-treesitter-textobjects` | Smart selection — not asked for |
| `guess-indent.nvim` | Auto-detect indent — not asked for |
| `smart-splits.nvim` | Smart pane nav — not asked for |
| `toggleterm.nvim` | Terminal — not asked for |
| `gitsigns.nvim` | Git gutter — not asked for |
| `which-key.nvim` | Keybinding popup — not asked for |

---

## Notes
- Community packs handle most formatter/linter/DAP config automatically
- pyright indexes site-packages when venv is active or configured
- gopls indexes Go module cache by default
- tsserver indexes node_modules by default
- AstroNvim default keybindings cover most navigation needs
