#!/usr/bin/env bash

# Set path for tmux install
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# libtmux required by ofirgall/tmux-window-name
if ! python3 -c 'import libtmux' 2>/dev/null; then
  python3 -m pip install --break-system-packages libtmux
fi

SOURCE="${1:?Usage: $0 <source-name>}"

# Build a readable, unique session name from git context, not the raw path.
# Prefer <repo>/<branch>; fall back to <repo>, then to <dirname>-<pathhash>.
#
# Use --git-common-dir (not --show-toplevel) so that inside a git worktree we
# resolve the MAIN repo name rather than the worktree's own directory name.
# For a normal repo this points at ".git"; for a worktree it points at the
# primary repo's shared .git. In both cases the repo root is its parent.
REPO=""
COMMON_DIR=$(git rev-parse --git-common-dir 2>/dev/null)
if [ -n "$COMMON_DIR" ]; then
  COMMON_DIR=$(cd "$COMMON_DIR" 2>/dev/null && pwd)
  REPO=$(basename "$(dirname "$COMMON_DIR")")
fi
BRANCH=$(git branch --show-current 2>/dev/null)

if [ -n "$REPO" ] && [ -n "$BRANCH" ]; then
  NAME="${REPO}/${BRANCH}"
elif [ -n "$REPO" ]; then
  NAME="$REPO"
else
  # non-git dir: base name for readability + short path hash for uniqueness
  HASH=$(echo -n "$PWD" | shasum | cut -c1-6)
  NAME="$(basename "$PWD")-${HASH}"
fi

SESSION_NAME="${SOURCE}/${NAME}"

# tmux session names cannot contain '.' or ':' — replace those. '/' and '-' are fine.
SESSION_NAME=$(echo -n "$SESSION_NAME" | sed 's#[.:]#_#g')

exec tmux new-session -A -s "$SESSION_NAME" -c "$PWD"
