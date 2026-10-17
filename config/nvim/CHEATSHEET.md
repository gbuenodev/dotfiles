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
| `Space f .`   | Resume last search (same text and spot) |
| `Space g s`   | Git changed files, with diff preview    |
| `Space g c`   | Git commits                             |

Matching is fuzzy: `zshnix` finds `home/zsh.nix`; spaces split terms
(`home zsh`).

Inside Telescope:

| Key                 | Action                                  |
|---------------------|-----------------------------------------|
| `Ctrl-j` / `Ctrl-k` | Move down / up                          |
| `Ctrl-f` / `Ctrl-b` | Scroll the preview down / up            |
| `Enter`             | Open (grep results open at the line)    |
| `Ctrl-d`            | Open beside (like Cmd-D in the terminal)|
| `Ctrl-Shift-D`      | Open below (like Cmd-Shift-D)           |
| `Ctrl-v` / `Ctrl-x` | Same, Telescope defaults                |
| `Ctrl-t`            | Open in a new tab                       |
| `Tab`               | Mark item (multi-select)                |
| `Ctrl-q`            | Marked items to quickfix (all if none)  |
| `Esc`               | Close                                   |

## Quickfix list

A list of file:line positions to walk through one by one, usually filled
from Telescope with `Ctrl-q` (for example, after `Space f g`).

| Command                        | Action                              |
|--------------------------------|-------------------------------------|
| `:copen` / `:cclose`           | Open / close the list               |
| `:cnext` / `:cprev`            | Next / previous position            |
| `Enter` on a line              | Jump to that position               |
| `:cdo s/old/new/g \| update`   | Replace in every position and save  |

## Windows (splits)

All window commands start with `Ctrl-w`: press it, release, then the key.

| Key                 | Action                                  |
|---------------------|-----------------------------------------|
| `Ctrl-w h/j/k/l`    | Go to window left / below / above / right |
| `Ctrl-w w`          | Next window (cycle)                     |
| `Ctrl-w p`          | Back to the previous window             |
| `Ctrl-w v` / `Ctrl-w s` | Split current window beside / below |
| `Ctrl-w q`          | Close window                            |
| `Ctrl-w o`          | Close all other windows                 |
| `Ctrl-w =`          | Make all windows the same size          |
| `Ctrl-w T`          | Move window to a new tab                |
| `:vs file` / `:sp file` | Open file beside / below            |

## Buffers (open files)

Closing a window or tab keeps its file open as a buffer.

| Key / command          | Action                                |
|------------------------|---------------------------------------|
| `Ctrl-^`               | Toggle with the previous file         |
| `[b` / `]b`            | Previous / next buffer                |
| `Space f b`            | Pick a buffer (Telescope)             |
| `:ls`                  | List buffers                          |
| `:vert sb name`        | Open buffer beside (`Tab` completes)  |
| `:sb name`             | Open buffer below                     |
| `:vert sb #`           | Open the previous buffer beside       |
| `:bd`                  | Close (delete) the current buffer     |

## Tabs (tab pages)

Tabs hold window layouts. `Ctrl-t` in Telescope opens a file in a new tab.

| Key / command     | Action                                     |
|-------------------|--------------------------------------------|
| `gt` / `gT`       | Next / previous tab                        |
| `2gt`             | Go to tab 2                                |
| `g<Tab>`          | Back to the last tab                       |
| `:tabs`           | List tabs                                  |
| `:tabnew .`       | New tab with the project explorer          |
| `:tab sb name`    | Open buffer in a new tab                   |
| `:tabclose`       | Close tab (its files stay open as buffers) |
| `:tabonly`        | Close all other tabs                       |

Move a tab into a split: `:tabclose`, then `Space f b`, pick the file and
`Ctrl-d` (beside) or `Ctrl-Shift-D` (below).

## File explorer (netrw)

| Command            | Opens the explorer                         |
|--------------------|--------------------------------------------|
| `:e .`             | Project folder, in the current window      |
| `:Explore`         | Folder of the current file                 |
| `:Texplore`        | In a new tab                               |
| `:Lexplore`        | As a left sidebar (run again to close)     |
| `Space s v` / `Space s h` | In a split beside / below          |

Inside the explorer:

| Key       | Action                                   |
|-----------|------------------------------------------|
| `Enter`   | Open file or folder                      |
| `-`       | Up one folder                            |
| `v` / `o` | Open file beside / below                 |
| `t`       | Open file in a new tab                   |
| `%` / `d` | New file / new folder                    |
| `R` / `D` | Rename / delete                          |

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
