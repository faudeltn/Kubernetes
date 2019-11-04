## 

Secrets are a way to deploy sensitive information to Kubernetes Pods. They are similar to ConfigMaps, but are designed for sensitive information you don't want leaking out. They can optionally be encrypted at rest. Secrets allow you to independently store sensitive data that your application needs in a Kubernetes object. Secrets are decoupled from Pods and Deployments.

In addition, Secrets can be consumed by multiple Pods and Deployments, which can be extremely useful. As an example, if you have multiple micro-servies that need access to the same configuration parameter, all it takes is a single Secret. This used to be accomplished with a Config-Server micro-service, or supplying each micro-service with the same environment variable, which made updates difficult.

Kubernetes Secrets can store simple values like usernames and passwords. They can also store credentials to access a Docker registry, OAuth tokens, and SSH keys. In general, if there is some type of secret value you need to provide, regardless of the content, you can store it as a literal value and make sure your application can consume it without using a built-in construct.
We will go through the process of creating Secrets from literal values and files. We'll supply these values to Pods as environment variables and directories.


### Method 1: Creating Secrets from literal

```
$ kubectl create secret generic mysecret --from-literal=username=lotfi --from-literal=password=mypassword
```

- Use Kubectl to get the list of the Secrets in the cluster Kubernetes
```
$ kubectl get secrets
NAME                  TYPE                                  DATA      AGE
default-token-k24z2   kubernetes.io/service-account-token   3         36m
mysecret              Opaque                                2         5s
```

### Method 2: Creating Secrets from Files
Another way of creating secrets from the CLI is to first create a file with the required contents. For example, we can put the username and password in files and then use the files in kubectl command

```
$ echo "lotfi" > username
$ echo "mypassword" > password
```
- create a secret called file-secret as below
```
$ kubectl create secret generic file-secrets  --from-file=username --from-file=password
secret/file-secrets created
```

- Use Kubectl to get the list of the Secrets in the cluster Kubernetes
```
$ kubectl get secrets
NAME                  TYPE                                  DATA      AGE
default-token-k24z2   kubernetes.io/service-account-token   3         46m
file-secrets          Opaque                                2         43s
mysecret              Opaque                                2         9m
```
### Creating Secrets from Manifest file

```
password=$(echo -n "mypassword" | base64)
user=$(echo -n "lotfi" | base64)
```

```
echo "apiVersion: v1
kind: Secret
metadata:
  name: secret-manifest
type: Opaque
data:
  username: $user
  password: $password" >> secret.yaml
```

```
kubectl create -f secret.yaml
```
- Use Kubectl to get the list of the Secrets in the cluster Kubernetes
```
master $ kubectl get secrets
NAME                  TYPE                                  DATA      AGE
default-token-k24z2   kubernetes.io/service-account-token   3         53m
file-secrets          Opaque                                2         8m
secret-manifest       Opaque                                2         5s
mysecret              Opaque                                2         17m
```


## Using Secrets as Environment Variables

Let's create a kubernetes pod manifest 
```

echo "apiVersion: v1
kind: Pod
metadata:
  name: redis-env
spec:
  containers:
  - name: redis-container
    image: redis
    env:
      - name: USERNAME
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: username
      - name: SECRET_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: password" >> pod-env.yaml
```

```
kubectl create -f pod-env.yaml
```

- Now, we can go into the Redis container from our Pod and check the environment variables:
```
master $ kubectl exec -ti redis-env env | egrep "USERNAME|SECRET_PASSWORD"
USERNAME=lotfi
SECRET_PASSWORD=mypassword
```

## Using Secrets as Files in a Pod through mounted Volumes
```
echo "apiVersion: v1
kind: Pod
metadata:
  name: redis-vol
spec:
  containers:
  - name: redis-container
    image: redis
    volumeMounts:
    - name: config
      mountPath: "/etc/secrets/config"
      readOnly: true
  volumes:
  - name: config
    secret:
      secretName: secret-manifest
      items:
      - key: username
        path: username
      - key: password
        path: password" >> pod-volume.yaml
```

```
$ kubectl create -f pod-volume.yaml
```
- Now that we've created the pod, we can open up a bash shell and check out those secret files
```
$ kubectl exec -it redis-vol -- /bin/bash
# cat /etc/secrets/config/username
lotfi
# cat /etc/secrets/config/password
mypassword

```

#### Create Secrets from Files
https://www.katacoda.com/boxboat/courses/kf3/02-secrets
