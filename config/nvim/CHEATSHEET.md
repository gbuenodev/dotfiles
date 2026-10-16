# Neovim cheatsheet

`<leader>` is Space. Press Space and wait: which-key lists what comes next.
Close this window with `:q`. Edit it at `config/nvim/CHEATSHEET.md`.

## Modes

| Key          | Action                                   |
|--------------|------------------------------------------|
| `i` / `a`    | Insert before / after the cursor         |
| `I` / `A`    | Insert at start / end of the line        |
| `o` / `O`    | New line below / above                   |
| `v` / `V`    | Visual (characters) / visual (lines)     |
| `Ctrl-v`     | Visual block (columns)                   |
| `jj` / `Esc` | Back to normal mode                      |

## Moving

| Key            | Action                                 |
|----------------|----------------------------------------|
| `h j k l`      | Left, down, up, right                  |
| `w` / `b` / `e`| Next word / previous word / word end   |
| `0` / `^` / `$`| Line start / first char / line end     |
| `gg` / `G`     | First / last line                      |
| `5j` / `12G`   | 5 lines down / go to line 12           |
| `{` / `}`      | Previous / next paragraph              |
| `%`            | Matching bracket                       |
| `Ctrl-d` / `Ctrl-u` | Half page down / up               |
| `f x` / `t x`  | Jump to / before next `x` on the line  |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward               |

## Editing

| Key           | Action                                  |
|---------------|-----------------------------------------|
| `x`           | Delete character                        |
| `dd` / `yy`   | Delete (cut) / copy line                |
| `p` / `P`     | Paste after / before                    |
| `u` / `Ctrl-r`| Undo / redo                             |
| `.`           | Repeat last change                      |
| `ciw`         | Change word (also `ci"`, `ci(`, `cit`)  |
| `diw` / `yiw` | Delete / copy word                      |
| `>>` / `<<`   | Indent / unindent line                  |
| `gcc` / `gc`  | Toggle comment: line / selection        |
| `J`           | Join line below                         |

Operators combine with motions: `d3j`, `y}`, `c$`, `gcip`.

## Search and replace

| Key             | Action                                  |
|-----------------|-----------------------------------------|
| `/text` / `?text` | Search forward / backward             |
| `n` / `N`       | Next / previous match                   |
| `*`             | Search word under cursor                |
| `Esc`           | Clear highlight                         |
| `:%s/old/new/g` | Replace in the whole file               |

## Find (Telescope)

| Key           | Action                                  |
|---------------|-----------------------------------------|
| `Ctrl-p`      | Git files (all files outside a repo)    |
| `Space f f`   | All files                               |
| `Space f g`   | Grep text in the project                |
| `Space f w`   | Grep word under cursor                  |
| `Space f b`   | Open buffers                            |
| `Space f r`   | Recent files                            |
| `Space f d`   | Dotfiles repo                           |
| `Space f h`   | Help pages                              |
| `Space f k`   | All keymaps                             |
| `Space /`     | Fuzzy search in current file            |

Inside Telescope: `Ctrl-j` / `Ctrl-k` move, `Enter` open,
`Ctrl-v` / `Ctrl-x` open in vertical / horizontal split, `Esc` close.

## Windows and buffers

| Key             | Action                                |
|-----------------|---------------------------------------|
| `Space s v` / `Space s h` | Split vertical / horizontal (explorer) |
| `:vs file` / `:sp file` | Split and open file             |
| `Ctrl-w h/j/k/l`| Move between splits                   |
| `Ctrl-w q`      | Close split                           |
| `:bn` / `:bp`   | Next / previous buffer                |

## Files

| Command   | Action                                  |
|-----------|-----------------------------------------|
| `:w`      | Save                                    |
| `:q` / `:q!` | Quit / quit without saving           |
| `:wq` or `ZZ` | Save and quit                       |
| `:e path` | Open file                               |
| `:e!`     | Reload file, discarding changes         |

Files changed on disk (for example, by an AI agent) reload automatically
when nvim regains focus.

## Plugins

| Command       | Action                                  |
|---------------|-----------------------------------------|
| `:Lazy`       | Plugin manager                          |
| `:Lazy sync`  | Install, update and clean plugins       |
| `:checkhealth`| Diagnose problems                       |

Plugin versions are pinned in `lazy-lock.json` (commit it after updates).
