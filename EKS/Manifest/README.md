## EKS Cluster 보안그룹
Inbound : 80, 443  0.0.0.0/0 <br>
Outbound : All_Trafic  0.0.0.0/0

## Upadate Cluster to EC2 < 2 중 1 > 
```
eksctl utils write-kubeconfig --name <클러스터 이름>
```
```
aws eks update-kubeconfig --name <클러스터 이름>
```

<br>

Create ODIC <자격 증명 공급자>
```
eksctl utils associate-iam-oidc-provider --region=<리전> --cluster=<클러스터 이름> --approve
```

<br>

## NodeGroup 보안그룹
Inbound : 22, 10250, 443, 1025-65525  sg-<클러스터 보안그룹> <br>
Outbound : All_Trafic  0.0.0.0/0

## NodeGroup IAM Role
AmazonEKSWorkerNodePolicy <br>
AmazonEC2ContainerRegistryReadOnly <br>
AmazonEKS_CNI_Policy <br>

<br>

## Download Manifest yaml file
```
curl -o deployment.yml https://raw.githubusercontent.com/wngnl/AWS/main/EKS/Manifest/deployment.yml
curl -o service.yml https://raw.githubusercontent.com/wngnl/AWS/main/EKS/Manifest/service.yml
curl -o ingress.yml https://raw.githubusercontent.com/wngnl/AWS/main/EKS/Manifest/ingress.yml
```
