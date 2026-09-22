# Authorship
- 2026-08-01 05:45 — agent: pi (k3) (initial agent context for session continuity)
- 2026-08-03 01:15 — agent: pi (k3) (mason-venv/python-upgrade breakage convention after debugger repair)
- 2026-09-22 02:40 — agent: pi (glm-5.3) (public neocurse repo — pi plugin from GitHub, self-configuration protocol)

# neocurse — Agent Instructions

From-scratch Neovim config — **no distribution** (AstroNvim was removed
2026-07-18; see `ide-plan.md` for the audit and why). Every line here is
owned. Languages: Go, Python, TypeScript. Shipped as **neocurse**, an
agentic no-config setup: pi.nvim is a first-class citizen, and this file is
how the agent configures the setup itself (see Self-configuration below).

**If you're picking up work on the agent integration itself:** the pi.nvim
repo is at https://github.com/ChrisMckerracher/pi.nvim (local checkout
`~/Code/pi.nvim` on dev machines) — start with its `docs/HANDOFF.md`
(auto-loaded when pi runs there) for the current state and open work items.

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
- `README.md` — public-facing install/config guide

## Self-configuration — configuring neocurse with AI

The embedded pi agent (this repo's own user) configures neocurse on request
("add a rust keybind", "set up yaml LSP", "make the panel wider"). When asked:

1. **Route the change to the owning module** — never scatter config:
   keybinds → `lua/keymaps.lua`; options → `lua/options.lua`; LSP →
   `lua/lsp.lua`; plugin specs → `lua/plugins/<concern>.lua`; autocmds →
   `lua/autocmds.lua`; pi panel opts → `lua/plugins/pi.lua`.
2. **Follow the invariants** — sidebar 3-state contract (`lua/sidebar.lua`);
   one strong LSP server per language, verified via `vim.lsp.get_clients()`
   before adding; leader is Space, pi lives under `Space a`.
3. **Verify before claiming done** — headless boot must exit clean:
   `nvim --headless "+lua vim.defer_fn(function() vim.cmd'quitall' end, 2000)"`
   (the defer lets lazy/mason settle; check `:checkhealth` output when relevant).
   Interactive-only behavior (floats, keystrokes): tmux send-keys/capture-pane.
4. **Update the docs that describe what changed** — keybind changes update
   `KEYBINDINGS.md` in the same commit; new plugins update `README.md` layout.
5. **Commit** — conventional style, agent co-author trailer (see Conventions).

Humans configuring by hand follow the same routing table — the modules are
small and single-concern on purpose.

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
