# Keybindings Cheatsheet

**Leader key = Space.** From-scratch config — no distribution defaults.
Mouse works everywhere; right-click opens a refactor menu.

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
| `Esc` (in a sidebar) | Back to editor — sidebar stays open |
| `q` (in a sidebar) | Close that surface |
| `Space q` | **Close ALL sidebars at once** (also wipes the tree from the tabline) |

From the Pi prompt, press `Esc` to return to the editor, then use the normal
Space shortcuts. `Space a` closes an open Pi panel regardless of focus.

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
| `Space an` / `Space ar` | New / resume session (CLI too) |
| `Space am` / `Space at` | Pick model / cycle thinking |
| `Space ax` | Abort agent |

Prompt box: always insert mode (a text field, not a vim buffer) — `Enter` sends · `Ctrl-j` newline · `@file` (`Ctrl-x Ctrl-o` completes) · `PageUp`/`PageDown` scrolls the chat · `Esc` back to editor (re-entering drops you back in insert) · `q` (normal) closes.
Chat viewer: read-only — scroll/copy freely, `Esc` back to editor, `q` closes, `i`/`a`/`o`/`Enter` bounces to the prompt.

## Other
| Key | Action |
|---|---|
| `Space R` | Run current file |
| `Space ?` or `:Keymaps` | This cheatsheet |
| `gcc` | Toggle comment (built-in) |
| `j` / `k` | Move by **display line** when wrapped (by line with a count) |
| `Esc` (editor) | Clear search highlight |
