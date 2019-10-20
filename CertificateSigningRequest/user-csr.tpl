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
