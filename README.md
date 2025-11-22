🚀 infraestructura VM con XO-Lite, Podman y Servicios de Monitoreo
Este repositorio contiene la documentación, configuraciones y scripts para el despliegue de una máquina virtual (VM) en un entorno XO-Lite, la configuración de un sitio web basado en contenedores Podman (NGINX, MariaDB, WordPress) y la implementación de un servicio automatizado de escaneo de red de la infraestructura.

El objetivo final de esta documentación es servir como una guía práctica y reproducible para configurar un entorno de desarrollo web y de monitoreo simple.

🗺️ Estructura del Proyecto
docs/: Contiene toda la documentación fuente en formato Markdown, la cual será utilizada por MkDocs para generar el sitio web estático.

mkdocs.yml: Archivo de configuración principal para MkDocs.

scripts/: Directorio para almacenar los scripts de configuración y mantenimiento.

infra-scan/: Script de escaneo de infraestructura (arp-scan, postfix, cron).

podman-compose/: Archivos de configuración para el despliegue de contenedores.

README.md: Resumen general del proyecto (este archivo).

⚙️ Componentes Principales de la Infraestructura
1. Plataforma de Virtualización: XO-Lite
Objetivo: Instalación y configuración inicial del servidor XO-Lite (XCP-ng/XenServer web interface).

Puntos Clave: Instalación del hypervisor base, configuración de red, y preparación del entorno para el despliegue de la máquina virtual invitada (Guest VM).

2. Máquina Virtual Invitada: Debian Trixie
Sistema Operativo: Instalación y configuración inicial de Debian 12 "Trixie".

Puntos Clave: Configuración de usuarios, actualización del sistema, instalación de dependencias necesarias (como podman), y configuración de firewall.

3. Entorno Web con Contenedores Podman
Se utiliza Podman como alternativa a Docker para el manejo de contenedores, y podman-compose para el despliegue de servicios multi-contenedor.

Servicios:

nginx: Contenedor proxy inverso y servidor web para manejar el tráfico.

mariadb: Contenedor de base de datos para almacenar la información de WordPress.

wordpress: Contenedor de la aplicación WordPress.

Puntos Clave: Creación de volúmenes persistentes, configuración de redes internas de Podman, y el archivo podman-compose.yml para la orquestación de los servicios.

4. Servicio de Monitoreo de Infraestructura
Script automatizado para el escaneo de la red local y notificación de cambios.

Herramientas:

arp-scan: Utilizado para escanear la subred y obtener las direcciones MAC e IP de los dispositivos conectados.

Script Bash: Lógica para comparar los resultados del escaneo actual con un estado anterior (lista de dispositivos conocidos).

postfix: Configurado como agente de transferencia de correo (MTA) simple para enviar notificaciones por correo electrónico.

cron: Programador de tareas para ejecutar el script de escaneo periódicamente (ej: cada 5 minutos o diariamente).

Puntos Clave: Instalación y configuración de postfix, creación del script de escaneo, y la entrada en la tabla de crontab.

¡Excelente! Incorporar Cloudflare Tunnel es un paso crucial para la seguridad y la accesibilidad, eliminando la necesidad de abrir puertos en el firewall.

Aquí tienes el esquema de la documentación (docs/) para MkDocs, incluyendo el nuevo paso de Cloudflare Tunnel, y con una estructura que facilitará la navegación de tu guía.

📚 Estructura Detallada de la Documentación (MkDocs)
Tu archivo principal de configuración, mkdocs.yml, deberá referenciar esta estructura en la sección nav: para crear el menú de navegación.

1. 🏡 Introducción y Preparación
index.md (Página de Inicio)

Resumen del proyecto, tecnologías utilizadas y objetivos.

Requisitos previos de hardware/software.

preparacion/instalacion_xo_lite.md

Proceso de instalación del hypervisor (XCP-ng/XenServer).

Acceso e instalación del frontend XO-Lite.

Configuración inicial de storage y redes.

preparacion/despliegue_vm_debian.md

Creación de la VM con Debian Trixie en XO-Lite.

Instalación del sistema operativo.

Configuración de red estática, hostname y usuarios.

Instalación de paquetes esenciales y actualización.

2. 🐳 Contenedores y Plataforma Web (Podman)
web/preparacion_podman.md

Instalación de Podman y podman-compose en Debian Trixie.

Configuración de usuarios sin privilegios (rootless) para Podman.

Conceptos básicos de redes y volúmenes en Podman.

web/despliegue_wordpress.md

Creación de la estructura de directorios y volúmenes.

Explicación detallada del archivo podman-compose.yml (NGINX, MariaDB, WordPress).

Pasos para el despliegue de los contenedores (podman-compose up -d).

Verificación inicial del funcionamiento interno del sitio web.

3. 🔒 Conexión Segura con Cloudflare Tunnel
seguridad/cloudflare_tunnel.md

Registro y configuración inicial en el dashboard de Cloudflare.

Instalación del cliente cloudflared en la VM Debian.

Creación del Tunnel (conexión segura saliente).

Configuración de las rutas (CNAME/A records) para mapear el dominio al servicio interno (por ejemplo, el contenedor NGINX).

Ventajas de usar el Tunnel (eliminación de la apertura de puertos, protección DDoS de Cloudflare).

4. 🛡️ Monitoreo de Infraestructura
monitoreo/instalacion_postfix.md

Instalación y configuración de un servicio de envío de correo (relay) simple con Postfix.

Prueba de envío de correos de notificación.

monitoreo/script_arp_scan.md

Instalación de la herramienta arp-scan.

Desarrollo y explicación del script Bash:

Obtención de la lista actual de dispositivos.

Comparación con un archivo de "estado conocido".

Lógica para determinar si ha habido un cambio (dispositivo nuevo/desaparecido).

Implementación de la notificación vía mail (usando Postfix) en caso de cambio.

monitoreo/programacion_cron.md

Configuración de la tarea en crontab para la ejecución periódica del script.

Verificación del correcto funcionamiento de la tarea programada.

5. 🛠️ Apéndices
apendices/comandos_utiles.md

Lista de comandos comunes para Podman, XO-Lite y mantenimiento de Debian.
