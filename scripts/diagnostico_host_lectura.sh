#!/usr/bin/env bash
set -euo pipefail
echo '=== Diagnostico de host, solo lectura ==='
if [ -d /etc/kubernetes/manifests ]; then ls -lah /etc/kubernetes/manifests; else echo 'Sin acceso directo a manifests del control plane'; fi
for x in kubeadm crictl etcdctl etcdutl; do if command -v "$x" >/dev/null 2>&1; then "$x" version 2>/dev/null || true; else echo "$x: no disponible"; fi; done
if command -v systemctl >/dev/null 2>&1; then systemctl is-active kubelet 2>/dev/null || true; fi
echo 'Sin escrituras; no ejecuta upgrade ni modifica static Pods.'
