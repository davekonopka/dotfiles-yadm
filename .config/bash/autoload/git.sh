function git_current_branch() {
    ref="$(git symbolic-ref --quiet HEAD 2> /dev/null)"
    echo ${ref#refs/heads/}
}

function git_main_branch() {
    git rev-parse --abbrev-ref origin/HEAD | cut -d/ -f2
}

# Conventional Commit helpers
function cc-labels() {
  for label in fix feature build chore ci docs style refactor perf test; do
    echo "$label"
  done
  echo "https://kapeli.com/cheat_sheets/Conventional_Commits.docset/Contents/Resources/Documents/index"
}

# Aliases
alias gb='git branch'
alias gc='git commit -v'
alias gcm='git checkout $(git_main_branch)'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gst='git status'
alias ggpull='git pull origin $(git_current_branch)'
alias ggpush='git push origin $(git_current_branch)'
alias gbstale='git branch --merged $(git_main_branch) | grep -v $(git_main_branch) | sed "'"s/[ ]*//"'"'
alias grstale="git remote prune origin --dry-run"
