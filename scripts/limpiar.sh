#!/usr/bin/env bash
set -euo pipefail
ARG="${1:-}"
PREFIX="av"
if [ -z "$ARG" ]; then echo "Uso: bash scripts/limpiar.sh NN|all"; exit 2; fi
if [ "$ARG" = all ]; then IDS="01 02 03 04 05 06 07 08 09 10"; else IDS="$ARG"; fi
for id in $IDS; do
  case "$id" in
    01)
      kubectl delete namespace cka-av-01 --ignore-not-found --wait=false || true
      WORKER="$(kubectl get nodes -l 'cka-av01=target' -o jsonpath='{.items[0].metadata.name}')"
      [ -z "$WORKER" ] || { kubectl uncordon "$WORKER" >/dev/null 2>&1 || true; kubectl label node "$WORKER" cka-av01- >/dev/null 2>&1 || true; }
      ;;
    02)
      kubectl delete namespace cka-av-02 --ignore-not-found --wait=false || true
      ;;
    03)
      kubectl delete namespace cka-av-03 --ignore-not-found --wait=false || true
      ;;
    04)
      kubectl delete namespace cka-av-04 --ignore-not-found --wait=false || true
      ;;
    05)
      kubectl delete namespace cka-av-05 --ignore-not-found --wait=false || true
      ;;
    06)
      kubectl delete namespace cka-av-06 --ignore-not-found --wait=false || true
      ;;
    07)
      kubectl delete namespace cka-av-07 --ignore-not-found --wait=false || true
      ;;
    08)
      kubectl delete namespace cka-av-08 --ignore-not-found --wait=false || true
      ;;
    09)
      kubectl delete namespace cka-av-09 --ignore-not-found --wait=false || true
      ;;
    10)
      kubectl delete namespace cka-av-10 --ignore-not-found --wait=false || true
      kubectl delete pv cka-av10-pv --ignore-not-found --wait=false
      ;;
    *) echo "Reto $id invalido" >&2; exit 2 ;;
  esac
done
echo "Limpieza solicitada. Verifica recursos dependientes si el API demora."
