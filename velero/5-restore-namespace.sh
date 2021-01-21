#!/bin/bash
#bdereims@vmware.com

# ${1} : namespace to backup

velero restore create --from-backup ${1}-backup
