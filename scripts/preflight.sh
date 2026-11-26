#!/usr/bin/env bash
set -euo pipefail
echo '--- Contexto ---'
kubectl config current-context
kubectl version --client
kubectl get nodes -o wide
echo '--- Componentes ---'
kubectl get pods -n kube-system || true
echo '--- Herramientas ---'
for bin in kubectl helm python3; do
  if command -v "$bin" >/dev/null 2>&1; then echo "$bin: OK"; else echo "$bin: NO DISPONIBLE"; fi
done
echo '--- Gateway API (CRDs) ---'
kubectl api-resources --api-group=gateway.networking.k8s.io 2>/dev/null || true
echo '--- Metrics API ---'
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes >/dev/null 2>&1 && echo 'Metrics API: disponible' || echo 'Metrics API: no detectada'
echo '--- CNI ---'
kubectl -n kube-system get daemonsets 2>/dev/null || true
echo 'Nota: listar NetworkPolicy NO demuestra enforcement del CNI.'
echo 'Nota: acceso al host /etc/kubernetes/manifests, kubeadm y etcd NO se presupone.'
