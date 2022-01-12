

https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/
https://www.eksworkshop.com/advanced/410_batch/


### Deploy Argo Controller

Argo run in its own namespace and deploys as a CustomResourceDefinition.

Deploy the Controller and UI.

```bash
kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-workflows/${ARGO_VERSION}/manifests/install.yaml
```

### Disable internal TLS

First, to avoid internal redirection loops from HTTP to HTTPS, the API server should be run with TLS disabled. Edit the argocd-server deployment to add the --insecure flag to the argocd-server command.

The container command should change from:
```yaml
      containers:
      - command:
        - argocd-server
        - --staticassets
        - /shared/app
```

To:
```yaml
      containers:
      - command:
        - argocd-server
        - --insecure
        - --staticassets
        - /shared/app
```

### Creating a service
        
 Use NodePort
 
type: NodePort


Once we create this service, we can configure the Ingress

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f /
```

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

