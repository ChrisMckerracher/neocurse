# IDE Plan — PyCharm-Grade Workflow in This Config

**Status:** DRAFT for discussion — decisions pending (§8)
**Supersedes:** `plans.md` (stale simplification plan — kept for history, no longer maintained)
**Related:** `pi-plan.md` (pi integration — shipped), `KEYBINDINGS.md` (updated as phases land)

---

## 0. Verified audit (2026-07-18)

LSP clients that attach to a single buffer today, per language:

| Language | Attached now | Should be |
|----------|--------------|-----------|
| TypeScript | `ts_ls` ×2, `vtsls`, `null-ls` (4) | `vtsls`, `null-ls` |
| Python | `ruff`, `pyright` ×2, `basedpyright`, `ty`, `pyrefly`, `null-ls` (7) | ONE of pyright/basedpyright + `ruff`, `null-ls` |
| Go | `gopls` ×2, `null-ls` (3) | `gopls`, `null-ls` |

Symptoms this causes: duplicate diagnostics, doubled completions/hover,
multiple servers indexing the same files, wasted CPU, format-on-save
ambiguity.

Root causes (all confirmed):

1. `astrolsp.lua` `servers = { "pyright", "gopls", "ts_ls" }` registers those
   servers, and mason-lspconfig auto-enable registers them AGAIN — exactly
   the three doubled servers.
2. Community packs install extra servers silently: `vtsls` (TS pack),
   `basedpyright`, `ty`, `pyrefly` (Python pack).
3. Mason packages drifted from `ensure_installed`: black, flake8, isort,
   pyment, docker-language-server present without a job.

Already good (keep): `nvim-lsp-file-operations` (neo-tree rename → LSP
rename), ruff as linter/formatter companion, null-ls as pack glue.

---

## 1. Feature matrix — your asks → mechanism → status

| # | You want | Mechanism | Status |
|---|----------|-----------|--------|
| 1 | File browser, pick → opens in "tab" | neo-tree + buffers-as-tabline: every opened file persists as a buffer in the tabline, `Tab`/`S-Tab` cycles. This is already the PyCharm tab model | ✅ works |
| 2 | Right-click refactor menu (rename across files, extract function) | Native popup menu (`:menu PopUp` + `mousemodel=popup`): Rename (LSP), Extract function/variable (code actions), References, Format, **Ask pi** | 🔨 build |
| 3 | Go to definition on click | `<C-LeftMouse>` → `vim.lsp.buf.definition()` | 🔨 tiny |
| 4 | Structure view (classes/members, not lines of code) | Re-enable **aerial.nvim** (in lockfile, currently disabled): symbol tree per file. Project-wide: picker workspace symbols | 🔨 build |
| 5 | Full LSP support | The §2 consolidation + feature keybinds (rename, code action, signature help, implementation, type def, call hierarchy) | 🔨 mostly fix |
| 6 | Indexing to search better | Re-enable **snacks.picker ONLY** (dashboard/notify stay pruned): files, live grep (ripgrep), document/workspace symbols, references, diagnostics | 🔨 build |
| 7 | God-tier debugger | §5 hardening plan (inline values, eval hover, conditional breakpoints, verified adapters) | 🔨 build |
| 8 | All the Cursor features | pi.nvim | ✅ shipped |

Extract-function support by server: gopls ✓, vtsls ✓, pyright ✗ (no
extract code actions) → Python needs a refactoring provider (§2, Q2).

---

## 2. LSP consolidation (the foundation)

```
BEFORE                          AFTER
ts: ts_ls×2 vtsls null-ls  →    ts: vtsls null-ls
py: 5 servers + ruff       →    py: basedpyright|pyright + ruff null-ls
go: gopls×2 null-ls        →    go: gopls null-ls
```

- [ ] Delete `servers = {...}` from `astrolsp.lua` (kills the double
      registration; packs + mason-lspconfig enable the right ones)
- [ ] Pick ONE Python server (Q1) — remove/uninstall the other three
- [ ] `mason.lua` ensure list: drop `typescript-language-server`, add nothing;
      uninstall drifted tools (`:Mason` → black, flake8, isort, pyment,
      pyrefly, ty, docker-language-server, typescript-language-server)
- [ ] Verify formatting ownership: prettier formats TS/JS (none-ls), ruff
      formats Python, gopls formats Go — no double-format on save
