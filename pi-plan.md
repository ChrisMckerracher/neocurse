# Pi Integration — Status & Pointer

**Goal:** Neovim feels like Cursor, with pi embedded as a library.

The plan has graduated into the pi.nvim repo's doc set (pocket-style
hierarchy). **That doc set is the source of truth — this file only tracks
status.**

- Repo: `~/Code/pi.nvim`
- Design: `docs/architecture/design/001-sdk-host-nvim-embedding.md`
- Decisions: `docs/architecture/adr/` — ADR-001 SDK host · ADR-002 JSONL
  protocol · ADR-003 config/session reuse · ADR-004 patch-based diff review
- Interview record: `docs/architecture/iteration/001-…`
- Feature research: `docs/product/research/cursor-feature-landscape.md`

## Status

| Phase | Deliverable | State |
|-------|-------------|-------|
| 0 | Repo, doc set, tooling, protocol v1, hello-world host | **Done** |
| 1 | Core chat: SDK runtime, sidebar, input, `<space>a` | **Done** |
| 2 | Context push, send-selection, inline edit, `@file` expansion | **Done** |
| 3 | Diff review loop (`<space>ad` / `<space>aD`, accept/reject) | **Done** |
| 4 | Session resume picker, winbar status, `editor_context` pull tool | **Done** |

**v1 shipped.** Protocol v2 (ADR-005). `make check` (13 TS + 14 Lua tests)
and `make e2e` (real nvim + real config) green. Wired into this config via
`lua/plugins/pi.lua`; cheatsheet in `KEYBINDINGS.md`.

## Decisions log

| Question | Decision |
|----------|----------|
| Features | panel, inline edit, diff review, context awareness; autocomplete deferred |
| Architecture | custom TS host embedding pi SDK (ADR-001); no CLI shelling |
| Inline edit | same warm session as panel |
| Review workflow | Cursor semantics: accept = no-op, reject = reverse patch (ADR-004) |
| Context flow | push via protocol; agent-pull tool in Phase 4 |
| Sessions | fresh by default; resume picker in Phase 4; store shared with CLI (`pi -c` works) |
| Repo/name | `~/Code/pi.nvim`, Lua module `pi_nvim` |
| Docs/standards | pocket doc set, adapted (see repo `AGENTS.md`) |
