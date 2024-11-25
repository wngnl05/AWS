# Cluster Role
### k8s cluster의 모든 네임스페이스와 리소스에 대한 권한을 설정합니다.

# Role
### k8s 특정 네임스페이스 내의 리소스에 대한 권한을 설정합니다.

<br>

## read verbs
```
"get", "list", "watch"
```
## write verbs
```
"create", "update", "patch", "delete"
```

## resource
```
"configmaps", "cronjobs", "deployments", "events", "ingresses", "jobs", "pods", "pods/attach", "pods/exec", "pods/log", "pods/portforward", "secrets", "services"
```
