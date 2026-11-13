# wf - Workspace Flow

A lightweight tmux workspace manager for creating, entering, listing, labeling, detaching from, and deleting tmux sessions.

## Overview

`wf` treats a tmux session as a workspace.

Instead of remembering whether a session already exists, run:

```sh
wf myproject
```

If the session exists, `wf` enters it. If it does not exist, `wf` creates it with one window and enters it.

The command describes intent rather than tmux mechanics:

```sh
wf programming
```

means:

```text
Take me to the programming workspace, creating it if necessary.
```

## Features

- Create tmux sessions with one window
- Create a session from the current directory name with `wf .`
- Create or enter a home workspace with `wf ~`
- Create or enter a workspace at a path with `wf -p`, with directory tab completion
- Attach to existing sessions from outside tmux
- Switch between sessions from inside tmux
- List active sessions in a compact, alphabetized table
- Show git repository branch and working tree status for child directories
- Rename the current tmux window
- Create windows in the current directory or the workspace's starting directory
- Close the current window while protecting the last window in a session
- Split the current pane into left/right or top/bottom panes
- Close the focused pane while protecting the last pane in a window
- Detach from the current tmux session
- Delete named sessions or the current session with confirmation
- Tab-complete existing session names in Zsh

## Requirements

- tmux
- Zsh

## Installation

Clone the repository:

```sh
git clone https://www.github.com/m-tedeschi/workspace-flow.git
cd workspace-flow
```

Run the installer:

```sh
./install.sh
```

The installer copies `bin/wf` to:

```text
~/.local/bin/wf
```

It also installs the Zsh completion file to:

```text
~/.local/share/zsh/site-functions/_wf
```

If needed, the installer adds a managed setup block to `~/.zshrc` so `wf` is on your `PATH` and Zsh can find the completion file.

It also adds `unsetopt PROMPT_SP` if it is not already present, preventing stray `%` markers and blank lines after tmux pane resizing. This disables Zsh's preservation of output without a trailing newline; the next prompt may overwrite that partial line.

Restart your shell, or reload your shell configuration:

```sh
source ~/.zshrc
```

Verify the installation:

```sh
which wf
```

Expected output:

```text
/Users/yourname/.local/bin/wf
```

## Usage

| Command | Description |
| --- | --- |
| `wf` | List active sessions. |
| `wf <session_name>` | Create or enter a named workspace. |
| `wf .` | Create a workspace from the current directory. |
| `wf ~` | Create or enter your home workspace. |
| `wf -p <directory>` | Create or enter a workspace named after the directory, without changing the invoking shell's directory. Tab-completes directories. |
| `wf -l <window_name>` / `wf -label <window_name>` | Rename the current tmux window. |
| `wf -nl` / `wf -nolabel` | Remove the custom window label and resume tmux's automatic naming. Requires tmux. |
| `wf -git` | Show branch and working tree status for git repositories in the current directory. |
| `wf -x` | Detach from the current tmux session. |
| `wf -n [n]` | Create n windows in the invoking shell's current directory and focus the last new window. Defaults to 1; accepts whole numbers from 0 to 5. Requires tmux; 0 creates no windows. |
| `wf -N [n]` | Create n windows in the workspace's starting directory and focus the last new window. Defaults to 1; accepts whole numbers from 0 to 5. Requires tmux; 0 creates no windows. |
| `wf -cw` | Close the current window and all its panes, terminating their programs. Refuses to close the last window in a session. Only works inside tmux. |
| `wf -s` | Split the current pane into left and right panes, opening and focusing the new pane in the current pane's directory. Only works inside tmux. |
| `wf -S` | Split the current pane into top and bottom panes, opening and focusing the new pane in the current pane's directory. Only works inside tmux. |
| `wf -r <x> <y>` | Resize the invoking pane: integers from -100 to 100 adjust width/height in cells; percentages from 1% to 100% set absolute sizes relative to the window. Plain 0 leaves a dimension unchanged. Requires tmux and at least two panes for a size change. |
| `wf -rq` | Reset exactly four panes to an equal 2×2 grid, numbered 1 2 / 3 4. Preserves panes, programs, and focus. Requires tmux. |
| `wf -rt` | Reset exactly three panes to a half-width left pane (1) and equal-height right panes (2 above 3). Preserves panes, programs, and focus. Requires tmux. |
| `wf -q` / `wf -quad` | Create a 2×2 grid: top left 1, top right 2, bottom left 3, bottom right 4. Requires tmux and exactly one pane in the current window. New panes use the original pane's directory; focuses pane 1 and sets pane numbering to start at 1 for this window. |
| `wf -t` / `wf -tri` | Create a full-height left pane (1), top right pane (2), and bottom right pane (3). Requires tmux and exactly one pane in the current window. New panes use the original pane's directory; focuses pane 1 and sets pane numbering to start at 1 for this window. |
| `wf -cs` | Close the focused pane and terminate programs running inside it. Refuses to close the last pane in a window. Only works inside tmux. |
| `wf -cas` | Close all other panes in the current window, terminating their programs. Keeps the pane where the command is run. Only works inside tmux; does nothing if it is already the only pane. |
| `wf -caw` | Close all other windows in the current workspace, terminating their programs. Keeps the invoking window and all its panes. Requires tmux; does nothing if it is already the only window. |
| `wf -d <session_name>` | Delete a named session after confirmation. |
| `wf -d` | Delete the current session after confirmation. Only works from inside tmux. |
| `wf --help` | Show help. |

When `wf .` is run from `~/dev/project`, it creates and enters a session named `project`. Directory names are converted to safe session names by replacing unsupported characters with `_`; for example, `spaced directory` becomes `spaced_directory`, and `project.name` becomes `project_name`.

Session names may only contain letters, numbers, `_`, and `-`. Session names must contain at least one letter or number and may not be `.` or `..`.

`wf -p` accepts relative paths, absolute paths, `~`, and quoted paths with spaces, such as `wf -p "~/dev/My Project"`. Paths are resolved to their physical directory before deriving the session name. New workspaces start with one window and remember that directory for `-N`. Existing workspaces are entered only when their saved directory (or tmux's session starting directory for older sessions) matches; a same-named workspace at another path produces an error.

New workspaces remember the directory where they were created (`wf ~` uses the home directory). `wf -N` returns to that directory even after you change directories in a pane. For existing sessions without a saved workspace directory, it uses tmux's session starting directory. If that directory no longer exists, the command reports an error.

Resize examples: `wf -r 10 0` grows the pane by 10 columns; `wf -r -5 3` shrinks width by 5 columns and grows height by 3 rows; `wf -r 60% 50%` sets width and height to 60% and 50% of the window. Values may be mixed (`wf -r 60% -3`), and positive values accept an optional `+`. Negative percentages, 0%, decimals, and out-of-range values are rejected. `wf -r 0 0` does nothing. tmux rounds percentages to cells and limits resizing to what the layout permits.

## Future Improvements

- Add a small shell test suite around a stubbed `tmux` command
- Keep the command set focused on tmux workspace management
