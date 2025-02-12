if which go > /dev/null; then
  export GOPATH=$(go env GOPATH)
  export PATH=$GOPATH/bin:$PATH
fi
