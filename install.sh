#!/usr/bin/env zsh

set -e

SCRIPT_DIR="${0:A:h}"
SOURCE="$SCRIPT_DIR/bin/wf"
INSTALL_DIR="$HOME/.local/bin"
DESTINATION="$INSTALL_DIR/wf"

if [[ ! -f "$SOURCE" ]]; then
  echo "install: could not find '$SOURCE'" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"

cp "$SOURCE" "$DESTINATION"
chmod +x "$DESTINATION"

echo "Installed wf to:"
echo "  $DESTINATION"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo
  echo "Add the following line to your shell configuration:"
  echo
  echo '  export PATH="$HOME/.local/bin:$PATH"'
  echo
  echo "Then reload your shell configuration."
fi

echo
echo "Run 'wf --help' to get started."
