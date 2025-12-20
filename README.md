# Infraestructura VM con XO-Lite, Nginx, Podman y Docker.

Este repositorio contiene la documentación, configuraciones y scripts para el despliegue de máquinas virtuales (VM) en un entorno XO-Lite, la configuración de un sitio web basado en NGINX, MariaDB, WordPress que será desplegado de manera nativa.
Asimismo se desplegarán contenedores Podman (Debian) o Docker (Alpine Linux) para desarrollo.

Para este laboratorio se han utilizado las distribuciones Alpine Linux y Debian Trixie.

Estructura del Proyecto
docs/: Contiene toda la documentación fuente en formato Markdown, la cual será utilizada por MkDocs para generar el sitio web estático.

mkdocs.yml: Archivo de configuración principal para MkDocs.

scripts/: Directorio para almacenar los scripts de configuración y mantenimiento.

podman-compose/: Archivos de configuración para el despliegue de contenedores.

README.md: Resumen general del proyecto (este archivo).

## Componentes Principales de la Infraestructura
### 1. Plataforma de Virtualización: XO-Lite
Objetivo: Instalación y configuración inicial del servidor XO-Lite (XCP-ng/XenServer web interface).

Puntos Clave: Instalación del hypervisor base, configuración de red, y preparación del entorno para el despliegue de la máquina virtual invitada (Guest VM).

### 2. Máquina Virtual Invitada
Sistema Operativo
- Instalación y configuración inicial de Debian 13 "Trixie".
- Instalación y configuración inicial de Alpine Linux.

### 3. Entorno Web con Contenedores Podman

#### Servicios

nginx: Proxy inverso y servidor web para manejar el tráfico.

mariadb: Base de datos para almacenar la información de WordPress.

wordpress: Creación de un sitio web totlamente funcional con WordPress.

### 3. Conexión Segura con Cloudflare Tunnel

Registro y configuración inicial en el dashboard de Cloudflare.

Instalación del cliente cloudflared en la VM Debian.

Creación del Tunnel (conexión segura saliente).

Configuración de las rutas (CNAME/A records) para mapear el dominio al servicio interno (por ejemplo a NGINX).

Ventajas de usar el Tunnel (eliminación de la apertura de puertos, protección DDoS de Cloudflare).

### 4. Podman y Docker

Puntos Clave: Creación de volúmenes persistentes, configuración de redes internas de Podman y Docker, y el archivo compose.yml para la orquestación de los servicios.