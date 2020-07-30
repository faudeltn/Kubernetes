

kubectl create ns logging

curl -O 


kubectl create secret generic elasticsearch-pw-elastic \
    -n logging \
    --from-literal password=Password
