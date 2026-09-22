#!/bin/sh
# neocurse installer — clones (or updates) ~/.config/nvim from GitHub.
# An existing non-neocurse config is backed up to ~/.config/nvim.bak.<ts>.
set -eu

REPO="https://github.com/ChrisMckerracher/neocurse"
DEST="${HOME}/.config/nvim"

if [ -e "$DEST" ]; then
  if [ -d "$DEST/.git" ] && [ "$(git -C "$DEST" remote get-url origin 2>/dev/null)" = "$REPO" ]; then
    git -C "$DEST" pull --ff-only
    echo "neocurse updated."
    exit 0
  fi
  BAK="$DEST.bak.$(date +%Y%m%d-%H%M%S)"
  mv "$DEST" "$BAK"
  echo "existing config backed up to $BAK"
fi

git clone --depth 1 "$REPO" "$DEST"
echo "neocurse installed."
echo "First nvim launch bootstraps lazy.nvim, plugins, and mason tools."
