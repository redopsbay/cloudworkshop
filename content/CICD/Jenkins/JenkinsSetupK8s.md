---
title: "Jenkins Setup on Kubernetes"
chapter: false
weight: 3
---

![DevOps](https://www.jenkins.io/images/logos/actor/256.png)

## Jenkins Up & Running on K8s 🚀

For quick deployment, we can deploy jenkins server thru `kubernetes` cluster.

We will use the latest jenkins-controller `jenkins/jenkins:lts` as lts image version.

**Note: Do not use in production**

1. Let's create a `namespace.yaml` file:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: jenkins-controller
```

then apply it thru:

```bash
kubectl apply -f namespace.yaml
```

2. Next, let's create `rbac-and-serviceaccount.yaml` file:

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: jenkins-admin
rules:
  - apiGroups: [""]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins-admin
  namespace: jenkins-controller
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: jenkins-admin
subjects:
  - kind: ServiceAccount
    name: jenkins-admin
    namespace: jenkins-controller
```
