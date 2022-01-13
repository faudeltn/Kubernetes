


```bash

eksctl utils associate-iam-oidc-provider \
    --region <REGION> \
    --cluster <CLUSTER_NAME> \
    --approve

```


```bash

curl -fsSL -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy.json

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```

```bash
eksctl create iamserviceaccount \
    --cluster=<CLUSTER_NAME> \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::<ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --approve \
    --region <REGION>
```
```bash
eksctl  get iamserviceaccount --cluster  <CLUSTER_NAME>
```
Output
```
2022-01-11 22:25:06 [ℹ]  eksctl version 0.78.0
2022-01-11 22:25:06 [ℹ]  using region us-east-1
NAMESPACE       NAME                            ROLE ARN
kube-system     aws-load-balancer-controller    arn:aws:iam::<ACCOUNT_ID>:role/eksctl-eks-demo-addon-iamserviceaccount-kube-Role1-6PRU9IPUNAD1
```