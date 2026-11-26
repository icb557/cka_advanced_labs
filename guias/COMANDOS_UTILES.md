# Comandos útiles (sin respuestas)

```bash
kubectl config current-context
kubectl get nodes -o wide
kubectl get pods -A -o wide
kubectl -n NAMESPACE get all
kubectl -n NAMESPACE describe pod NOMBRE
kubectl -n NAMESPACE get events --sort-by=.metadata.creationTimestamp
kubectl -n NAMESPACE logs POD --previous
kubectl -n NAMESPACE get deployment,rs,pods -o wide
kubectl -n NAMESPACE get svc,endpointslices,ingress,networkpolicies
kubectl get pv,storageclasses
kubectl -n NAMESPACE describe pvc NOMBRE
kubectl get priorityclasses
kubectl -n NAMESPACE get hpa
kubectl -n NAMESPACE rollout history deploy/NOMBRE
kubectl -n NAMESPACE rollout status deploy/NOMBRE
kubectl explain deployment.spec.template.spec
kubectl auth can-i list pods -n NAMESPACE
kubectl get nodes --show-labels
kubectl describe node NODE
kubectl api-resources
kubectl kustomize RUTA_OVERLAY
helm list -A
```

No presupongas que `helm`, Metrics API, GatewayClass o un CNI con NetworkPolicy están disponibles; revisa `scripts/preflight.sh`.
