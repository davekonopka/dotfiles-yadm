#!/usr/bin/env bash

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

SCRIPT_DIR="$HOME/.config/bash/autoload"

source $HOME/.config/bash/scripts/utilities.sh

if [[ ! -d "$SCRIPT_DIR" ]]; then
    echo "Error: Directory $SCRIPT_DIR does not exist."
    exit 1
fi

for file in "$SCRIPT_DIR"/*.sh; do
    # Skip yadm alternate/template sources (e.g. *.sh##class.work-gt); only
    # the resolved symlink/rendered target should ever be sourced.
    [[ "$file" == *'##'* ]] && continue

    debug_dotfiles "Sourcing script: $file"
    source "$file"
done
