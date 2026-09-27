# Keybindings Cheatsheet

**Leader key = Space.** From-scratch config — no distribution defaults.
Mouse works everywhere; right-click opens a refactor menu.

Use `Space ?` or `:Keymaps` to open the floating keybinding picker.
Type a key or description to filter; each row shows its mode and shortcut.
It includes global and current-buffer mappings. `Alt-g` / `Alt-b` toggle those
sources; `Esc` closes the picker. Selecting a row closes it without running
the shortcut. This file remains the guide to workflows and built-in motions.

## Moving between windows

In normal mode (press `Esc` first while typing), `Space w h/j/k/l` moves
left/down/up/right. `Space w w` cycles windows. `Ctrl-h/j/k/l` and native
`Ctrl-w h/j/k/l` also work. Pi keeps focus when you press Escape.

| Destination | Key |
|---|---|
| Editor buffer | `Space w e` |
| File tree | `Space w t` |
| Pi prompt | `Space w p` |

The file tree opens files in an editor window. File pickers, buffer cycling, and
numbered buffer shortcuts also target the editor, preserving Pi's draft and chat.

## Sidebar controls

File tree and structure view use these focus-aware controls:

| State you're in | `Space e` / `Space v` does |
|---|---|
| Surface **closed** | opens it **and focuses it** |
| Surface **open**, you're elsewhere | jumps focus to it |
| Surface **open**, you're inside it | closes it |

| Surface | Key |
|---|---|
| File tree (neo-tree) | `Space e` |
| AI sidebar (pi) | `Space a` |
| Structure (aerial) | `Space v` |
| Debugger (dap-ui) | `Space d` |

| Universal keys | Action |
|---|---|
| `Ctrl-h/j/k/l` | Hop between ANY windows (editor, tree, chat, prompt…) |
| `Esc` (Pi) | Leave insert/visual mode; keep focus in Pi |
| `q` (in a sidebar) | Close that surface |
| `Space q` | **Close ALL sidebars at once** (also wipes the tree from the tabline) |

From the Pi prompt, press `Esc` for normal mode, then use the normal
Space shortcuts. Use `Ctrl-w h` to return to the editor. `Space a` closes an open Pi panel regardless of focus.

## Buffers ("tabs")
| Key | Action |
|---|---|
| `Tab` / `Shift-Tab` | Next / previous buffer |
| `Space c` | Close buffer (keeps window) |
| `Space 1-9` | Jump to buffer 1-9 |

## Windows
| Key | Action |
|---|---|
| `Ctrl-Left` | Move divider left (pi panel open: **grow** the panel) |
| `Ctrl-Right` | Move divider right (pi panel open: **shrink** the panel) |
| `Ctrl-Up` / `Ctrl-Down` | Resize height (pi panel open: grow prompt / shrink to its starting height) |

## Files & Search
| Key | Action |
|---|---|
| `Space ff` | Find files |
| `Space fw` | Grep (live) |
| `Space fb` | Find buffer |
| `Space fs` / `Space fS` | Document / workspace symbols |
| `Space fr` | References |
| `Space fd` | Diagnostics |
| `Space f?` | Resume last picker |

## LSP (active in code buffers)
| Key | Action |
|---|---|
| `gd` / `gD` | Definition / declaration |
| `gi` / `gy` | Implementation / type definition |
| `gr` | References |
| `K` | Hover docs · `Ctrl-k` (insert) signature |
| `Space lr` | Rename symbol (across files) |
| `Space la` | Code action |
| `Space lh` | Toggle inlay hints |
| `Space ld` / `Space lq` | Line diagnostics / diagnostics list |
| `Space f` | Format (prettier/ruff/goimports/stylua) |

## Mouse
| Gesture | Action |
|---|---|
| Right-click | Menu: Rename · Refactor… · Code Action · Definition · References · Format · Ask pi |
| Ctrl+click | Go to definition |
| Wheel | Scroll whatever's under the pointer (native, no special keys) |

## Debugging
| Key | Action |
|---|---|
| `Space b` | Toggle breakpoint |
| `Space B` | Conditional breakpoint |
| `Space r` | Start / continue |
| `Space n` / `Space i` / `Space o` | Step over / into / out |
| `Space d` | Toggle debug UI |
| `Space ev` | Eval expression under cursor |

## Pi (AI agent)
| Key | Action |
|---|---|
| `Space a` | Toggle Pi panel (open / close regardless of focus) |
| `Space as` (visual) / `Space af` | Send selection / file |
| `Space ak` (visual) | Inline edit |
| `Space ad` / `Space aD` | Review / reject agent changes |
| `F2` (inside Pi) / `Space aS` / `:PiSessions` | Session menu: new or resume |
| `Space an` / `Space ar` | New / resume session (CLI too) |
| `Space am` / `Space at` | Pick model / cycle thinking |
| `Ctrl-c` (inside Pi, insert or normal) / `Space ax` | Stop the running response; keep draft |

The prompt bar always shows **Ctrl-C stop · F2 sessions**, including while Pi is working.

Prompt box: starts in insert mode; `Esc` enters normal mode in place and `i` resumes typing — `Enter` sends · `Ctrl-j` newline · `@file` (`Ctrl-x Ctrl-o` completes) · `PageUp`/`PageDown` scrolls the chat · `Ctrl-w h` returns to the editor · `q` (normal) closes.
Chat viewer: read-only — scroll/copy freely, `Esc` keeps focus, `q` closes, `i`/`a`/`o`/`Enter` bounces to the prompt.

## Other
| Key | Action |
|---|---|
| `Space R` | Run current file |
| `Space ?` or `:Keymaps` | Search live keybindings |
| `gcc` | Toggle comment (built-in) |
| `j` / `k` | Move by **display line** when wrapped (by line with a count) |
| `Esc` (editor) | Clear search highlight |
