### Deploying the Dashboard UI

The Dashboard UI is not deployed by default. To deploy it, run the following command:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml
```

### Create Admin Service Account

```
cat <<END>> dashboard-admin.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dashboard-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: dashboard-admin
  namespace: kube-system
END 
```
- create the cluster-admin Service Account as below:
```
$ kubectl create -f dashboard-admin.yaml
```

- Now we’re ready to get the token from admin-user by following command:
```
$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep dashboard-admin | awk '{print $1}')
Name:         dashboard-admin-token-rdgv9
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-admin
              kubernetes.io/service-account.uid: 185f0f2d-3d36-406d-8a48-962d3e275ea1

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  11 bytes
token: <your token will be shown here>
```
or you can get just only the token by running:
```
$ kubectl get secret -n kube-system $(kubectl get serviceaccount dashboard-admin -n kube-system -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode | tr -d '\n'
```

### Accessing the Dashboard UI

Now copy the token and paste it into ```Enter token``` field on login screen.

![Alt text](https://github.com/kubernetes/dashboard/raw/master/docs/images/signin.png)


