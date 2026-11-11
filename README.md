# wf - Workspace Flow

A lightweight tmux workspace manager for creating, entering, listing, labeling, detaching from, and deleting tmux sessions.

## Overview

`wf` treats a tmux session as a workspace.

Instead of remembering whether a session already exists, run:

```sh
wf myproject
```

If the session exists, `wf` enters it. If it does not exist, `wf` creates it with four windows and enters it.

The command describes intent rather than tmux mechanics:

```sh
wf programming
```

means:

```text
Take me to the programming workspace, creating it if necessary.
```

## Features

- Create tmux sessions with four windows
- Create a session from the current directory name with `wf .`
- Create or enter a home workspace with `wf ~`
- Attach to existing sessions from outside tmux
- Switch between sessions from inside tmux
- List active sessions in a compact, alphabetized table
- Show git repository branch and working tree status for child directories
- Rename the current tmux window
- Split the current pane into left and right panes
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
| `wf -label <window_name>` | Rename the current tmux window. |
| `wf -status` | Show branch and working tree status for git repositories in the current directory. |
| `wf -x` | Detach from the current tmux session. |
| `wf -s` | Split the current pane into left and right panes, opening and focusing the new pane in the current pane's directory. Only works inside tmux. |
| `wf -cs` | Close the focused pane and terminate programs running inside it. Refuses to close the last pane in a window. Only works inside tmux. |
| `wf -d <session_name>` | Delete a named session after confirmation. |
| `wf -d` | Delete the current session after confirmation. Only works from inside tmux. |
| `wf --help` | Show help. |

When `wf .` is run from `~/dev/project`, it creates and enters a session named `project`. Directory names are converted to safe session names by replacing unsupported characters with `_`; for example, `spaced directory` becomes `spaced_directory`, and `project.name` becomes `project_name`.

Session names may only contain letters, numbers, `_`, and `-`. Session names must contain at least one letter or number and may not be `.` or `..`.

## Future Improvements

- Add a small shell test suite around a stubbed `tmux` command
- Keep the command set focused on tmux workspace management
