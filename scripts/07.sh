#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 07 | Kustomize: overlay con fallo de despliegue ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-07 --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -k material/07_kustomize/overlay

echo 'Preparado el reto 07 (NORMAL). Namespace: cka-av-07.'
