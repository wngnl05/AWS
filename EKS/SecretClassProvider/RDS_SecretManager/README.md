[**Github**](https://github.com/wngnl-dev/AWS/tree/main/EKS/SecretProviderClass/RDS_SecretManager)

먼저 RDS를 생성할때 비밀번호를 Secret Manager로 생성해줘야 합니다.

#### **1\. EKS IAM 역활 및 정책**
EKS 포드가 AWS Secrets Manager의 비밀에 접근할 수 있도록 IAM 정책을 생성합니다,
이 정책은  EKS 포드에서 사용하는 서비스 계정에 연결합니다.
```
Secret_Manager_ARN=""
```
```
aws iam create-policy --policy-name wngnl-SecretsManagerAccessPolicy --policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Effect\": \"Allow\",
            \"Action\": [
                \"secretsmanager:GetSecretValue\",
                \"secretsmanager:DescribeSecret\"
            ],
            \"Resource\": \"$Secret_Manager_ARN\"
        }
    ]
}"
```
<br><br>

**환경 변수 설정**
```
CLUSTER_NAME="<클러스터 이름>"
NAMESPACE="<네임스페이스>"
SERVICE_ACCOUNT_NAME="<서비스 어카운트 이름>"
```
<br><br>

**ServiceAccount 만들기 && SecretProvideClass 역활 만들기**
ex. Pod에 부여할 역활이 있으면 wngnl-SecretProviderClass-Role에 정책을 추가해주세요.

```
POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`wngnl-SecretsManagerAccessPolicy`].Arn' --output text)
eksctl create iamserviceaccount \
   --cluster=$CLUSTER_NAME \
   --namespace=$NAMESPACE \
   --name=$SERVICE_ACCOUNT_NAME \
   --attach-policy-arn=$POLICY_ARN \
   --override-existing-serviceaccounts \
   --approve
   
OIDC_PROVIDER_URL=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | sed 's/^https:\/\///')
OIDC_PROVIDER_ARN=$(aws iam list-open-id-connect-providers --query "OpenIDConnectProviderList[?ends_with(Arn, '$OIDC_PROVIDER_URL')].Arn" --output text)

aws iam create-role --role-name wngnl-SecretProviderClass-Role --assume-role-policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Effect\": \"Allow\",
            \"Principal\": {
                \"Federated\": \"$OIDC_PROVIDER_ARN\"
            },
            \"Action\": \"sts:AssumeRoleWithWebIdentity\",
            \"Condition\": {
                \"StringEquals\": {
                    \"$OIDC_PROVIDER_URL:sub\": \"system:serviceaccount:$NAMESPACE:$SERVICE_ACCOUNT_NAME\"
                }
            }
        }
    ]
}"
# 역활에 정책 연결하기
aws iam attach-role-policy --role-name wngnl-SecretProviderClass-Role --policy-arn $POLICY_ARN
```
<br><br>

#### **2\. Secret Store CSI Driver 설치**
```
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system --set syncSecret.enabled=true --set enableSecretRotation=true
kubectl get daemonsets -n kube-system -l app.kubernetes.io/instance=csi-secrets-store
helm repo add aws-secrets-manager https://aws.github.io/secrets-store-csi-driver-provider-aws
helm install -n kube-system secrets-provider-aws aws-secrets-manager/secrets-store-csi-driver-provider-aws
kubectl get daemonsets -n kube-system -l app=secrets-store-csi-driver-provider-aws
```

<br><br><br>
**1-secret-provider-class.yaml && 3-deployment.yaml은 수정해줘야 합니다**
```
curl -o secret-provider-class.yaml https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/SecretClassProvider/RDS_SecretManager/secret-provider-class.yaml
curl -o deployment.yaml https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/SecretClassProvider/RDS_SecretManager/deployment.yaml
```
```
kubectl apply -f 1-secret-provide-class.yaml
kubectl apply -f 2-value.yaml
kubectl apply -f 3-deployment.yaml
```
