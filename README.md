# nvim config

From-scratch Neovim config — no distribution. Go, Python, TypeScript.

- **Design & audit:** [ide-plan.md](ide-plan.md)
- **Keybindings:** [KEYBINDINGS.md](KEYBINDINGS.md) (`Space ?` in editor)
- **Agent integration:** [pi-plan.md](pi-plan.md) → repo at `~/Code/pi.nvim`

## Layout

```
init.lua            bootstrap + lazy setup
lua/options.lua     editor options (small-screen first, scales to 1440p)
lua/keymaps.lua     every keybinding + right-click refactor menu
lua/autocmds.lua    autosave, autoreload, LSP attach wiring
lua/lsp.lua         native 0.11 LSP — one strong server per language
lua/plugins/        lazy specs: ui, editor, tools, dap, pi
```

## LSP (verified, one job each)

| Language | Server(s) | Lint/format | Debug |
|----------|-----------|-------------|-------|
| Go | gopls | goimports (conform) | delve |
| Python | pyright | ruff | debugpy |
| TypeScript | vtsls | prettier | js-debug-adapter |
| Lua (config) | lua_ls | stylua | — |

Tools auto-install via mason on first launch.
