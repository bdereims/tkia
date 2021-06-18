#!/bin/bash
#bdereims@vmware.com

#kubectl run -i --tty --rm debug --image=alpine --restart=Never --kubeconfig /home/grease-monkey/.kube-tkg/tmp/config_yzmk8upT -- sh
kubectl run -i --tty --rm debug --image=alpine --restart=Never -- sh
