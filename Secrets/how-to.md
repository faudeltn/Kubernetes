## 

Secrets are a way to deploy sensitive information to Kubernetes Pods. They are similar to ConfigMaps, but are designed for sensitive information you don't want leaking out. They can optionally be encrypted at rest.
Secrets allow you to independently store sensitive data that your application needs in a Kubernetes object. 
Secrets are decoupled from Pods and Deployments. In addition, Secrets can be consumed by multiple Pods and Deployments, which can be extremely useful. As an example, if you have multiple micro-servies that need access to the same configuration parameter, all it takes is a single Secret. This used to be accomplished with a Config-Server micro-service, or supplying each micro-service with the same environment variable, which made updates difficult.
Kubernetes Secrets can store simple values like usernames and passwords. They can also store credentials to access a Docker registry, OAuth tokens, and SSH keys. In general, if there is some type of secret value you need to provide, regardless of the content, you can store it as a literal value and make sure your application can consume it without using a built-in construct.
We will go through the process of creating Secrets from literal values and files. We'll supply these values to Pods as environment variables and directories.


### Method 1: Use from-literal CLI argument

```
$ kubectl create secret generic mysecret --from-literal=username=lotfi --from-literal=password=mypassword
```

- Use Kubectl to get the list of the Secrets in the cluster Kubernetes
```
$ kubectl get secret
NAME                                 TYPE                                  DATA   AGE
myregistrykey                        kubernetes.io/dockerconfigjson        1      61m
mysql-secret                         Opaque                                1      62d
```



##Create Secrets from Files
https://www.katacoda.com/boxboat/courses/kf3/02-secrets
