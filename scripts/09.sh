#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 09 | ConfigMap, Secret y HPA inconsistentes ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-09 --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'YAML'
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: cka-av-09
data:
  APP_MODE: staging
---
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
  namespace: cka-av-09
type: Opaque
stringData:
  API_TOKEN: bad
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: cka-av-09
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
        image: busybox:1.36
        command:
        - sh
        - -c
        - test "$APP_MODE" = production && test "$API_TOKEN" = training-token && sleep
          3600 || { echo config-invalida; exit 2; }
        envFrom:
        - configMapRef:
            name: app-config
        - secretRef:
            name: app-secret
        resources:
          requests:
            cpu: 20m
            memory: 16Mi
          limits:
            memory: 64Mi
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
  namespace: cka-av-09
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: wrong-web
  minReplicas: 1
  maxReplicas: 3
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
YAML

echo 'Preparado el reto 09 (CONDICIONAL). Namespace: cka-av-09.'
