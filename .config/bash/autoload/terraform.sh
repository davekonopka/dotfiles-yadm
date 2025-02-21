# Generate a terraform plan summary
function tf-plan-summary() {
  terraform plan -out tfplan > /dev/null 2>&1 && terraform show -json tfplan |
  jq -r --color-output '
  .resource_changes[] |
  .change.actions as $actions |
  .address as $addr |
  if $actions[0] == "create" then "\u001b[32m+ \($addr)\u001b[0m"  # Green for create
  elif $actions[0] == "delete" then "\u001b[31m- \($addr)\u001b[0m"  # Red for delete
  elif $actions[0] == "update" then "\u001b[33m~ \($addr)\u001b[0m"  # Yellow for update
  elif $actions[0] == "no-op" then "\u001b[37m• \($addr)\u001b[0m"  # Silver for no-op
  else "\($addr) (\($actions[0]))"
  end' && rm tfplan
}

alias tf="terraform"
alias tfp="terraform plan"
alias tg="terragrunt"
alias tgi="terragrunt init -upgrade && terragrunt"
alias tgp="terragrunt plan"