- [ ] Verification matrix (headless): exactly the target clients per language
- [ ] Feature sweep keybinds: `<leader>lr` rename, `<leader>la` code action,
      `gi` implementation, `gy` type definition, signature help in insert
      (verify what AstroNvim already maps; document in KEYBINDINGS.md)

## 3. Mouse layer (new)

| Gesture | Action |
|---------|--------|
| Right-click | Popup: **Rename** · **Extract…** (code actions) · **References** · **Go to Definition** · **Format** · ── · **Ask pi** (send selection) |
| Ctrl+click | Go to definition |
| (wheel) | unchanged — pi chat wheel routing already passes through |

- [ ] `vim.opt.mousemodel = "popup"` (cursor stays put on right-click)
- [ ] `:menu PopUp` entries wired to LSP + pi
- [ ] `<C-LeftMouse>` mapping
- [ ] KEYBINDINGS.md mouse section

## 4. Structure view (aerial)

- [ ] Re-enable aerial.nvim (remove from `prune.lua`)
- [ ] Filter to Class/Interface/Struct/Function/Method/Const
- [ ] `<leader>v` toggle, docked left (shares sidebar zone with neo-tree, Q4)
- [ ] Project-wide "contracts": picker `lsp_workspace_symbols`

## 5. Debugger hardening ("god tier")

Current: `dap.lua` launch configs (py/go/ts), dap-ui layouts, F-keys + leaders.

- [ ] Scripted adapter smoke per language (does Go delve actually launch?
      Python debugpy? TS js-debug?) — headless where feasible
- [ ] **`nvim-dap-virtual-text`** — inline variable values at the line.
      One plugin; the single biggest intuition multiplier
- [ ] Eval hover: `K` over expression during a session → `dapui.eval`
- [ ] Conditional breakpoints keybind (`<leader>B`)
- [ ] "Debug test" configs verified for Go + Python
- [ ] Optional: `.vscode/launch.json` loader (nvim-dap reads it natively)

## 6. Search / indexing (snacks.picker only)

```
PyCharm "index" ≈ LSP workspace symbols + ripgrep — no ctags needed.
```

- [ ] Re-enable snacks.nvim with `picker.enabled = true` ONLY — dashboard,
      notifier, bigfile, etc. stay off (prune.lua keeps the rest disabled)
- [ ] Verify AstroNvim's `<leader>f*` maps route to it (files, grep, symbols,
      references, diagnostics, resume)
- [ ] ripgrep present on system (check at implementation)
- [ ] KEYBINDINGS.md search section

## 7. Housekeeping

- [ ] Commit the nvim repo working tree (simplification + pi integration +
      this plan) as split logical commits (Q6)
- [ ] Delete dead config: `.neoconf.json` (neoconf pruned), note plans.md
      superseded (done — see header)
- [ ] Fix `fix_inlay_hints` hack if still needed after LSP consolidation
      (it re-enables hints on every keystroke — re-test without it)

---

## 8. Open questions

- **Q1.** Python server: **basedpyright** (pack default, pyright superset,
  active) — recommended — or keep **pyright** (your original pick)?
- **Q2.** Python extract-function: add **pylsp + rope as a refactor-only
  server** (diagnostics/hover/format disabled — code actions only), or skip
  extract for Python? Recommended: try refactor-only; delete if it misbehaves.
- **Q3.** Picker: **snacks.picker** (recommended — already installed,
  AstroNvim v5-native) over telescope (new dependency)?
- **Q4.** Structure view docked **left** (recommended — pi panel owns the
  right edge as a float) or right?
- **Q5.** Does "god tier" debugger mean anything beyond inline values + eval
  hover + conditional breakpoints + working adapters? (watches UI? REPL?)
- **Q6.** Commit the nvim config working tree now (recommended, split
  commits), or keep floating?

## 9. Phases

| Phase | Scope | Verification |
|-------|-------|--------------|
| P1 | LSP consolidation | client matrix: exactly 1 server/lang + ruff + null-ls |
| P2 | Search (picker) + structure (aerial) | `<leader>ff`, `<leader>v` work |
| P3 | Mouse layer | right-click refactor menu, ctrl-click def |
| P4 | Debugger | per-language smoke + virtual text |
| P5 | Housekeeping | repo committed, dead files gone |
