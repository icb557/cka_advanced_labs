# CKA avanzados — 10 retos — enunciados para mentees


**No abras los scripts de preparación hasta terminar.** Este material no incluye respuestas.


Trabaja solo en la terminal desechable de Killercoda. Usa el namespace indicado en cada reto.


| Reto | Tema | Minutos | Modalidad |
|---|---|---:|---|
| 01 | Mantenimiento de nodo: scheduling suspendido | 8 | ALTO |
| 02 | Diagnóstico de static Pod / kube-apiserver | 10 | SIMULADO |
| 03 | Kubeadm: upgrade sin interrumpir servicios | 10 | SIMULADO |
| 04 | NetworkPolicy: frontend sin acceso HTTP | 9 | CONDICIONAL |
| 05 | CoreDNS: resolución interna no funciona | 7 | NORMAL |
| 06 | Ingress y HTTPRoute: backend incorrecto | 9 | CONDICIONAL |
| 07 | Kustomize: overlay con fallo de despliegue | 7 | NORMAL |
| 08 | Helm: release instala pero Pods no Ready | 7 | CONDICIONAL |
| 09 | ConfigMap, Secret y HPA inconsistentes | 10 | CONDICIONAL |
| 10 | Storage: PV disponible pero PVC Pending | 7 | NORMAL |



## Reto 01 — Mantenimiento de nodo: scheduling suspendido


**Área:** Arquitectura / nodos · **Tiempo:** 8 min · **Modo:** ALTO

**Namespace:** `cka-av-01`

**Objetivo verificable:** El Deployment maintenance debe quedar 1/1 Ready en el worker reservado. Recupera la capacidad de scheduling sin eliminar el Deployment.

**Pistas generales permitidas:** kubectl get nodes; kubectl describe node; kubectl describe pods -n cka-av-01; kubectl get events -n cka-av-01

**Preparación del mentor:** `bash scripts/01.sh`

**Nota:** Solo para playground desechable. No ejecutar drain/cordon en entornos compartidos o productivos.


## Reto 02 — Diagnóstico de static Pod / kube-apiserver


**Área:** Control plane / troubleshooting · **Tiempo:** 10 min · **Modo:** SIMULADO

**Namespace:** `cka-av-02`

**Objetivo verificable:** Analiza los logs simulados y corrige ÚNICAMENTE el archivo kube-apiserver.yaml proporcionado. No ejecutes kubectl apply sobre este manifiesto ni modifiques /etc/kubernetes/manifests real.

**Pistas generales permitidas:** cat material/02_control_plane/logs.txt; cat material/02_control_plane/kube-apiserver.yaml; consulta qué observa kubelet al reiniciar un static Pod.

**Preparación del mentor:** `bash scripts/02.sh`

**Nota:** Ejercicio offline deliberado. Los static Pods reales requieren acceso al host y pueden derribar el API server.


## Reto 03 — Kubeadm: upgrade sin interrumpir servicios


**Área:** Ciclo de vida / kubeadm · **Tiempo:** 10 min · **Modo:** SIMULADO

**Namespace:** `cka-av-03`

**Objetivo verificable:** Escribe respuesta.md con una secuencia correcta para actualizar primero control plane y luego un worker (incluye drain, kubeadm, kubelet y uncordon). No ejecutes el runbook.

**Pistas generales permitidas:** cat material/03_kubeadm/runbook.txt; kubeadm upgrade plan --help (si existe); kubectl get nodes -o wide.

**Preparación del mentor:** `bash scripts/03.sh`

**Nota:** NO ejecutar comandos de kubeadm o etcd restore en el playground. El entregable es un runbook corregido.


## Reto 04 — NetworkPolicy: frontend sin acceso HTTP


**Área:** Services y Networking / NetworkPolicy · **Tiempo:** 9 min · **Modo:** CONDICIONAL

**Namespace:** `cka-av-04`

**Objetivo verificable:** El Pod client (role=frontend) debe poder abrir http://web:80. El Pod outsider (role=other) no debe tener acceso cuando el CNI implemente NetworkPolicy. Resuelve sin borrar la política.

**Pistas generales permitidas:** kubectl get pods -o wide; kubectl describe networkpolicy; kubectl exec client -- wget -T 4 -qO- http://web; revisar etiquetas.

**Preparación del mentor:** `bash scripts/04.sh`

**Nota:** Requiere un CNI que ENFORCE NetworkPolicy para verificar bloqueo real. Sin CNI compatible, evaluación de manifiesto solamente; no declarar éxito de aislamiento por mera existencia del recurso.


