# Guía de Infraestructura XenServer, Linux y contenedores.

Este repositorio contiene la documentación, configuraciones y scripts para el despliegue de máquinas virtuales (VM) en un entorno XCP-ng, la configuración de un sitio web basado en NGINX, MariaDB, WordPress que será desplegado de manera nativa.
Asimismo se desplegarán contenedores Podman (Debian) o Docker (Alpine Linux) para desarrollo.

Para este laboratorio se han utilizado las distribuciones Alpine Linux y Debian Trixie.

Estructura del Proyecto
docs/: Contiene toda la documentación fuente en formato Markdown, la cual será utilizada por MkDocs para generar el sitio web estático.

mkdocs.yml: Archivo de configuración principal para MkDocs.

scripts/: Directorio para almacenar los scripts de configuración y mantenimiento.

podman-compose/: Archivos de configuración para el despliegue de contenedores.

README.md: Resumen general del proyecto (este archivo).

## Componentes Principales de la Infraestructura

### 1. Plataforma de Virtualización: XCP-ng
Objetivo: Instalación y configuración inicial del servidor XCP-ng/XenServer web interface.

Puntos Clave: Instalación del hypervisor base, configuración de red, y preparación del entorno para el despliegue de la máquina virtual invitada (Guest VM).

### 2. Máquina Virtual Invitada
Sistema Operativo
- Instalación y configuración inicial de Debian 13 "Trixie".
- Instalación y configuración inicial de Alpine Linux.

### 3. Entorno Web con Contenedores Podman para pruebas en Debian
- Preparación del stack con Podman
- Despliegue del sitio web con Wordpress

### 4. Entorno Web en producción en Alpine Linux

#### Servicios

nginx: Proxy inverso y servidor web para manejar el tráfico.

hugo: Generador de un sitio web estático

mariadb: Base de datos para almacenar la información de WordPress.

wordpress: Creación de un sitio web totalmente funcional con WordPress.

### 5. Conexión Segura con Cloudflare Tunnel

Registro y configuración inicial en el dashboard de Cloudflare.

Instalación del cliente cloudflared en la VM Debian y Alpine Linux.

Creación del Tunnel (conexión segura saliente).

Configuración de las rutas (CNAME/A records) para mapear el dominio al servicio interno (por ejemplo a NGINX).

Ventajas de usar el Tunnel (eliminación de la apertura de puertos, protección DDoS de Cloudflare).

### 4. Desarrollo con Docker en Alpine Linux

- Plex Media Server
- Torproxy
- Privoxy
