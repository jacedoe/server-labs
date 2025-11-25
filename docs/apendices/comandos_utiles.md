🛠️ Comandos Útiles y de Referencia
Este apéndice contiene una lista de comandos esenciales para la gestión diaria y la solución de problemas (troubleshooting) de los componentes clave de la infraestructura.

1. ⚙️ Gestión de la Máquina Virtual (XO-Lite/XCP-ng Console)
Estos comandos se ejecutan en la consola de root del servidor XCP-ng (el host de virtualización, no dentro de la VM Debian).

Verificar el estado del host:
```
xe host-list
```
Verificar el estado de las VMs:
```
xe vm-list
```
Encender una VM (usando el nombre):
```
xe vm-start vm=[Nombre de la VM]
```
Apagar una VM (apagado limpio):
```
xe vm-shutdown vm=[Nombre de la VM]
```
Verificar el estado de los Storage Repositories (SR):
```
xe sr-list
```
2. 🐳 Gestión de Contenedores (Podman)
Estos comandos se ejecutan dentro de la VM Debian como tu usuario estándar (admin), en modo rootless.

Verificar todos los contenedores (activos e inactivos):
```
podman ps -a
```
Verificar todas las imágenes descargadas:
```
podman images
```
Verificar las redes de Podman:
```
podman network ls
```
Detener el stack completo (en el directorio del podman-compose.yml):
```
podman-compose down
```
Reiniciar el stack:
```
podman-compose restart
```
Ver logs de un contenedor (ej: WordPress):
```
podman logs -f wordpress_app
```
Ejecutar un comando dentro de un contenedor (ej:   en NGINX):
```
podman exec -it nginx_proxy /bin/ 
```
Limpiar contenedores y volúmenes no utilizados (¡Usar con precaución!):
```
podman system prune
```
3. 🛡️ Monitoreo y Correo (Postfix/Cron/Cloudflared)
Estos comandos se ejecutan en la VM Debian para verificar el estado de los servicios de monitoreo y acceso seguro.

A. Cloudflare Tunnel
Verificar el estado del servicio cloudflared:
```
sudo systemctl status cloudflared
```
Ver logs del servicio cloudflared:
```
sudo journalctl -u cloudflared -f
```
B. Postfix (Correo)
Verificar la cola de correo (mensajes pendientes de envío):
```
mailq
```
Vaciar la cola de correo (forzar el envío):
```
sudo postfix flush
```
Verificar los logs de correo:
```
tail -f /var/log/mail.log
```
C. Cron y Escaneo
Verificar la crontab de root:
```
sudo crontab -l
```
Ejecutar el script de escaneo manualmente (para pruebas):
```
sudo /home/admin/scripts/infra-scan/infra_scan.sh
```
Verificar el log de escaneo:
```
tail -f /home/admin/scripts/infra-scan/scan_log.txt
```
# 🐳 Características Clave de Podman
Podman destaca por su enfoque en la seguridad y la arquitectura descentralizada.

1. ## Arquitectura Sin Demonio (Daemonless)Seguridad: A diferencia de Docker, Podman no utiliza un demonio central (daemon) que se ejecuta como root. En su lugar, utiliza un modelo de arquitectura fork-exec, donde el comando podman inicia directamente el proceso del contenedor, que a su vez utiliza runc (el tiempo de ejecución OCI).Ventaja: Esto elimina el riesgo de que un atacante que comprometa el daemon obtenga privilegios de root en el sistema operativo host.

2. ## Contenedores Sin Privilegios (Rootless Containers)Seguridad: La característica más destacada de Podman es su capacidad para ejecutar contenedores como un usuario normal, sin requerir privilegios de root.Funcionamiento: Esto se logra utilizando los namespaces de usuario de Linux, mapeando el UID de root dentro del contenedor a un UID sin privilegios en el sistema host. Si el contenedor es comprometido, el atacante solo tiene los bajos privilegios del usuario host.

3. ## Soporte para PodsOrquestación Local: Podman es compatible con la idea de Pods, una característica central de Kubernetes. Un Pod es un grupo de uno o más contenedores que comparten recursos como el namespace de red, el almacenamiento local y el IPC.Kubernetes: Podman puede generar archivos YAML de Kubernetes directamente a partir de contenedores o Pods en ejecución, simplificando la transición del desarrollo local a la orquestación en clústeres.4. Compatibilidad con DockerInterfaz CLI: Podman utiliza comandos idénticos o casi idénticos a los de Docker (por ejemplo, podman run, podman ps, podman images), lo que permite a los usuarios con experiencia en Docker cambiar a Podman rápidamente.Imágenes: Podman puede usar y construir imágenes de contenedor compatibles con Docker y OCI.

🛠️ Comandos Básicos de PodmanLa CLI de Podman es intuitiva y compatible con los flujos de trabajo de Docker:TareaComando de PodmanDescripciónEjecutarpodman run [OPCIONES] [IMAGEN]Crea y ejecuta un nuevo contenedor a partir de una imagen.Listarpodman ps -aMuestra todos los contenedores (activos e inactivos).Imágenespodman imagesMuestra las imágenes descargadas localmente.Detenerpodman stop [NOMBRE/ID]Detiene un contenedor en ejecución.Eliminarpodman rm [NOMBRE/ID]Elimina un contenedor detenido.Logspodman logs -f [NOMBRE/ID]Muestra la salida de registro de un contenedor en tiempo real.Crear Podpodman pod create [OPCIONES]Crea un nuevo Pod para agrupar contenedores.🆚 Podman vs. Docker (Resumen)CaracterísticaPodmanDockerArquitecturaSin demonio (Daemonless). Comunicación directa con runc.Requiere un demonio (Docker Daemon) que se ejecuta como root.SeguridadAlto, centrado en el modo Rootless (sin privilegios de root).Requiere root para la gestión del daemon.OrquestaciónSoporte nativo para Pods (Kubernetes).Se basa en Docker Compose o herramientas externas (Kubernetes/Swarm).IntegraciónIntegración nativa con Systemd de Linux para el ciclo de vida de los contenedores.Requiere envoltorios o configuraciones externas para Systemd.Podman es especialmente valorado en entornos de alta seguridad y para desarrolladores que desean una forma sencilla y segura de replicar entornos de Kubernetes de forma local.

