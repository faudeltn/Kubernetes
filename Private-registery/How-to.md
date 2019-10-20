This Lab shows how to create a Deployment that uses a Secret to pull an image from a private Docker registry or repository
-

- Create a secret 
```
$ kubectl create secret docker-registry myregistrykey --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-password> --docker-email=<your-email>
```

You have successfully set your Docker credentials in the cluster as a Secret called `myregistrykey`, where:

| Key | Description |
| --- | --- |
| `<your-registry-server>` | is your Private Docker Registry FQDN. (https://index.docker.io/v1/ for DockerHub) |
| `<your-name>` | is your Docker username. |
| `<your-password>` | is your Docker password. |
| `<your-email>` | is your Docker email. |

  

- Use Kubectl to get the list of the Secrets in the cluster Kubernetes
```
$ kubectl get secret
NAME                                 TYPE                                  DATA   AGE
myregistrykey                        kubernetes.io/dockerconfigjson        1      61m
mysql-secret                         Opaque                                1      62d
```

- To understand the contents of the `myregistrykey` Secret you just created, execute the below command to inspect the Secret in YAML format:
```
$ apiVersion: v1
data:
  .dockerconfigjson: XXXXXXXXXXXXXXXXXXXXXXXXXXXX
kind: Secret
metadata:
  creationTimestamp: "2019-10-20T16:20:23Z"
  name: myregistrykey
  namespace: default
  resourceVersion: "161209"
  selfLink: /api/v1/namespaces/default/secrets/myregistrykey
  uid: 39d7b59d-2aaa-47e2-8f1c-fa316815dfe5
type: kubernetes.io/dockerconfigjson
```





- If you want to have more control, for example to set a `namespace` or a `label` on the new secret, then you can customise the Secret before storing it by generating a YAML file as below:

```
$ kubectl create secret docker-registry myregistrykey --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-password> --docker-email=<your-email> --dry-run -oyaml
apiVersion: v1
data:
  .dockerconfigjson: XXXXXXXXXX
kind: Secret
metadata:
  creationTimestamp: null
  name: myregistrykey
  namespace: YOURNAMESPACE
type: kubernetes.io/dockerconfigjson
```

Where:
`.dockerconfigjson` is a base64 representation of your Docker credentials.

- To understand what is in the `.dockerconfigjson` field, convert the secret data to a readable format by running one of the below commands:

```
kubectl get secret myregistrykey --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
kubectl get secret myregistrykey -o json | jq ".data[]" -r | base64 -d | tr -d '\n'
```
The output is similar to this:
```
{"auths":{"<your-registry-server>":{"username":"<your-name>","password":"<your-password>","email":"<your-email>","auth":"XXXXXXXXXXXXXXXXXX"}}}
```


- Create a Deployment where we add the `imagePullSecrets` field that we specified that Kubernetes should get the credentials from a Secret named `myregistrykey` tp pull the image.

```
$ kubectl create -f deployment-definition.yaml
```
