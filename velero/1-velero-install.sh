#!/bin/bash
#bdereims@vmware.com

. ./env

CRED_VELERO=credentials-velero

# generate velero cred from conf file
eval "cat <<EOF
$(<${CRED_VELERO}-template)
EOF
" > credentials-velero

velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.1.0 \
    --bucket ${MINIO_BUCKET} \
    --secret-file ./${CRED_VELERO} \
    --use-volume-snapshots=false \
    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://${MINIO_SRV}:9000 \
    --use-restic

rm ${CRED_VELERO} 
