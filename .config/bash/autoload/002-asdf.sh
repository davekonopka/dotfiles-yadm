export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

function asdf-install() {
  # Check if an argument was provided
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Error: Please provide a plugin name and version number"
    return 1
  fi

  local version="$2"
  local plugin="$1"
  asdf install $plugin $(asdf list all $plugin | grep "^$version[^-]*$" | tail -1)
}

function asdf-update-plugins() {
  asdf plugin update --all
}

# Plugins to skip (managed by other tools like tenv)
ASDF_SKIP_PLUGINS=("terraform" "terragrunt")

asdf-check-versions() {
    # Colors for output
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local NC='\033[0m' # No Color
    local BOLD='\033[1m'

    # Check if asdf is installed
    if ! command -v asdf &> /dev/null; then
        echo -e "${RED}Error: asdf is not installed or not in PATH${NC}"
        return 1
    fi

    echo -e "${BOLD}Checking asdf-managed software versions...${NC}\n"
    printf "%-20s %-15s %-15s %s\n" "Plugin" "Current" "Latest" "Status"
    printf "%-20s %-15s %-15s %s\n" "------" "-------" "------" "------"

    # Get list of installed plugins
    local plugins=$(asdf plugin list 2>/dev/null)

    if [ -z "$plugins" ]; then
        echo -e "${YELLOW}No asdf plugins installed${NC}"
        return 0
    fi

    # Process each plugin
    while IFS= read -r plugin; do
        # Skip plugins managed by other tools
        if [[ " ${ASDF_SKIP_PLUGINS[@]} " =~ " ${plugin} " ]]; then
            continue
        fi

        # Get current version (marked with *)
        local current=$(asdf list "$plugin" 2>/dev/null | grep '\*' | sed 's/[* ]//g' | head -1)

        # If no version is marked with *, get the first installed version
        if [ -z "$current" ]; then
            current=$(asdf list "$plugin" 2>/dev/null | sed 's/[* ]//g' | grep -v '^$' | head -1)
            if [ -z "$current" ]; then
                current="none"
            fi
        fi

        # Get latest available version
        local latest=$(asdf latest "$plugin" 2>/dev/null)

        # Handle case where latest cannot be determined
        if [ -z "$latest" ] || [ "$latest" = "unknown" ]; then
            latest="unknown"
            status="${YELLOW}?${NC}"
        elif [ "$current" = "none" ]; then
            status="${RED}not installed${NC}"
        elif [ "$current" = "$latest" ]; then
            status="${GREEN}✓${NC}"
        else
            status="${YELLOW}↑ update available${NC}"
        fi

        printf "%-20s %-15s %-15s %b\n" "$plugin" "$current" "$latest" "$status"

    done <<< "$plugins"

    echo ""
    echo -e "${BLUE}Legend:${NC}"
    echo -e "  ${GREEN}✓${NC}  = Up to date"
    echo -e "  ${YELLOW}↑${NC}  = Update available"
    echo -e "  ${YELLOW}?${NC}  = Cannot determine latest version"
    echo -e "  ${RED}not installed${NC} = No version currently installed"
    echo ""
    echo -e "${BLUE}To update a plugin:${NC} asdf install <plugin> <version>"
    echo -e "${BLUE}To set global version:${NC} asdf set -u <plugin> <version>"
}

asdf-update-all() {
    # Colors for output
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local NC='\033[0m' # No Color
    local BOLD='\033[1m'

    # Parse arguments
    local dry_run=false
    if [ "$1" = "--dry-run" ] || [ "$1" = "-n" ]; then
        dry_run=true
    fi

    # Check if asdf is installed
    if ! command -v asdf &> /dev/null; then
        echo -e "${RED}Error: asdf is not installed or not in PATH${NC}"
        return 1
    fi

    if [ "$dry_run" = true ]; then
        echo -e "${BOLD}DRY RUN: Showing what would be updated...${NC}\n"
    else
        echo -e "${BOLD}Updating all asdf-managed software to latest versions...${NC}\n"
    fi

    # Get list of installed plugins
    local plugins=$(asdf plugin list 2>/dev/null)

    if [ -z "$plugins" ]; then
        echo -e "${YELLOW}No asdf plugins installed${NC}"
        return 0
    fi

    local updated_count=0
    local skipped_count=0
    local failed_count=0

    # Process each plugin
    while IFS= read -r plugin; do
        # Skip plugins managed by other tools
        if [[ " ${ASDF_SKIP_PLUGINS[@]} " =~ " ${plugin} " ]]; then
            echo -e "${BLUE}Skipping ${plugin} (managed by other tools)${NC}"
            ((skipped_count++))
            continue
        fi

        # Get current version
        local current=$(asdf list "$plugin" 2>/dev/null | grep '\*' | sed 's/[* ]//g' | head -1)

        # Get latest available version
        local latest=$(asdf latest "$plugin" 2>/dev/null)

        # Handle case where latest cannot be determined
        if [ -z "$latest" ] || [ "$latest" = "unknown" ]; then
            echo -e "${YELLOW}⚠ Skipping ${plugin}: cannot determine latest version${NC}"
            ((skipped_count++))
            continue
        fi

        # Check if already on latest
        if [ "$current" = "$latest" ]; then
            echo -e "${GREEN}✓ ${plugin} already on latest version (${latest})${NC}"
            continue
        fi

        # Install and set as global
        if [ "$dry_run" = true ]; then
            echo -e "${BLUE}→ Would install ${plugin} ${latest} (current: ${current:-none})${NC}"
            ((updated_count++))
        else
            echo -e "${BLUE}→ Installing ${plugin} ${latest}...${NC}"
            if asdf install "$plugin" "$latest" 2>/dev/null; then
                if asdf set -u "$plugin" "$latest" 2>/dev/null; then
                    echo -e "${GREEN}✓ ${plugin} updated: ${current:-none} → ${latest}${NC}"
                    ((updated_count++))
                else
                    echo -e "${RED}✗ ${plugin}: installed but failed to set as global${NC}"
                    ((failed_count++))
                fi
            else
                echo -e "${RED}✗ ${plugin}: installation failed${NC}"
                ((failed_count++))
            fi
        fi

    done <<< "$plugins"

    echo ""
    echo -e "${BOLD}Summary:${NC}"
    if [ "$dry_run" = true ]; then
        echo -e "  ${BLUE}Would update: ${updated_count}${NC}"
    else
        echo -e "  ${GREEN}Updated: ${updated_count}${NC}"
    fi
    echo -e "  ${YELLOW}Skipped: ${skipped_count}${NC}"
    if [ $failed_count -gt 0 ]; then
        echo -e "  ${RED}Failed: ${failed_count}${NC}"
    fi

    if [ "$dry_run" = true ]; then
        echo ""
        echo -e "${BLUE}Run without --dry-run to perform the updates${NC}"
    fi
}
