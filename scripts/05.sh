#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 05 | CoreDNS: resolución interna no funciona ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-05 --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'YAML'
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dnsprobe
  namespace: cka-av-05
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dnsprobe
  template:
    metadata:
      labels:
        app: dnsprobe
    spec:
      containers:
      - name: app
        image: busybox:1.36
        command:
        - sh
        - -c
        - sleep 3600
      dnsPolicy: None
      dnsConfig:
        nameservers:
        - 203.0.113.53
YAML

echo 'Preparado el reto 05 (NORMAL). Namespace: cka-av-05.'
