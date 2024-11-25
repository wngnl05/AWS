시작하기 전에 **EKS NodeGroup IAM 역활**에 아래 정책을 추가해주세요.

```
CloudWatchFullAccess
```

**Fluentbit 역활 생성하기**

```
CLUSTER_NAME="<EKS CLUSTER 이름>"
```

```
OIDC_ID=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | sed 's|https://||')
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_ARN="arn:aws:iam::$ACCOUNT_ID:oidc-provider/$OIDC_ID"
aws iam create-role --role-name wngnl_CloudWatch_Role --assume-role-policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Effect\": \"Allow\",
            \"Principal\": {
                \"Federated\": \"${OIDC_ARN}\"
            },
            \"Action\": \"sts:AssumeRoleWithWebIdentity\",
            \"Condition\": {
                \"StringEquals\": {
                    \"${OIDC_ID}:aud\": \"sts.amazonaws.com\",
                    \"${OIDC_ID}:sub\": \"fluent-bit\"
                }
            }
        }
    ]
}"
# PowerUserAccess 정책 연결
aws iam attach-role-policy --role-name wngnl_CloudWatch_Role --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
aws iam attach-role-policy --role-name wngnl_CloudWatch_Role --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
aws iam attach-role-policy --role-name wngnl_CloudWatch_Role --policy-arn arn:aws:iam::aws:policy/CloudWatchFullAccess
```

**Fluentbit.yaml 다운로드**

```
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/CloudWatch/LogGroup/daemonset.yaml
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/CloudWatch/LogGroup/serviceaccount.yaml
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/CloudWatch/LogGroup/fluentbit.yaml
```

1. **daemonset.yaml** 에서 **환경변수 (리전)** 을 작성해줍니다.
2. **serviceaccount.yaml** 에서 6번째 줄에 **<당신의 AWS 아이디>**를 작성해줍니다.
3. **fluentbit.yaml** 에서 **\[INPUT\], \[FILTER\], \[OUTPUT\]** 를 수정해줍니다.

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FOo2S7%2FbtsIyIWFr71%2FHxCwbuk6krFctu9FE8sljK%2Fimg.png)
1개 이상의 로그그룹을 생성할려면 "@INCLUDE <deployment 이름>.conf" 를 추가하고 
아래 코드도 추가해줍니다.

```
  <deployment 이름>.conf: |
    [INPUT]
        Name                tail
        Tag                 <deployment 이름>.*
        Path                /var/log/containers/<deployment 이름>*
        multiline.parser    docker, cri
        DB                  /var/log/flb_kube.db
        Mem_Buf_Limit       5MB
        Skip_Long_Lines     On
        Refresh_Interval    10
    [FILTER]
        Name                kubernetes
        Match               <deployment 이름>.*
        Merge_Log           On
        Merge_Log_Key       log_processed
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On
    [OUTPUT]
        Name                cloudwatch_logs
        Match               <deployment 이름>.*
        region              ${AWS_REGION}
        log_group_name      <로그그룹 이름>
        log_stream_prefix   <스트림 이름>
        auto_create_group   true
        extra_user_agent    container-insights
```

이제 모든 파일을 apply 하고 CloudWatch의 로그그룹을 확인해주면 됩니다.
