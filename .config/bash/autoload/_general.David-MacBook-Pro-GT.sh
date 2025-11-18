# AWS Aliases
alias av="aws-vault"
alias aws-me="aws-vault exec dave.konopka --duration=8h"

export GEM_HOME="$HOME/.gem"

export PATH="$HOME/.cask/bin:$PATH"
export PATH="$HOME/.gem/bin:$PATH"

export RUBY_CONFIGURE_OPTS="--disable-install-doc --with-openssl-dir=$(brew --prefix openssl@3)"

export GPG_TTY=$(tty)

export OPENAI_API_KEY=`op item get 'OpenAI CLI Key' --field 'password' --vault 'Employee' --reveal`

export TENV_GITHUB_TOKEN=`op item get 'TENV Github Token' --field 'password' --vault 'Platform Team' --reveal`

# If you want auto install versions
export TENV_AUTO_INSTALL=true
export TG_TF_PATH=terraform

# This gets rid of the Terraform version prefixing
export TG_TF_FORWARD_STDOUT=true
export TERRAGRUNT_LOG_DISABLE=true

export PATH=$(tenv update-path)
