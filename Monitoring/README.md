

kubectl create ns logging

curl -O https://raw.githubusercontent.com/faudeltn/ELK/k8s/elasticsearch-configmap.yaml
curl -O https://raw.githubusercontent.com/faudeltn/ELK/k8s/es.yml
curl -O https://raw.githubusercontent.com/faudeltn/ELK/k8s/kibana-configmap.yaml
curl -O https://raw.githubusercontent.com/faudeltn/ELK/k8s/kibana.yml


kubectl create secret generic elasticsearch-pw-elastic \
    -n logging \
    --from-literal password=Password
