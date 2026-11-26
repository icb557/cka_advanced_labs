# CKA avanzados — 10 retos

Versión 2026-11. Paquetes destinados a Killercoda (Kubernetes Playground), **NO** Kind.

## Antes de comenzar

1. Abrir un playground desechable de Kubernetes en Killercoda.
2. Llevar el contenido del ZIP al terminal del playground (cargar el archivo, pegar contenido o alojarlo en un repositorio autorizado). No hay conexión automática entre el ZIP descargado en ChatGPT y la terminal web de Killercoda.
3. Entrar a la carpeta raíz y ejecutar `bash scripts/preflight.sh`.
4. Preparar un reto por vez: `bash scripts/01.sh` (cambia el número del ejercicio).
5. Consultar `guias/ENUNCIADOS.md`. Resolver sin mirar los scripts de creación. Para investigar, usar `kubectl get`, `describe`, `logs`, `events`, YAML, `kubectl explain`.
6. Limpiar uno: `bash scripts/limpiar.sh 01`; todos: `bash scripts/limpiar.sh all`.

### Advertencias

- No ejecutar en producción ni en un clúster compartido.
- Los casos de control plane y kubeadm son **simulaciones de diagnóstico sobre archivos locales**. El setup no toca los manifests reales `/etc/kubernetes/manifests` ni ejecuta upgrades de kubeadm.
- NetworkPolicy requiere CNI compatible para aplicar aislamiento real; de lo contrario solo se evalúa la configuración.
- Ingress/HTTPRoute requiere controlador para probar tráfico real; el paquete permite validar objetos aun sin controlador.
- Helm requiere el binario `helm` disponible; sin él los ejercicios Helm quedan **no evaluables**, no fallas de los alumnos.
- HPA requiere Metrics API para demostrar escalado; sus campos se pueden revisar sin ella.
- Un worker es necesario para pruebas de scheduling. `scripts/preflight.sh` reporta capacidades.
- Revisa la **duración máxima de tu sesión de Killercoda** antes de intentar 120 minutos continuos: los playgrounds pueden caducar y perder los recursos. Si el entorno no dura 120 minutos, divide el simulacro en dos bloques o usa un entorno persistente.
- Las imágenes nginx/busybox necesitan acceso al registro desde los nodos. En caso de problemas de descarga ajenos al laboratorio, no puntuar como falla del alumno.

## Archivos

- `guias/ENUNCIADOS.md`: objetivos para mentees, sin respuestas.
- `scripts/NN.sh`: crea cada escenario de falla (no consultarlo durante la evaluación).
- `scripts/preflight.sh`: inventario no destructivo.
- `scripts/estado.sh`: inventario de recursos del paquete.
- `scripts/limpiar.sh NN`: limpia solo un escenario.
- `material/`: chart Helm, overlay Kustomize y material de simulación, según el reto.

### Puntuación

Resolver por parejas primero; después repetir individualmente sin pistas. Diagnóstico 30%, reparación 40%, evidencia 30%.

Referencias:
- https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/
- https://kubernetes.io/docs/
- https://gateway-api.sigs.k8s.io/
