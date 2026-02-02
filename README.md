🚀 Server Labs: Infraestructura Híbrida sobre XCP-ng

Este repositorio documenta el despliegue, configuración y mantenimiento de un ecosistema de servidores nativos sobre Alpine Linux, optimizados para el hosting de aplicaciones estáticas (Hugo) y dinámicas (WordPress), con acceso seguro mediante Cloudflare Tunnel.
🏗️ Arquitectura del Sistema

La infraestructura se basa en la eficiencia y la seguridad "Zero Trust", eliminando la exposición directa de puertos al exterior.
1. Capa de Virtualización (Hypervisor)

    XCP-ng: Servidor de virtualización empresarial basado en Xen. Elegido por su estabilidad y gestión de recursos críticos.

    Estrategia: Segmentación de servicios en VMs ligeras para facilitar backups y escalabilidad.

2. Sistema Base (OS)

    Alpine Linux: Instalación nativa (no-containerized).

    Justificación: Consumo mínimo de RAM (apenas 50MB en reposo), superficie de ataque reducida y gestión mediante OpenRC.

    Servicios: Nginx (Web), PHP 8.4 (Procesamiento), MariaDB (Datos), Cloudflared (Acceso).

3. Stack de Aplicaciones

    Sitio Principal: merceponsautora.com - Generado con Hugo (Estático). Servido en puerto 8080.

    Blog: blog.merceponsautora.com - Implementado en WordPress (Dinámico). Servido en puerto 80 vía PHP-FPM 8.4 (Unix Socket).

🔒 Conectividad y Seguridad

El tráfico se gestiona mediante un Cloudflare Tunnel nativo, lo que permite:

    Ocultar la IP pública del servidor.

    Gestión de SSL/TLS automática desde el borde (Edge).

    Configuración de reglas de acceso sin necesidad de abrir puertos en el firewall local.

🛠️ Guía de Despliegue Rápido (Cheatsheet)
Instalación de dependencias en Alpine:
Bash

apk update
apk add nginx php84-fpm php84-mysqli mariadb cloudflared

Gestión de servicios (OpenRC):
Bash

rc-service nginx start
rc-service php-fpm84 start
rc-service cloudflared start

Backup Automatizado:

El sistema cuenta con un script en /usr/local/bin/backup_mercepons.sh que realiza snapshots diarios de la DB y los archivos de Hugo, manteniendo una rotación de 7 días.
🔮 Futuro y Portabilidad

Este proyecto ha sido diseñado bajo el principio de agnosticismo de plataforma. Aunque actualmente reside en Alpine Linux, la configuración nativa (sin la opacidad de Docker) facilita la migración hacia:

FreeBSD: Aprovechando Jails y ZFS para una mayor integridad de datos.

Otras Distros: Migración directa de los archivos de configuración de Nginx y PHP-FPM.

"La simplicidad es la máxima sofisticación." — Este laboratorio es la prueba de que un stack nativo bien configurado supera en rendimiento y mantenimiento a soluciones más complejas.