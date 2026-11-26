#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 02 | Diagnóstico de static Pod / kube-apiserver ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-02 --dry-run=client -o yaml | kubectl apply -f -
echo 'Ejercicio local de diagnóstico preparado en material/02_control_plane/. No se toca el control plane real.'
cat 'material/02_control_plane/logs.txt'

echo 'Preparado el reto 02 (SIMULADO). Namespace: cka-av-02.'
