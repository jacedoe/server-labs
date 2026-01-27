🐳 Gestión de Contenedores (Podman)

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
🛡️ Cloudflared

Estos comandos se ejecutan en la VM Debian para verificar el estado de los servicios.

A. Cloudflare Tunnel
Verificar el estado del servicio cloudflared:
```
sudo systemctl status cloudflared
```
Ver logs del servicio cloudflared:
```
sudo journalctl -u cloudflared -f