
###Prerequisites

An existing Amazon EKS cluster. 

An existing AWS Identity and Access Management (IAM) OpenID Connect (OIDC) provider for your cluster. To determine whether you already have one, or to create one, see Create an IAM OIDC provider for your cluster.

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

Add the following IAM policy to the IAM role created in a previous step. The policy allows the AWS Load Balancer Controller access to the resources that were created by the ALB Ingress Controller for Kubernetes

Download the IAM policy.
```bash
curl -fsSL -o iam_policy_v1_to_v2_additional.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy_v1_to_v2_additional.json
```

Create the IAM policy and note the ARN that is returned
```bash
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerAdditionalIAMPolicy \
    --policy-document file://iam_policy_v1_to_v2_additional.json
```

Attach the IAM policy to the IAM role that you created in a previous step. Replace your-role-name with the name of the role. If you created the role using eksctl, then to find the role name that was created, open the AWS CloudFormation console and select the eksctl-your-cluster-name-addon-iamserviceaccount-kube-system-aws-load-balancer-controller stack. Select the Resources tab. The role name is in the Physical ID column. If you used the AWS Management Console to create the role, then the role name is whatever you named it, such as AmazonEKSLoadBalancerControllerRole.

```bash
aws iam attach-role-policy \
    --role-name <IAM_ROLE_NAME> \
    --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/AWSLoadBalancerControllerAdditionalIAMPolicy
```

Add the eks-charts repository.
```bash
helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
```

Install the AWS Load Balancer Controller.
```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
     --set clusterName=<CLUSTER_NAME> \
     --set serviceAccount.create=false \
     --set serviceAccount.name=aws-load-balancer-controller
```     


Verify that the controller is installed.
```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
```

Output
```bash
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
aws-load-balancer-controller   2/2     2            2           84s
```
