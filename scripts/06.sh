#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 06 | Ingress y HTTPRoute: backend incorrecto ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-06 --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'YAML'
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: cka-av-06
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
  namespace: cka-av-06
spec:
  selector:
    app: web
  ports:
  - name: http
    port: 80
    targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-edge
  namespace: cka-av-06
spec:
  rules:
  - host: web.av06.test
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-wrong
            port:
              number: 80
YAML
if kubectl api-resources --api-group=gateway.networking.k8s.io -o name 2>/dev/null | grep -qx 'httproutes.gateway.networking.k8s.io'; then
   echo 'HTTPRoute CRD detectada: preparando recurso adicional (el Gateway real depende del controlador).'
   kubectl apply -f material/06_route/gateway_httproute.yaml || true
else
   echo 'Sin Gateway API CRD: ejercicio principal Ingress; HTTPRoute queda como manifiesto para análisis.'
fi

echo 'Preparado el reto 06 (CONDICIONAL). Namespace: cka-av-06.'
