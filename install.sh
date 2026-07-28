#!/usr/bin/env zsh

set -e

SCRIPT_DIR="${0:A:h}"
SOURCE="$SCRIPT_DIR/bin/wf"
INSTALL_DIR="$HOME/.local/bin"
DESTINATION="$INSTALL_DIR/wf"
COMPLETION_SOURCE="$SCRIPT_DIR/completions/_wf"
COMPLETION_DIR="$HOME/.local/share/zsh/site-functions"
COMPLETION_DESTINATION="$COMPLETION_DIR/_wf"
ZSHRC="$HOME/.zshrc"
ZSHRC_MARKER_START="# >>> wf setup >>>"
ZSHRC_MARKER_END="# <<< wf setup <<<"

zshrc_has_wf_setup() {
  [[ -f "$ZSHRC" ]] && grep -qF "$ZSHRC_MARKER_START" "$ZSHRC"
}

zshrc_needs_wf_setup() {
  [[ ":$PATH:" != *":$INSTALL_DIR:"* ]] || [[ ${fpath[(Ie)$COMPLETION_DIR]} -eq 0 ]]
}

install_zshrc_setup() {
  if zshrc_has_wf_setup || ! zshrc_needs_wf_setup; then
    return
  fi

  {
    echo
    echo "$ZSHRC_MARKER_START"
    echo 'if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then'
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    echo 'fi'
    echo
    echo 'if [[ ${fpath[(Ie)$HOME/.local/share/zsh/site-functions]} -eq 0 ]]; then'
    echo '  fpath=("$HOME/.local/share/zsh/site-functions" $fpath)'
    echo 'fi'
    echo
    echo 'autoload -Uz compinit'
    echo 'compinit'
    echo "$ZSHRC_MARKER_END"
  } >> "$ZSHRC"

  echo
  echo "Updated shell configuration:"
  echo "  $ZSHRC"
}

if [[ ! -f "$SOURCE" ]]; then
  echo "install: could not find '$SOURCE'" >&2
  exit 1
fi

if [[ ! -f "$COMPLETION_SOURCE" ]]; then
  echo "install: could not find '$COMPLETION_SOURCE'" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"
mkdir -p "$COMPLETION_DIR"

cp "$SOURCE" "$DESTINATION"
chmod +x "$DESTINATION"

cp "$COMPLETION_SOURCE" "$COMPLETION_DESTINATION"

install_zshrc_setup

echo "Installed wf to:"
echo "  $DESTINATION"
echo
echo "Installed wf completion to:"
echo "  $COMPLETION_DESTINATION"

echo
echo "Restart your shell, then run 'wf --help' to get started."
