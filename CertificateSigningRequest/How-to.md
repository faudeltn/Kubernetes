01- Generate a key Pair
```
openssl genrsa -out waderni.key 2048
openssl req -new -key waderni.key -nodes -out waderni.csr -subj "/CN=waderni"
```

02- Generate CertificateSigningRequest yaml file:
```
export USER="waderni"
export CLIENT_CSR=$(cat waderni.csr | base64 | tr -d '\n')
```
```
vi user-csr.tpl
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${USER}
spec:
  groups:
  - system:authenticated
  request: ${CLIENT_CSR}
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
```

```
$ cat user-csr.tpl | envsubst > $USER-csr.yaml
```
```
master $ kubectl create -f waderni-csr.yaml
```
```
master $ kubectl get csr
NAME                                                   AGE       REQUESTOR                 CONDITION
csr-mxw9c                                              27m       system:node:master        Approved,Issued
waderni                                                8s        kubernetes-admin          Pending
node-csr-fo3AfEIrtw6i9Pu8ccZ_Cj2k0zIMp9VC1QO15Oxr6n8   26m       system:bootstrap:96771a   Approved,Issued
```

- Approve the certificate
```
master $ kubectl certificate approve waderni
certificatesigningrequest.certificates.k8s.io/waderni approved
```


03- Generate a Kubeconfig File
```
$ vi kubeconfig.tpl
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${CLUSTER_CA}
    server: ${CLUSTER_ENDPOINT}
  name: ${CLUSTER_NAME}
contexts:
- context:
    cluster: ${CLUSTER_NAME}
    user: ${USER}
  name: ${USER}@${CLUSTER_NAME}
kind: Config
users:
- name: ${USER}
  user:
    client-certificate-data: ${CLIENT_CERTIFICATE_DATA}
    client-key-data: <CLIENT-KEY-DATA>
```

```
# User identifier
export USER="waderni"
# Cluster Name (get it from the current context)
 export CLUSTER_NAME=$(kubectl config view --raw -o json | jq -r '.clusters[].name')
# API Server endpoint
 export CLUSTER_ENDPOINT=$(kubectl config view --raw -o json | jq -r '.clusters[].cluster."server"')
# Cluster Certificate Authority
 export CLUSTER_CA=$(kubectl config view --raw -o json | jq -r '.clusters[].cluster."certificate-authority-data"')
# Client certificate
 export CLIENT_CERTIFICATE_DATA=$(kubectl get csr waderni -o jsonpath='{.status.certificate}')
```

```
cat kubeconfig.tpl | envsubst > kubeconfig
```


- Create User clusterrolebinding
```
$ kubectl create clusterrolebinding waderni --clusterrole=cluster-admin --user=waderni  
```

04- client connection using kubectl
```
export export KUBECONFIG=$PWD/kubeconfig
kubectl config set-credentials waderni --client-key=$PWD/waderni.key --embed-certs=true
kubectl config set current-context waderni@kubernetes
kubectl config view
```

```
[root@ylcldokas01 ~]# kubectl version
Client Version: version.Info{Major:"1", Minor:"16", GitVersion:"v1.16.2", GitCommit:"c97fe5036ef3df2967d086711e6c0c405941e14b", GitTreeState:"clean", BuildDate:"2019-10-15T19:18:23Z", GoVersion:"go1.12.10", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"15", GitVersion:"v1.15.2", GitCommit:"f6278300bebbb750328ac16ee6dd3aa7d3549568", GitTreeState:"clean", BuildDate:"2019-08-05T09:15:22Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}
```



```
kubectl --kubeconfig=./kubeconfig --context=kube-ops@waderni get clusterrolebindings waderni
kubectl set-credentials --kubeconfig=.kube/config --context=waderni@kubernetes --client-key=waderni.key --embed-certs=true get clusterrolebindings waderni
```
