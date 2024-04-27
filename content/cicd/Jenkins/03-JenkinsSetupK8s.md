---
title: "Jenkins Setup on Kubernetes"
chapter: false
weight: 3
---

For quick deployment, we can deploy jenkins server thru `kubernetes` cluster.

We will use the latest jenkins-controller `jenkins/jenkins:lts` as lts image version.

{{% notice warning %}}

Do not use in production. If you want a production grade deployment. Kindly, refer to this repository [https://github.com/jenkinsci/helm-charts](https://github.com/jenkinsci/helm-charts)

{{% /notice %}}

{{% notice tip %}}

It is fairly recommended to plan ahead the sustainability of the Jenkins Server deployment. As systems like Jenkins which is not designed to be scalable is highly prone to fail.

{{% /notice %}}

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

3. Create `PersistentVolume` and `PersistentVolumeClaim` named `jenkins-pv-and-pvc.yaml`:

```yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: jenkins-pv-volume
  labels:
    type: pv
spec:
  claimRef:
    name: jenkins-pv-claim
    namespace: jenkins-controller
  capacity:
    storage: 20Gi
  accessModes:
    - ReadWriteOnce
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jenkins-pv-claim
  namespace: jenkins-controller
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi

```

4. Create `StatefulSet` named `jenkins-statefulset.yaml`:

```yaml
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: jenkins-server
  namespace: jenkins-controller
spec:
  serviceName: jenkins-server
  replicas: 1
  selector:
    matchLabels:
      app: jenkins-server
  template:
    metadata:
      labels:
        app: jenkins-server
    spec:
      securityContext:
        fsGroup: 1000
        runAsUser: 1000
      serviceAccountName: jenkins-admin
      containers:
        - name: jenkins
          image: jenkins/jenkins:lts
          resources:
            limits:
              memory: "2Gi"
              cpu: "1000m"
            requests:
              memory: "500Mi"
              cpu: "500m"
          ports:
            - name: httpport
              containerPort: 8080
            - name: jnlpport
              containerPort: 50000
          startupProbe:
            failureThreshold: 12
            httpGet:
              path: '/login'
              port: http
            periodSeconds: 10
            timeoutSeconds: 5
          livenessProbe:
            failureThreshold: 5
            httpGet:
              path: '/login'
              port: http
            initialDelaySeconds: null
            periodSeconds: 10
            timeoutSeconds: 5
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: '/login'
              port: http
            initialDelaySeconds: null
            periodSeconds: 10
            timeoutSeconds: 5
          volumeMounts:
            - mountPath: /var/jenkins_home
              name: jenkins-home
              readOnly: false
      volumes:
        - name: jenkins-home
          persistentVolumeClaim:
            claimName: jenkins-pv-claim
```

5. Expose Jenkins through Load Balancer (Kubernetes Service) named `jenkins-service.yaml`:

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  namespace: jenkins-controller
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/path: /
    prometheus.io/port: "8080"
spec:
  selector:
    app: jenkins-server
  type: LoadBalancer
  ports:
    - port: 8080
      targetPort: 8080
```

6. Apply the created resources via:


```bash
kubectl apply -f *.yaml
```


### Source Code

- [https://github.com/redopsbay/cloudworkshop/tree/master/lab-src/cicd/jenkins/jenkins-setup-k8s](https://github.com/redopsbay/cloudworkshop/tree/master/lab-src/cicd/jenkins/jenkins-setup-k8s)
