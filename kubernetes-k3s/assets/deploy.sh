#!/bin/bash

## install deps
## docker and go should already be installed on katacoda ubuntu image
#eval "$(curl -sL https://raw.githubusercontent.com/travis-ci/gimme/master/gimme | GIMME_GO_VERSION=stable bash)" \
#&& export PATH=$PATH:$HOME/go/bin

## packages (ex: kubectl httpie termdown)
apt-get update \
&& apt-get install -y httpie
#&& apt-get install -y apt-transport-https \
#&& curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
#&& echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
#&& apt-get update \
#&& apt-get install -y kubectl httpie
#&& apt-get install -y httpie


## install k3s and start cluster
curl -sfL https://get.k3s.io | sh - \
&& kubectl wait --for=condition=available --timeout=5m deployment/coredns -n kube-system \
&& kubectl wait --for=condition=available --timeout=5m deployment/local-path-provisioner -n kube-system

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

cat <<'EOF' >/root/.bash_profile
cat ~/.bash_profile
prompt_command() {
  _PS1_expire=3540
  _PS1_now=$(expr `date +%s` - `stat -c %Y /tmp/d`)
  if [ $(expr $_PS1_expire - $_PS1_now) -lt 300 ]; then
    PS1=$( printf "\[\e[0;31m\]<5--MINS--LEFT! \W>\[\e[1;37m\] ")
  else
    PS1=$( printf "\[\e[0;32m\]%02d:%02d \W>\[\e[1;37m\] " \
           $(( (( _PS1_expire - _PS1_now ) % 3600) / 60 )) \
           $((  ( _PS1_expire - _PS1_now ) % 60))           \
       )
  fi
}
PROMPT_COMMAND='prompt_command'
EOF

echo "deploy complete"
