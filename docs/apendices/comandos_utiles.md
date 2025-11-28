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

🛠️ 

