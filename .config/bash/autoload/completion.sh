[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
[[ -r ".config/bash/scripts/complete_alias" ]] && . ".config/bash/scripts/complete_alias"

complete -F _complete_alias "${!BASH_ALIASES[@]}"
