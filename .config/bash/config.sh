#!/bin/bash

SCRIPT_DIR="$HOME/.config/bash/autoload"
HOSTNAME=$(hostname)

source $HOME/.config/bash/scripts/utilities.sh

if [[ ! -d "$SCRIPT_DIR" ]]; then
    echo "Error: Directory $SCRIPT_DIR does not exist."
    exit 1
fi

for file in "$SCRIPT_DIR"/*.sh; do
    filename=$(basename "$file" .sh)

    # Check if the filename contains a hostname suffix
    if [[ "$filename" =~ ^([^.]*)\.(.+)$ ]]; then
        base_name="${BASH_REMATCH[1]}"
        file_hostname="${BASH_REMATCH[2]}"

        # Only source if the hostname matches
        if [[ "$file_hostname" == "$HOSTNAME" ]]; then
            debug_dotfiles "Sourcing host-specific script: $file"
            source "$file"
        else
            debug_dotfiles "Skipping script (wrong host): $file"
        fi
    else
        # Source generic scripts
        debug_dotfiles "Sourcing generic script: $file"
        source "$file"
    fi
done
