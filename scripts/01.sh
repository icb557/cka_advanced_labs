#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 01 | Mantenimiento de nodo: scheduling suspendido ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-01 --dry-run=client -o yaml | kubectl apply -f -
WORKER="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')"
[ -n "$WORKER" ] || { echo 'Necesitas al menos un worker. Ejercicio no preparado.' >&2; exit 2; }
kubectl label node "$WORKER" cka-av01=target --overwrite
kubectl cordon "$WORKER"
kubectl apply -f - <<'YAML'
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: maintenance
  namespace: cka-av-01
spec:
  replicas: 1
  selector:
    matchLabels:
      app: maintenance
  template:
    metadata:
      labels:
        app: maintenance
    spec:
      containers:
      - name: app
        image: nginx:1.27
      nodeSelector:
        cka-av01: target
YAML

echo 'Preparado el reto 01 (ALTO). Namespace: cka-av-01.'
