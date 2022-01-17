#!/bin/bash
#bdereims@vmware.com

. ../env

# download octant from git

cp ~/.kube/config .
docker build -t octant .
rm config

docker tag octant ${HARBOR}/xpday/octant:latest
docker login ${HARBOR}
docker push ${HARBOR}/xpday/octant:latest
