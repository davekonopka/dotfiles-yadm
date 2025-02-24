function brew-update() {
  brew update
  brew upgrade
  brew cleanup
}

function brew-bundle() {
  brew bundle --file=~/Brewfile.$(hostname -s)
}

function brew-bundle-dump() {
  brew bundle dump --file=~/Brewfile.$(hostname -s) --force
}

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/usr/local/opt/grep/libexec/gnubin:/usr/local/sbin:$PATH"
