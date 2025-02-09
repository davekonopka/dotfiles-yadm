#!/bin/bash

SCRIPT_DIR="$HOME/.config/bash/autoload"
HOSTNAME=$(hostname)

if [[ ! -d "$SCRIPT_DIR" ]]; then
    echo "Error: Directory $SCRIPT_DIR does not exist."
    exit 1
fi

for file in "$SCRIPT_DIR"/*.sh; do
    base_name=$(basename "$file" .sh)

    source "$file"

    # Check for hostname-specific variant
    host_specific_file="$SCRIPT_DIR/${base_name}.${HOSTNAME}.sh"
    if [[ -f "$host_specific_file" && -r "$host_specific_file" ]]; then
        source "$host_specific_file"
    fi
done
