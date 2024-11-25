**[Link](https://nangman14.tistory.com/76)**

External Secret 역활 & 정책 만들기

더보기

```
REGION=""
CLUSTER_NAME=""
NAMESPACE=""
```

```
cat >secret-policy.json <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "VisualEditor0",
         "Effect": "Allow",
         "Action": [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
         ],
         "Resource": ["*"]
      },
      {
        "Effect": "Allow",
        "Action": ["kms:Decrypt"],
        "Resource": ["*"]
      }
    ]
}
EOF
aws iam create-policy \
    --policy-name wngnl-external-secrets \
    --policy-document file://secret-policy.json
    
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
eksctl create iamserviceaccount \
    --name wngnl-external-secrets-cert-controller \
    --region $REGION \
    --cluster $CLUSTER_NAME \
    --namespace=$NAMESPACE \
    --attach-policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/wngnl-external-secrets \
    --override-existing-serviceaccounts \
    --approve
```

External Secret 설치하기

```
helm repo add external-secrets https://charts.external-secrets.io
 
helm install external-secrets \
   external-secrets/external-secrets \
   -n kube-system \
   --set serviceAccount.create=false
```

Secret Reloader 설치하기

```
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update

helm install reloader stakater/reloader
```

Down File

```
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/External-Secret/external-secret.yaml
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/External-Secret/secret-store.yaml
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/External-Secret/deployment.yaml
```
