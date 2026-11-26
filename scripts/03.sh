#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 03 | Kubeadm: upgrade sin interrumpir servicios ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-03 --dry-run=client -o yaml | kubectl apply -f -
echo 'Actividad offline. Lee material/03_kubeadm/runbook.txt y redacta material/03_kubeadm/respuesta.md.'

echo 'Preparado el reto 03 (SIMULADO). Namespace: cka-av-03.'
