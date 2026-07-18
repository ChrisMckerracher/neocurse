# Keybindings Cheatsheet

**Leader key = Space.** From-scratch config — no distribution defaults.
Mouse works everywhere; right-click opens a refactor menu.

## Buffers ("tabs")
| Key | Action |
|---|---|
| `Tab` / `Shift-Tab` | Next / previous buffer |
| `Space c` | Close buffer (keeps window) |
| `Space 1-9` | Jump to buffer 1-9 |

## Windows
| Key | Action |
|---|---|
| `Ctrl-h/j/k/l` | Move between windows |
| `Ctrl-arrows` | Resize windows |

## Files & Search
| Key | Action |
|---|---|
| `Space e` | File explorer (neo-tree; `l` open, `h` collapse) |
| `Space ff` | Find files |
| `Space fw` | Grep (live) |
| `Space fb` | Find buffer |
| `Space fs` / `Space fS` | Document / workspace symbols |
| `Space fr` | References |
| `Space fd` | Diagnostics |
| `Space f?` | Resume last picker |
| `Space v` | Structure view (aerial) |

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
| Wheel over pi chat | Scroll chat |

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
| `Space a` | Toggle pi panel |
| `Space as` (visual) / `Space af` | Send selection / file |
| `Space ak` (visual) | Inline edit |
| `Space ad` / `Space aD` | Review / reject agent changes |
| `Space an` / `Space ar` | New / resume session (CLI too) |
| `Space am` / `Space at` | Pick model / cycle thinking |
| `Space ax` | Abort agent |
| `Space aj` / `Space ak` | Scroll chat (from any window) |
| `Space ag` / `Space aG` | Chat top / bottom |

Input box: `Enter` sends · `Ctrl-j` newline · `@file` (`Ctrl-x Ctrl-o` completes) · `Ctrl-d/u` scroll · `Esc` closes.

## Other
| Key | Action |
|---|---|
| `Space R` | Run current file |
| `Space ?` | This cheatsheet |
| `gcc` | Toggle comment (built-in) |
