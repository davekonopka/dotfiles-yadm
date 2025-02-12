bind Space:magic-space

export HISTSIZE=10000
export HISTTIMEFORMAT='%h %d %H:%M:%S '
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND="${PROMPT_COMMAND} history -a;"
export EDITOR="nvim"

export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias ll="ls -la"
alias lt="ls -latr"
alias hg='history | grep '
alias vim="nvim"
alias code="code-insiders"
