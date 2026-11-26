#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 04 | NetworkPolicy: frontend sin acceso HTTP ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-04 --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'YAML'
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: cka-av-04
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: app
        image: nginx:1.27
---
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: cka-av-04
spec:
  selector:
    app: web
  ports:
  - name: http
    port: 80
    targetPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: client
  namespace: cka-av-04
  labels:
    role: frontend
spec:
  containers:
  - name: app
    image: busybox:1.36
    command:
    - sh
    - -c
    - sleep 3600
---
apiVersion: v1
kind: Pod
metadata:
  name: outsider
  namespace: cka-av-04
  labels:
    role: other
spec:
  containers:
  - name: app
    image: busybox:1.36
    command:
    - sh
    - -c
    - sleep 3600
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: web-ingress
  namespace: cka-av-04
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: ops
    ports:
    - protocol: TCP
      port: 80
YAML

echo 'Preparado el reto 04 (CONDICIONAL). Namespace: cka-av-04.'
