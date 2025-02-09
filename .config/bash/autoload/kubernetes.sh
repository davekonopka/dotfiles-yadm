alias k='kubectl'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kl='kubectl logs'
alias kcucc='kubectl config unset current-context'
alias kknodes="kubectl get nodes -o custom-columns=\"NAME:.metadata.name,POOL:.metadata.labels.karpenter\\.sh/nodepool\""
