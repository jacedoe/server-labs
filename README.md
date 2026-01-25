# Guía de Infraestructura XenServer, Linux y FreeBSD.

Este repositorio contiene la documentación, configuraciones y scripts para el despliegue de máquinas virtuales (VM) en un entorno XCP-ng, la configuración de un sitio web basado en NGINX, MariaDB, WordPress que será desplegado de manera nativa.

Para este laboratorio se han utilizado las distribuciones Alpine Linux y FreeBSD 15.

Estructura del Proyecto
docs/: Contiene toda la documentación fuente en formato Markdown, la cual será utilizada por MkDocs para generar el sitio web estático.

mkdocs.yml: Archivo de configuración principal para MkDocs.

scripts/: Directorio para almacenar los scripts de configuración y mantenimiento.

compose/: Archivos de configuración para el despliegue de contenedores.

README.md: Resumen general del proyecto (este archivo).

## Componentes Principales de la Infraestructura

### 1. Plataforma de Virtualización: XCP-ng
Objetivo: Instalación y configuración inicial del servidor XCP-ng/XenServer web interface.

Puntos Clave: Instalación del hypervisor base, configuración de red, y preparación del entorno para el despliegue de la máquina virtual invitada (Guest VM).

### 2. Máquina Virtual Invitada
Sistema Operativo
- Instalación y configuración inicial de Alpine Linux.
- Instalación y configuración inicial de FreeBSD.

### 3. Entorno Web en producción en Alpine Linux

nginx: Proxy inverso y servidor web para manejar el tráfico.

hugo: Generador de un sitio web estático

mariadb: Base de datos para almacenar la información de WordPress.

wordpress: Creación de un sitio web totalmente funcional con WordPress.

### 4. Conexión Segura con Cloudflare Tunnel

Registro y configuración inicial en el dashboard de Cloudflare.

Instalación del cliente cloudflared en la VM Debian y Alpine Linux.

Creación del Tunnel (conexión segura saliente).

Configuración de las rutas (CNAME/A records) para mapear el dominio al servicio interno (por ejemplo a NGINX).

Ventajas de usar el Tunnel (eliminación de la apertura de puertos, protección DDoS de Cloudflare).

### 5. Configuración de FreeBSD como servidor
### 6. Respaldo y restauración
