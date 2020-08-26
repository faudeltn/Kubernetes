# Kubernetes




# Table of Contents

1. [Certificate Signing Request](https://github.com/faudeltn/Kubernetes/blob/master/CertificateSigningRequest/How-to.md)
2. [Dashboard-UI](https://github.com/faudeltn/Kubernetes/blob/master/Dashboard-UI/how-to.md)
3. [Private registery](https://github.com/faudeltn/Kubernetes/tree/master/Private-registery)
4. [Secrets](https://github.com/faudeltn/Kubernetes/blob/master/Secrets/how-to.md)
5. [ReplicaSets](#replicasets)
6. [Deployments](#deployments)

## ReplicaSets
ReplicaSets are the primary method of managing Pod replicas and their lifecycle. This includes their scheduling, scaling, and deletion. Prova

Their job is simple, always ensure the desired number of replicas that match the selector are running.

## Deployments

Deployments are a declarative method of managing Pods via ReplicaSets. They provide rollback functionality in addition to more granular update control mechanisms.
