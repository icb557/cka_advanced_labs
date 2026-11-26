#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo '=== Preparación AV 10 | Storage: PV disponible pero PVC Pending ==='
command -v kubectl >/dev/null || { echo 'Falta kubectl.' >&2; exit 2; }
kubectl cluster-info >/dev/null || { echo 'No hay API Kubernetes accesible.' >&2; exit 2; }
kubectl create namespace cka-av-10 --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'YAML'
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cka-av10-pv
spec:
  capacity:
    storage: 200Mi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ''
  hostPath:
    path: /tmp/cka-av10-storage
    type: DirectoryOrCreate
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: web-data
  namespace: cka-av-10
spec:
  storageClassName: class-that-does-not-exist
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: storage-app
  namespace: cka-av-10
spec:
  containers:
  - name: app
    image: busybox:1.36
    command:
    - sh
    - -c
    - sleep 3600
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: web-data
YAML

echo 'Preparado el reto 10 (NORMAL). Namespace: cka-av-10.'
