### Deploying the Dashboard UI

The Dashboard UI is not deployed by default. To deploy it, run the following command:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml
```

### Accessing the Dashboard UI

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

```
$ kubectl create -f dashboard-admin.yaml
```


```
[root@ylclk8sas01 ~]# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep dashboard-admin | awk '{print $1}')
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
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IlBLLW9RdDB0SC1QSVp2LVlEV3N2dHp0T0taVjk0cllaaGZXRk10NldxeVkifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tcmRndjkiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMTg1ZjBmMmQtM2QzNi00MDZkLThhNDgtOTYyZDNlMjc1ZWExIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.BL0adtIapVCmwgoVwQIxIxde-qowraJR7xSCl9sXuOqNww_i9VTo-IoeS8rJfY45AQH_G07ZT9EjqWRXJ_kKiAcL5bB7IHJFhUE45LDoC67x22wW3_OYVloSuqgbs0YuyVFJH4uD44Y63o_EFoItXw4ctHvCiIEO371U3_1mw-y7WQrD65LP_hwlN-7SYBR8MWBgMTxCvXlXYUXTvBsPwf5aT9-BCR3mMQvSUgwCIDwcBQx8lJIUaDaFZpAcJWfaPpDRITWs9RQfNqunOYq91wzNpQWKEmu_ekbrIJSMlKXcXv6N_dVx580eU_3fjQGSUe2lbb-8H7yCppkkjFqr-g
```

### Accessing the Dashboard UI

Now copy the token and paste it into ```Enter token``` field on login screen.

![Alt text](https://github.com/kubernetes/dashboard/raw/master/docs/images/signin.png)


