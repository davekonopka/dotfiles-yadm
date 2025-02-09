# Powerline fonts

if test "$(uname)" = "Darwin" ; then
  # MacOS
  font_dir="$HOME/Library/Fonts"
else
  # Linux
  font_dir="$HOME/.local/share/fonts"
fi

if ! ls $font_dir/*Powerline* 1> /dev/null 2>&1; then
    echo "Installing Powerline fonts..."
    git clone https://github.com/powerline/fonts.git --depth=1 /tmp/powerline-fonts
    cd /tmp/powerline-fonts
    ./install.sh
fi
