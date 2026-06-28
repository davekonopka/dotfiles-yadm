#!/usr/bin/env bash

# Set path for tmux install
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# libtmux required by ofirgall/tmux-window-name
if ! python3 -c 'import libtmux' 2>/dev/null; then
  python3 -m pip install --break-system-packages libtmux
fi

SOURCE="${1:?Usage: $0 <source-name>}"

# Build a tmux-safe session name from the source + working directory.
# tmux session names cannot contain '.' or ':' — replace path separators too.
CWD_SLUG=$(echo -n "$PWD" | sed 's#/#_#g; s#[.:]#_#g')
SESSION_NAME="${SOURCE}${CWD_SLUG}"

exec tmux new-session -A -s "$SESSION_NAME" -c "$PWD"
