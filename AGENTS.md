# Authorship
- 2026-08-01 05:45 — agent: pi (k3) (initial agent context for session continuity)
- 2026-08-03 01:15 — agent: pi (k3) (mason-venv/python-upgrade breakage convention after debugger repair)

# nvim config — Agent Instructions

From-scratch Neovim config — **no distribution** (AstroNvim was removed
2026-07-18; see `ide-plan.md` for the audit and why). Every line here is
owned. Languages: Go, Python, TypeScript.

**If you're picking up work:** the agent-integration project lives at
`~/Code/pi.nvim` — start with its `docs/HANDOFF.md` (auto-loaded when pi
runs there) for the current state and open work items.

## Layout

```
init.lua            bootstrap + lazy setup
lua/options.lua     editor options (small-screen first, scales to 1440p)
lua/keymaps.lua     every keybinding + right-click refactor menu
lua/sidebar.lua     unified 3-state sidebar contract helpers
lua/autocmds.lua    autosave, autoreload, LSP attach, filetype seams
lua/lsp.lua         native 0.11 LSP — one strong server per language
lua/plugins/        lazy specs: ui, editor, tools, dap, pi
```

## Docs

- `KEYBINDINGS.md` — the keybinding cheatsheet (`Space ?` / `:Keymaps`)
- `ide-plan.md` — the IDE audit and from-scratch decision (closed out)
- `pi-plan.md` — pointer to the pi.nvim doc set

## Conventions

- Lua: stylua (`~/.local/share/nvim/mason/bin/stylua`) — 120/2-space/double
- Commits: conventional style; agent co-author trailer `pi (<model>) <noreply@pi.local>`
- LSP client matrix is verified: Go=gopls, Python=pyright+ruff, TS=vtsls.
  Do not add servers without checking `vim.lsp.get_clients()` per language.
- Environment: `python3` exists, `python` does not.
- Mason python venvs break silently on system python upgrades (the venv's
  `bin/python` symlinks `/usr/bin/python3`, but site-packages is
  versioned). Symptom: adapter exits 1 with `No module named '<pkg>'`.
  Repair in place: `uv venv <pkg>/venv --system-site-packages &&
  uv pip install --python <pkg>/venv/bin/python <pkg>` (debugpy rebuilt
  this way 2026-08-03 → 1.8.21).
