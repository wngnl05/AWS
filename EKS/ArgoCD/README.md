[**동영상**](https://www.youtube.com/watch?v=MeU5_k9ssrs&t=45s)

[**ArgoCD 설치**](https://argo-cd.readthedocs.io/en/stable/getting_started/)

더보기

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

```
kubectl get all -n argocd
```

**[ArgoCD Rollout 설치](https://argo-rollouts.readthedocs.io/en/stable/installation/)**

더보기

```
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
```

```
kubectl argo rollouts version
```

```
kubectl get pod -n argo-rollouts
```

[**ArgoCD 접속하기**](https://www.youtube.com/watch?v=MeU5_k9ssrs&t=45s)

```
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

![ex_screenshot](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FQLYuJ%2FbtsILglxiXn%2F2bM1a3QQA9P0MkkA4TFSP1%2Fimg.png)
![ex_screenshot](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FSKDMf%2FbtsIKV9Suo7%2FkbNSuc6j0hFSztzqIv9Bmk%2Fimg.png)

```
127.0.0.1:8080
```

**IP로 접속해줍니다.**

**\- username : admin**

**\- password : 아래의 명려어로 획득**

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
