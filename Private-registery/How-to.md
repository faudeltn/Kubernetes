This Lab shows how to create a Deployment that uses a Secret to pull an image from a private Docker registry or repository
-

- Create a secret 
```
$ kubectl create secret docker-registry myregistrykey --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-password> --docker-email=<your-email>
```
where:

| Key | Description |
| --- | --- |
| `<your-registry-server>` | is your Private Docker Registry FQDN. (https://index.docker.io/v1/ for DockerHub) |
| <your-name> | is your Docker username. |
| <your-password> | is your Docker password. |
| <your-email> | is your Docker email. |

  
You have successfully set your Docker credentials in the cluster as a Secret called regcred.

- 
```
$ kubectl get secret
NAME                                 TYPE                                  DATA   AGE
myregistrykey                        kubernetes.io/dockerconfigjson        1      61m
mysql-secret                         Opaque                                1      62d
```

- Check the docker-registry
```
$ kubectl get secret myregistrykey -o json | jq ".data[]" -r | base64 -d                                  
{"auths":{"https://index.docker.io/v1/":{"username":"user","password":"Password","email":"xxxx@yallalabs.com","auth":"ZmF1ZGcdekZhdWRlbDA1OTA="}}}
```

- Create a deployment
```
$ kubectl create -f deployment-definition.yaml
```



- If you want to create using a yaml file
```
$ kubectl create secret docker-registry myregistrykey --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-password> --docker-email=<your-email> --dry-run -oyaml
apiVersion: v1
data:
  .dockerconfigjson: XXXXXXXXXX
kind: Secret
metadata:
  creationTimestamp: null
  name: myregistrykey
type: kubernetes.io/dockerconfigjson
```

