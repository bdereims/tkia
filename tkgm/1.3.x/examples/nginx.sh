kubectl create ns test
kubectl -n test create deploy nginx --image=nginx
kubectl -n test expose deploy nginx --port=80 --type=LoadBalancer
