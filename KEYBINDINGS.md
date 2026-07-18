# Keybindings Cheatsheet

**Leader key = Space** — press Space then the key.

## File Explorer
| Key | Action |
|---|---|
| `Space e` | Toggle file explorer sidebar |

## Buffer Navigation ("tabs")
| Key | Action |
|---|---|
| `Tab` | Next buffer |
| `Shift-Tab` | Previous buffer |
| `Space c` | Close buffer |
| `Space 1-9` | Jump to buffer 1-9 |

## Debugging
| Key | Action |
|---|---|
| `Space b` | Toggle breakpoint |
| `F5` / `Space r` | Start / continue debugging |
| `F10` / `Space n` | Step over |
| `F11` / `Space i` | Step into |
| `Shift-F12` / `Space o` | Step out |
| `Space d` | Toggle debug UI (stack, variables, breakpoints) |

## Running
| Key | Action |
|---|---|
| `Space R` | Run current file (no debugger) |

## Formatting
| Key | Action |
|---|---|
| `Space f` | Format current file |

## Navigation
| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |

## Other
| Key | Action |
|---|---|
| `Space ?` | Open this cheatsheet |

## Pi (AI agent)
| Key | Action |
|---|---|
| `Space a` | Toggle pi sidebar (chat panel, right side) |
| `Space as` (visual) | Send selection to pi — type instruction after |
| `Space af` | Send current file to pi |
| `Space ak` (visual) | Inline edit selection with instruction |
| `Space ad` | Review agent changes (diff view per file) |
| `Space aD` | Reject agent changes (revert file) |
| `Space an` | New pi session |
| `Space ar` | Resume session (includes CLI `pi` sessions) |
| `Space am` | Pick model for current session |
| `Space at` | Cycle thinking level |
| `Space ax` | Abort running agent |
| `Space aj` / `Space ak` | Scroll chat down / up (works from any window) |
| `Space ag` / `Space aG` | Chat to top / bottom |
| `:Pi` / `:PiNew` / `:PiResume` / `:PiReview` / `:PiAbort` | Same as commands |

Inside the sidebar input: `Enter` sends, `Ctrl-j` newline, `@path` attaches a file (type `@` then `Ctrl-x Ctrl-o` for path completion), `Ctrl-d`/`Ctrl-u` scrolls the chat, `Esc` closes the panel. The chat pane is a read-only panel — it can't be edited or focused; scroll it from the input or with the mouse.
