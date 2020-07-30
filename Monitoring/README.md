

kubectl create ns logging

curl -O 


kubectl create secret generic elasticsearch-pw-elastic \
    -n logging \
    --from-literal password=Password


---
$ git clone https://github.com/kubernetes/kube-state-metrics.git
$ cd kube-state-metrics
$ kubectl apply -f examples/standard/
---
