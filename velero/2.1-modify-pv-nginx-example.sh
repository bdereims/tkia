#!/bin/bash
#bdereims@vmware.com

# ${1} : pod name

# kubectl -n nginx-example annotate pod nginx-deployment-748957fd96-vwcsz backup.velero.io/backup-volumes=nginx-html
kubectl -n nginx-example exec --stdin --tty ${1} -c nginx -- /bin/bash
