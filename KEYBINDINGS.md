# Keybindings Cheatsheet

**Leader key = Space.** From-scratch config — no distribution defaults.
Mouse works everywhere; right-click opens a refactor menu.

Use `Space ?` or `:Keymaps` for shortcuts relevant to the current window.
The title identifies Editor, Pi, File tree, Debugger, or Structure. Common
navigation stays visible everywhere; editor/LSP actions appear in code buffers,
Pi actions in Pi, and local plugin controls in their own windows. LSP help appears
when a server is attached. Duplicate LSP aliases collapse to the preferred key,
and buffer-local overrides take precedence. Type to search; `Esc` closes the
reference without executing anything.

`Space a` (Pi) and `Space e` (tree) are immediate toggles: longer commands do not
share those prefixes. Pi actions use `Space p…`; format uses `Space lf`.

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
| `Ctrl-h/j/k/l` (normal mode) | Move between editor, tree, chat, and prompt |
| `Esc` (Pi) | Leave insert/visual mode; keep focus in Pi |
| `Esc` (tree, structure) | Return to previous window |
| `q` (Pi, tree, structure; normal mode) | Close that surface |
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
| `Space fd` | Diagnostics |
| `Space f?` | Resume last picker |

## LSP (active in code buffers)
| Key | Action |
|---|---|
| `gd` / `gD` | Definition / declaration |
| `gi` / `gy` | Implementation / type definition |
| `grr` | References |
| `K` | Hover docs · `Ctrl-k` (insert) signature |
| `Space lr` | Rename symbol (across files) |
| `Space la` | Code action |
| `Space lh` | Toggle inlay hints |
| `Space ld` / `Space lq` | Line diagnostics / diagnostics list |
| `Space lf` | Format (prettier/ruff/goimports/stylua) |

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
| `Space E` | Eval expression under cursor |

## Pi (AI agent)
| Key | Action |
|---|---|
| `Space a` | Toggle Pi panel (open / close regardless of focus) |
| `Space ps` (visual) / `Space pf` | Send selection / file |
| `Space pk` (visual) | Inline edit |
| `Space pd` / `Space pD` | Review / reject agent changes |
| `F2` (inside Pi) / `Space pS` / `:PiSessions` | Session menu: new or resume |
| `Space pn` / `Space pr` | New / resume session (CLI too) |
| `Space pm` / `Space pt` | Pick model / cycle thinking |
| `Ctrl-c` (inside Pi, insert or normal) / `Space px` | Stop the running response; keep draft |

The prompt bar always shows **Ctrl-C stop · F2 sessions**, including while Pi is working.

Prompt box: starts in insert mode; `Esc` enters normal mode in place and `i` resumes typing — `Enter` sends · `Ctrl-j` newline · `@file` (`Ctrl-x Ctrl-o` completes) · `PageUp`/`PageDown` scrolls the chat · `Ctrl-w h` returns to the editor · `q` (normal) closes.
Chat viewer: read-only — scroll/copy freely, `Esc` keeps focus, `q` closes, `i`/`a`/`o`/`Enter` bounces to the prompt.

## Other
| Key | Action |
|---|---|
| `Space ?` or `:Keymaps` | Search live keybindings |
| `gcc` | Toggle comment (built-in) |
| `j` / `k` | Move by **display line** when wrapped (by line with a count) |
| `Esc` (editor) | Clear search highlight |

## Shortcut scope

Keep file-tree navigation, Pi, normal Vim file/buffer editing, and installed
plugin controls (including debugger, LSP, search, formatting, and completion).
Native window rotation, exchange, rearrangement, detaching to a tab, and
maximization/equalization shortcuts are disabled. Pi divider sizing and normal
window navigation remain. The ad-hoc `Space R` file runner has been removed;
use the debugger's `Space r` to run/debug.

The picker omits internal/no-op mappings and unrelated default aliases. Standard
Vim commands such as `:w`, `:q`, motions, yank/paste, undo, macros, and searches
remain available; the picker is a shortcut reference, not a catalogue of Vim.
