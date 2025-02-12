if [ -d ~/Library/Mobile\ Documents/com~apple~CloudDocs -a ! -L ~/iCloud ]; then
  ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs ~/iCloud
fi
