#!/usr/bin/env bash
set -euo pipefail
kubectl get ns | grep '^cka-' || true
kubectl get deployments,pods,svc,hpa,ingress,networkpolicy -A 2>/dev/null | grep 'cka-' || true
