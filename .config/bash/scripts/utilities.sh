function debug_dotfiles() {
  [[ -n "$DEBUG_DOTFILES" ]] && echo "$@"
}
