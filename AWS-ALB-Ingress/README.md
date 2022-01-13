


```bash

eksctl utils associate-iam-oidc-provider \
    --region <REGION> \
    --cluster <CLUSTER_NAME> \
    --approve

```

Download an IAM policy for the AWS Load Balancer Controller that allows it to make calls to AWS APIs on your behalf
```bash

curl -fsSL -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy.json
```

Create an IAM policy using the policy downloaded in the previous step
```bash
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```

Create an IAM role and annotate the Kubernetes service account that's named ```aws-load-balancer-controller``` in the ```kube-system``` namespace for the AWS Load Balancer Controller using ```eksctl ```

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


```bash
curl -fsSL -o iam_policy_v1_to_v2_additional.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy_v1_to_v2_additional.json

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerAdditionalIAMPolicy \
    --policy-document file://iam_policy_v1_to_v2_additional.json
```

```bash
aws iam attach-role-policy \
    --role-name <IAM_ROLE_NAME> \
    --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/AWSLoadBalancerControllerAdditionalIAMPolicy
```

```bash
helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
```

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
     --set clusterName=<CLUSTER_NAME> \
     --set serviceAccount.create=false \
     --set serviceAccount.name=aws-load-balancer-controller
```     