## Reto 05 — CoreDNS: resolución interna no funciona


**Área:** Services y Networking / DNS · **Tiempo:** 7 min · **Modo:** NORMAL

**Namespace:** `cka-av-05`

**Objetivo verificable:** El Deployment dnsprobe debe resolver kubernetes.default.svc.cluster.local desde dentro de su contenedor, sin modificar los componentes del namespace kube-system.

**Pistas generales permitidas:** kubectl exec POD -- cat /etc/resolv.conf; kubectl exec POD -- nslookup kubernetes.default.svc.cluster.local; kubectl get pods -n kube-system.

**Preparación del mentor:** `bash scripts/05.sh`

**Nota:** 203.0.113.53 pertenece a TEST-NET; NO es un DNS real.


## Reto 06 — Ingress y HTTPRoute: backend incorrecto


**Área:** Networking / Gateway API / Ingress · **Tiempo:** 9 min · **Modo:** CONDICIONAL

**Namespace:** `cka-av-06`

**Objetivo verificable:** La regla de entrada debe referenciar el Service web:80. Corrige el Ingress; si HTTPRoute está instalado, corrige también backendRefs. No se exige tráfico externo si no existe controlador.

**Pistas generales permitidas:** kubectl describe ingress web-edge; kubectl get svc; kubectl get gateway,httproute -A (si existen); kubectl get endpointslices.

**Preparación del mentor:** `bash scripts/06.sh`

**Nota:** Gateway API requiere CRDs y controlador; el lab NO instala GatewayClass ni un Gateway, y solo valida la configuración del backend si hay CRDs.


## Reto 07 — Kustomize: overlay con fallo de despliegue


**Área:** Arquitectura / Kustomize · **Tiempo:** 7 min · **Modo:** NORMAL

**Namespace:** `cka-av-07`

**Objetivo verificable:** El overlay material/07_kustomize/overlay debe desplegar web Ready 1/1. Mantén la estructura base/overlay y corrige únicamente los archivos necesarios.

**Pistas generales permitidas:** kubectl kustomize material/07_kustomize/overlay; kubectl -n cka-av-07 describe pods; kubectl -n cka-av-07 get deployment web -o yaml

**Preparación del mentor:** `bash scripts/07.sh`


## Reto 08 — Helm: release instala pero Pods no Ready


**Área:** Arquitectura / Helm · **Tiempo:** 7 min · **Modo:** CONDICIONAL

**Namespace:** `cka-av-08`

**Objetivo verificable:** Repara el chart material/08_helm y actualiza la release av08 sin borrar el namespace. El Deployment debe estar Ready y helm status sin fallo.

**Pistas generales permitidas:** helm list -n cka-av-08; helm status av08 -n cka-av-08; helm get values av08 -n cka-av-08; helm template av08 material/08_helm; kubectl -n cka-av-08 describe pods

**Preparación del mentor:** `bash scripts/08.sh`

**Nota:** Se requiere Helm CLI disponible; el paquete no instala binarios automáticamente.


## Reto 09 — ConfigMap, Secret y HPA inconsistentes


**Área:** Workloads / configuración / HPA · **Tiempo:** 10 min · **Modo:** CONDICIONAL

**Namespace:** `cka-av-09`

**Objetivo verificable:** La aplicación web debe permanecer Ready con APP_MODE=production y API_TOKEN correcto; el HPA debe apuntar a web y mantener min=1/max=3. No se exige métricas CPU si falta metrics-server.

**Pistas generales permitidas:** kubectl describe pods; kubectl logs deploy/web --previous; kubectl get configmap,secret,hpa; kubectl describe hpa web-hpa.

**Preparación del mentor:** `bash scripts/09.sh`

**Nota:** La evaluación de scaleTargetRef sí es posible sin metrics-server; escalado real no verificable sin Metrics API.


## Reto 10 — Storage: PV disponible pero PVC Pending


**Área:** Storage / PV-PVC-StorageClass · **Tiempo:** 7 min · **Modo:** NORMAL

**Namespace:** `cka-av-10`

**Objetivo verificable:** Consigue que el PVC web-data esté Bound al PV del ejercicio y que storage-app esté Running/Ready. Conserva el PV y sus datos.

**Pistas generales permitidas:** kubectl get pv; kubectl -n cka-av-10 describe pvc web-data; kubectl -n cka-av-10 describe pod storage-app; kubectl get sc.

**Preparación del mentor:** `bash scripts/10.sh`

**Nota:** PV hostPath es exclusivo para laboratorio. La solución recrea PVC porque storageClassName es inmutable tras el binding/provisioning según caso.