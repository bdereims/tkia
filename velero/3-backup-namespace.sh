#!/bin/bash
#bdereims@vmware.com

# ${1} : namespace to backup

velero backup create ${1}-backup --include-namespaces ${1} 
