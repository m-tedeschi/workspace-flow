# wf — Workspace Flow

A lightweight tmux workspace manager.

`wf` provides a small, intention-based interface for creating, entering, listing, labeling, and deleting tmux sessions.

Instead of remembering whether a session already exists, run:

```sh
wf myproject
```

`wf` will create the session if necessary, or enter it if it already exists.

## Features

- Create tmux sessions with four windows
- Attach to existing sessions from outside tmux
- Switch between sessions from inside tmux
- List active sessions
- Rename the current tmux window
- Delete sessions with confirmation
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

If needed, the installer also adds a managed setup block to `~/.zshrc` so `wf` is on your `PATH` and Zsh can find the completion file.

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

### List sessions

Running `wf` without arguments lists active tmux sessions:

```sh
wf
```

### Create or enter a workspace

```sh
wf <session_name>
```

Example:

```sh
wf leetcode
```

When the session does not exist, `wf` creates it with four windows and selects the first window.

When the session already exists:

- Outside tmux, `wf` attaches to it.
- Inside tmux, `wf` switches the current client to it.

### Rename the current window

```sh
wf -label <window_name>
```

Example:

```sh
wf -label Codex
```

Multiword labels are also supported:

```sh
wf -label Codex Work
```

This command must be run from inside a tmux session.

### Delete a session

```sh
wf -d <session_name>
```

Example:

```sh
wf -d leetcode
```

`wf` asks for confirmation before deleting the session.

Session names can be tab-completed for both `wf <session_name>` and `wf -d <session_name>`.

### Show help

```sh
wf --help
```

The shorter form is also supported:

```sh
wf -h
```

## Command Reference

```text
wf
    List active tmux sessions.

wf <session_name>
    Create the session if it does not exist.
    Otherwise, attach or switch to it.

wf -label <window_name>
    Rename the current tmux window.

wf -d <session_name>
    Prompt for confirmation and delete the session.

wf --help
    Display the help message.
```

## Repository Structure

```text
workspace-flow/
├── bin/
│   └── wf
├── completions/
│   └── _wf
├── README.md
└── install.sh
```

## Philosophy

`wf` treats a tmux session as a workspace.

The command describes intent rather than tmux mechanics:

```sh
wf leetcode
```

means:

> Take me to the `leetcode` workspace, creating it if necessary.

The project intentionally keeps the common workflow short and predictable.
