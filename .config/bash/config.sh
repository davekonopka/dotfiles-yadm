
# Alias definitions.
if [ -f ~/.config/bash/aliases/${HOSTNAME}.sh ]; then
  . ~/.config/bash/aliases/${HOSTNAME}.sh
else
  . ~/.config/bash/aliases/default.sh
fi
