[Aws 문서](https://repost.aws/knowledge-center/eks-set-up-externaldns)
<br>

```
curl -o dns-policy.json https://raw.githubusercontent.com/wngnl/Aws/main/EKS/External%20DNS/dns-policy.json
```
<br>

json파일로 IAM 정책을 생성해주세요.
```
eksctl create iamserviceaccount --name external-dns \
--namespace default \
--cluster <클러스터 이름> \
--attach-policy-arn <정책 ARN> \
--approve
```
```
kubectl get sa
```
eksctl명령어에 정책 ARN을 수정하고 실행한뒤
"kubectl get sa"명령어로 "external-dns"가 생성되었는지 확인합니다.
<br>

```
kubectl api-versions | grep rbac.authorization.k8s.io
```
rbac가 실행되는지 확인하고
<br>

```
curl -o external-dns.yaml https://raw.githubusercontent.com/wngnl/Aws/main/EKS/External%20DNS/external-dns.yaml
```
Route53에서 호스팅 영역을 프라이빗으로 생성해주고
external-dns.yaml파일에서 "호스팅 영역 이름", "호스팅 영역 ID"를 수정해주세요
<br>

```
kubectl apply -f external-dns.yaml
```



