export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


function kkpods() {
  echo -e "POD\tNODE\tPOOL";
  kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.metadata.name} {.spec.nodeName}{"\n"}{end}' | while read pod node; do
    pool=$(kubectl get node "$node" -o custom-columns="NAME:.metadata.name,POOL:.metadata.labels.karpenter\\.sh/nodepool");
    echo -e "$pod\t$node\t$pool";
  done
}

function kube_shell() {
  local ns=""
  if [ $# -ge 1 ]; then
      ns="--namespace=$1"
  fi

  # Check if the pod exists, and if so, delete it
  if kubectl get pod $ns kube-shell &>/dev/null; then
    kubectl delete pod $ns kube-shell
  fi

  # Run a new pod with the specified image
  kubectl run -it --rm --restart=Never $ns --image=bradbeam/utility:latest kube-shell-dk
}


alias k='kubectl'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kl='kubectl logs'
alias kcucc='kubectl config unset current-context'
alias kknodes="kubectl get nodes -o custom-columns=\"NAME:.metadata.name,POOL:.metadata.labels.karpenter\\.sh/nodepool\""
