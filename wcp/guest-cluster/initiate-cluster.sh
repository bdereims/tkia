#!/bin/bash
#bdereims@vmware.com

MONITORING_NS="monitoring" 
STORAGE_CLASS="vsan-default-storage-policy"

kubectl apply -f allow-runasnonroot-clusterrole.yaml
kubectl apply -f metrics.yaml

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create ns ${MONITORING_NS}
helm install prometheus --set global.storageClass=${STORAGE_CLASS} bitnami/kube-prometheus -n ${MONITORING_NS}
helm install grafana --set global.storageClass=${STORAGE_CLASS} bitnami/grafana -n ${MONITORING_NS}
kubectl -n ${MONITORING_NS} path svc grafana -p '{"spec":{"type": "LoadBalancer"}}'


echo "Add to Grafana this prometheus datasource: http://prometheus-kube-prometheus-prometheus.${MONITORING_NS}.svc.cluster.local:9090"
echo "Grafana at: http://$(kubectl -n ${MONITORING_NS} get svc grafana -o json | jq -r '[.status.loadBalancer.ingress[].ip,.spec.ports[].port] | "\(.[0]):\(.[1])"')"
echo "Grafana Password: $(kubectl get secret grafana-admin --namespace ${MONITORING_NS} -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 --decode)"
