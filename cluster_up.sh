#!/bin/zsh

set -o errexit

ctlptl apply -f kind.yaml
# replace_loopback:
sed -i "s/127.0.0.1.*/$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kind-control-plane):6443/" /root/.kube/config 
