export ASDF_DATA_DIR="$HOME/.asdf"

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
