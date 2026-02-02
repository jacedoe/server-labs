

🌐 Arquitectura de Servidor: merceponsautora

Esta sección documenta la implementación nativa en Alpine Linux para la infraestructura de la escritora Merce Pons.
Esquema de Flujo de Datos
1. Configuración de Nginx

La configuración se divide en dos bloques lógicos para optimizar el rendimiento y la seguridad.
A. Sitio Principal (Hugo - Estático)

    Puerto: 8080 (Configurado para recibir tráfico del Túnel de Cloudflare).

    Directorio raíz: /var/www/mercepons/public.

    Estrategia: Entrega directa de archivos con fallback 404. Al ser Hugo, no requiere procesamiento de lenguaje de lado del servidor, lo que garantiza una carga instantánea.

B. Blog (WordPress - Dinámico)

    Puerto: 80.

    Procesamiento PHP: Se utiliza PHP-FPM 8.4 a través de un socket Unix (/var/run/php-fpm84.sock), lo cual es más eficiente que TCP en instalaciones nativas de Alpine.

    Parámetros Críticos de Proxy: * fastcgi_param HTTPS on;: Crucial para evitar bucles de redirección (Mixed Content) ya que SSL termina en Cloudflare.

        HTTP_X_FORWARDED_PROTO: Permite que WordPress reconozca que el usuario final navega de forma segura.

2. Manual de Mantenimiento (SysAdmin)
Gestión de Servicios en Alpine (OpenRC)

## Reiniciar Nginx tras cambios en la config
```
rc-service nginx restart
```

## Verificar que el socket de PHP-FPM esté activo
```
ls -l /var/run/php-fpm84.sock
```

## Logs de error en tiempo real
```
tail -f /var/log/nginx/error.log
```

Despliegue de Actualizaciones

    Hugo: Al ejecutar hugo, el contenido se sincroniza con /var/www/mercepons/public.

    WordPress: El núcleo y plugins se mantienen mediante el panel o wp-cli nativo en Alpine.

3. Optimizaciones Implementadas

    Caché Agresiva: Se ha configurado un tiempo de expiración máximo (expires max) para archivos estáticos (js, css, imágenes), reduciendo la latencia y el ancho de banda del servidor.

    Seguridad: Bloqueo explícito de archivos .htaccess y archivos ocultos, reduciendo la superficie de ataque.

    Silencio de Logs: Se desactivan los logs para favicon.ico y robots.txt para evitar el llenado innecesario de archivos de log.

🛠️ Paso 1: Instalación del paquete

Como Alpine es minimalista, primero asegúrate de tener los repositorios actualizados.
Bash

## Actualizar índices de paquetes
```
apk update
```
## Instalar nginx
```
apk add nginx
```

⚙️ Paso 2: Gestión del Servicio (OpenRC)

Alpine no usa systemd, usa OpenRC. Estos son los comandos que necesitas para que Nginx arranque siempre con el servidor:
Bash

## Añadir Nginx al inicio automático
```
rc-update add nginx default
```
## Iniciar el servicio por primera vez
```
rc-service nginx start
```

## Comprobar el estado
```
rc-service nginx status
```

📂 Paso 3: Estructura de archivos en Alpine

    Configuración principal: /etc/nginx/nginx.conf

    Configuraciones de sitios: /etc/nginx/http.d/ (Aquí es donde debes crear tus archivos .conf como el de Merce Pons).

    Logs: /var/log/nginx/

    Directorio web por defecto: /var/lib/nginx/html (Aunque tú estás usando /var/www/).

👤 Paso 4: Usuarios y Permisos

Nginx en Alpine corre bajo el usuario nginx por defecto. Para que pueda leer tus carpetas de Hugo y WordPress:
Bash

## Asegúrate de que el usuario nginx tiene acceso a tus webs
```
chown -R nginx:nginx /var/www/mercepons
chown -R nginx:nginx /var/www/blog
```

## Permisos recomendados para directorios y archivos
```
find /var/www/ -type d -exec chmod 755 {} \;
find /var/www/ -type f -exec chmod 644 {} \;
```

🚀 Paso 5: Verificación y Carga


## Verificar sintaxis (esto te ahorra muchos dolores de cabeza)
```
nginx -t
```

## Si el test es exitoso, recarga sin cortar conexiones activas
```
nginx -s reload
```