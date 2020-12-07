#/bin/bash

git clone https://github.com/storax/kubedoom.git
cd kubedoom
kubectl apply -f manifest/
