# AWS Aliases
alias av="aws-vault"
alias aws-me="aws-vault exec dave.konopka --duration=8h"

export GEM_HOME="$HOME/.gem"

export PATH="$HOME/.cask/bin:$PATH"
export PATH="$HOME/.gem/bin:$PATH"

export RUBY_CONFIGURE_OPTS="--disable-install-doc --with-openssl-dir=$(brew --prefix openssl@3)"

export GPG_TTY=$(tty)

export TERRAGRUNT_LOG_DISABLE=true
