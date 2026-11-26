#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 08 | Helm: release instala pero Pods no Ready ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-08 --dry-run=client -o yaml | kubectl apply -f -
if ! command -v helm >/dev/null 2>&1; then
  echo 'REQUIERE HELM: no se prepara este reto. Usa un Killercoda con Helm o instalación temporal autorizada.' >&2
  exit 2
fi
helm upgrade --install av08 material/08_helm --namespace cka-av-08 --wait=false

echo 'Preparado el reto 08 (CONDICIONAL). Namespace: cka-av-08.'
