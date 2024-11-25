**OpenSearch 도매인 생성할 때 참고하세요.**

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(1).png">
<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(2).png">
<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(3).png">

**최대 절 수에 1024를 꼭 적어주세요.**

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:ESHttp*",
      "Resource": "arn:aws:es:<리전>:<사용자 아이디>:domain/<OpenSearch 도매인>/*"
    }
  ]
}
```

위의 정책은 OpenSearch의 **보안구성** > **액세스 정책** 에 넣어주세요

**OpenSearch 정책 생성하기**

```
OPENSEARCH_ARN="<OpenSearch ARN>"
```

```
aws iam create-policy \
    --policy-name wngnl_OpenSearch_Policy \
    --policy-document '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "es:ESHttp*"
                ],
                "Resource": "'"${OPENSEARCH_ARN}"'",
                "Effect": "Allow"
            }
        ]
    }'
```

**OpenSeach 역활 생성하기**

```
CLUSTER_NAME="<EKS CLUSTER 이름>"
```

```
OIDC_ID=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | sed 's|https://||')
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_ARN="arn:aws:iam::$ACCOUNT_ID:oidc-provider/$OIDC_ID"

aws iam create-role --role-name wngnl_OpenSearch_Role --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "'"${OIDC_ARN}"'"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "'"${OIDC_ID}"':aud": "sts.amazonaws.com"
                    "'"${OIDC_ID}"':sub": "fluent-bit",
                }
            }
        }
    ]
}'
aws iam attach-role-policy --role-name wngnl_OpenSearch_Role --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
```

**Down File**

```
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/OpenSearch/serviceaccount.yaml
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/OpenSearch/daemonset.yaml
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/EKS/OpenSearch/fluentbit.yaml
```

daemonset.yaml, serviceaccount.yaml, fluentbit.yaml을 수정하고 apply 해줍니다.

```
export CLUSTER_NAME=<클러스터 이름>
export LOGGING_ROLE=$(kubectl get sa fluent-bit -n default -o json |jq '.metadata.annotations."eks.amazonaws.com/role-arn"' -r)
export OPEN_SEARCH_ENDPOINT=<OpenSearch 앤드포인트>
export OPEN_SEARCH_MASTER_PASSWORD=<OpenSearch 비밀번호>

curl -sS -u "${OPEN_SEARCH_MASTER_USER}:${OPEN_SEARCH_MASTER_PASSWORD}" \
    -X PATCH ${OPEN_SEARCH_ENDPOINT}/_opendistro/_security/api/rolesmapping/all_access?pretty \
    -H 'Content-Type: application/json' \
    -d '[{"op": "add", "path": "/backend_roles", "value": [ "'${LOGGING_ROLE}'" ]}]'
```

**OpenSearh 보안 역활 업데이트**

```
kubectl logs daemonset.apps/fluent-bit
```

위의 명령어로 상태를 체크하고 아무 문제 없다면 

로드밸런서 OR 컨테이너에서 curl 을 보내 로그를 생성한 후 OpenSearch 도매인으로 접속해줍니다,

#### **OpenSearch 설정**

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(4).png">

```
_dashboards/app/management/opensearch-dashboards/indexPatterns/create
```

위의 경로로 접속하여 로그 이름을 작성해줍니다       ex.  product-\* 

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(5).png">

Time field = @timestamp

#### **Log 확인**

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(6).png">

Discover 로 이동하여 줍니다.

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(7).png">

product-\* 를 클릭하면 로그를 확인할 수 있습니다.

#### **특정 Log 확인**

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(8).png">

메뉴 아래의 DevTools를 클릭하고

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(9).png">
```
POST /<로그 이름>-*/_search
{
  "query": {
    "query_string": {
      "query": "<찾는 텍스트>"
    }
  }
}
```

위의 코드로 원하는 값을 찾을 수 있습니다.

#### **값이 있는 경우**

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(10).png">

#### **값이 없는 경우**

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-30(11).png">
