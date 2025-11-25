🏡 Guía de Infraestructura Web Segura y Monitoreada

¡Bienvenido(a) a la documentación de nuestro proyecto de infraestructura!Esta guía exhaustiva detalla la configuración y el despliegue de un entorno robusto y seguro para alojar una aplicación web basada en WordPress. El proyecto se extiende desde la capa de virtualización hasta los servicios de seguridad y monitoreo automatizado.

🎯 Objetivos del Proyecto. 
El objetivo principal de esta documentación es proporcionar un manual paso a paso y reproducible para cualquier persona que desee replicar una pila de hosting web moderno, ligero y seguro, centrado en el uso de Podman y túneles de acceso seguro.
Plataforma Base: Instalar y configurar una máquina virtual (VM) en XO-Lite/XCP-ng con Debian Trixie.
Despliegue Web: Orquestar una aplicación de WordPress utilizando contenedores Podman y podman-compose (NGINX, MariaDB).Seguridad y Acceso: Utilizar Cloudflare Tunnel para exponer el sitio a Internet de forma segura sin abrir puertos del firewall local.
Monitoreo: Implementar un servicio automatizado con arp-scan y cron para escanear periódicamente la infraestructura y notificar cambios de red a través de Postfix.

💻 Tecnologías Utilizadas. Componente Herramienta/Tecnología Función Virtualización XO-Lite, XCP-ng, Debian 12 (Trixie)Host del sistema operativo y capa de gestión de VMs.Contenedores Podman, podman-compose Motor de contenedores daemonless y orquestación.Aplicación Web NGINX, MariaDB, WordPress Stack de servidor web (LEMP/LAMP).Acceso Seguro Cloudflare Tunnel (cloudflared) Conexión segura saliente, eliminando la exposición de puertos.Monitoreo arp-scan, Postfix, Cron Escaneo de red, notificación por correo y automatización de tareas.Documentación MkDocs, Material for MkDocs. Generación del sitio web estático para GitHub Pages.

🗺️ Estructura de la Guía. Utiliza el menú de navegación lateral o superior para seguir el flujo de trabajo lógico del despliegue:
1. Preparación de la Infraestructura: Instalación del hypervisor y la VM.
2. Plataforma Web con Podman: Instalación de Podman y el despliegue del stack de WordPress.
3. Acceso y Seguridad: Configuración de Cloudflare Tunnel para el acceso público.
4. Monitoreo Automatizado: Implementación de la alerta de red y la programación con Cron.Apéndices: Comandos útiles, términos y referencias.
