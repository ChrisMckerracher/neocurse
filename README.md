# neocurse

An agentic, no-config Neovim setup. Clone it, run `nvim`, start work —
[pi](https://pi.dev) is embedded in the editor, and the editor configures
itself on request.

- **No distribution** — every line is owned, written from scratch (see
  [ide-plan.md](ide-plan.md) for the audit that got here). No AstroNvim, no
  LazyVim, no defaults you have to fight.
- **Agentic** — [pi.nvim](https://github.com/ChrisMckerracher/pi.nvim) puts a
  Cursor-style agent panel, inline edit, and native diff review in the editor,
  driving your existing `~/.pi/agent` config (auth, models, skills, sessions).
- **No config** — languages (Go, Python, TypeScript, Lua) get LSP, lint/format,
  and debuggers auto-installed via mason on first launch. And when you want a
  change, you can just *ask* (below).

## Requirements

| Requirement | Notes |
|-------------|-------|
| Neovim ≥ 0.11 | developed on 0.12 |
| Node.js ≥ 22.19 | pi.nvim host runtime |
| [pi](https://pi.dev) configured (`~/.pi/agent`) | agent auth + models |
| git, unzip, a C compiler | lazy.nvim / mason / treesitter bootstrap |

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/ChrisMckerracher/neocurse/main/install.sh | sh
```

Or manually:

```sh
git clone --depth 1 https://github.com/ChrisMckerracher/neocurse ~/.config/nvim
```

An existing `~/.config/nvim` is backed up to `~/.config/nvim.bak.<timestamp>`
by the installer; the manual clone requires you to move it aside first.

First launch bootstraps lazy.nvim, clones the plugins (pi.nvim compiles its
TypeScript host — needs node), and mason installs the toolchain. Verify with:

```vim
:checkhealth pi_nvim
```

## Using it

**Leader is `Space`.** Full cheatsheet: [KEYBINDINGS.md](KEYBINDINGS.md)
(`Space ?` in the editor). The essentials:

| Key | Action |
|-----|--------|
| `Space a` | AI agent panel (chat with pi) |
| `Space ak` | Inline edit selection with pi |
| `Space e` / `Space v` | File tree / symbol structure |
| `Space d` | Debugger UI |
| `Space f` / `Space s` | Find files / symbols (snacks/picker) |

In the panel: type, `Enter` sends, `@path` attaches files, `Space ad`
reviews agent edits in a native diff, `Space aD` reverts them.

## Configuring it

**With AI (the point):** open this repo in nvim (`nvim ~/.config/nvim`), hit
`Space a`, and ask — *"add a keybind that reformats the buffer"*, *"set up
yaml LSP"*, *"make the pi panel wider"*. The agent reads this repo's
`AGENTS.md` (auto-loaded), routes the change to the owning module, verifies
headless boot, and updates the cheatsheet. The loop and its rules live in
`AGENTS.md` → *Self-configuration*.

**By hand:** each concern has exactly one home —

| Concern | File |
|---------|------|
| Keybinds | `lua/keymaps.lua` |
| Editor options | `lua/options.lua` |
| LSP | `lua/lsp.lua` |
| Plugin specs | `lua/plugins/<concern>.lua` |
| Autocmds | `lua/autocmds.lua` |
| pi panel opts | `lua/plugins/pi.lua` (all options: [pi.nvim README](https://github.com/ChrisMckerracher/pi.nvim#configuration)) |

## Layout

```
install.sh          one-command installer (backup-aware)
init.lua            lazy.nvim bootstrap + setup
lua/options.lua     editor options (small-screen first, scales to 1440p)
lua/keymaps.lua     every keybinding + right-click refactor menu
lua/sidebar.lua     unified 3-state sidebar contract helpers
lua/autocmds.lua    autosave, autoreload, LSP attach, filetype seams
lua/lsp.lua         native 0.11 LSP — one strong server per language
lua/plugins/        lazy specs: ui, editor, tools, dap, pi
KEYBINDINGS.md      the cheatsheet (Space ?)
AGENTS.md           agent instructions incl. the self-configuration protocol
```

## History

This config replaced an AstroNvim distribution (audit in
[ide-plan.md](ide-plan.md)) and evolved alongside pi.nvim, which was built
*for* it. The commit history is the real record.
