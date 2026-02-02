# Guía de Despliegue: WordPress y Hugo en FreeBSD con Jails

## Introducción

Esta guía describe los pasos necesarios para desplegar un sitio web con **Hugo** y otro con **WordPress** en un entorno de **FreeBSD** utilizando **jails**, **Nginx**, **PHP-FPM**, y **MariaDB**.

----------

## Requisitos Previos

-   Un sistema FreeBSD configurado.
-   Acceso a `root` o un usuario con privilegios de administrador.
-   Conocimientos básicos de la terminal y configuración de servicios en FreeBSD.

----------

## 1. Configuración del Entorno

### 1.1 Crear el Jail

`# Crear el jail iocage create -n "mi_jail" -r 13.2-RELEASE ip4_addr="em0|10.8.8.2/24"   # Iniciar el jail iocage start mi_jail   # Acceder al jail iocage console mi_jail`

----------

### 1.2 Instalar Paquetes Necesarios

`# Actualizar los paquetes pkg update && pkg upgrade   # Instalar Nginx, PHP-FPM, MariaDB, y Hugo pkg install nginx php82 php82-fpm mariadb106-server mariadb106-client hugo`

----------

## 2. Configuración de Nginx

### 2.1 Configuración para Hugo

Crea el archivo `/etc/nginx/http.d/merceponsautora.com.conf` con el siguiente contenido:

`server {  listen  10.8.8.2:8080; server_name merceponsautora.com www.merceponsautora.com;   root /usr/local/www/merceponsautora.com/public; index index.html;   location / { try_files $uri $uri/ =404; } }`

### 2.2 Configuración para WordPress

Crea el archivo `/etc/nginx/http.d/blog.merceponsautora.com.conf` con el siguiente contenido:

`server {  listen  10.8.8.2:80; server_name blog.merceponsautora.com;   root /usr/local/www/blog; index index.php index.html index.htm;   location / { try_files $uri $uri/ /index.php?$args; }   location  ~ \.php$ { include fastcgi.conf; fastcgi_pass  127.0.0.1:9000; fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; }   location  ~ /\.ht { deny all; } }`

### 2.3 Habilitar y Reiniciar Nginx

`sysrc nginx_enable=yes service nginx start`

----------

## 3. Configuración de PHP-FPM

### 3.1 Configurar PHP-FPM para TCP

Edita el archivo `/usr/local/etc/php-fpm.d/www.conf`:

`listen = 127.0.0.1:9000 listen.owner = www listen.group = www listen.mode = 0660`

### 3.2 Habilitar y Reiniciar PHP-FPM

`sysrc php_fpm_enable=yes service php_fpm start`

----------

## 4. Configuración de MariaDB

### 4.1 Habilitar y Iniciar MariaDB

`sysrc mysql_enable=yes service mysql-server start`

### 4.2 Configurar la Base de Datos para WordPress

`mysql -u root -p`

Dentro de MariaDB:

`CREATE DATABASE wordpress; GRANT  ALL PRIVILEGES ON wordpress.*  TO  'wordpress'@'localhost' IDENTIFIED BY  'mypasswd'; FLUSH PRIVILEGES; EXIT;`

----------

## 5. Configuración de WordPress

### 5.1 Descargar y Configurar WordPress

`mkdir -p /usr/local/www/blog cd /usr/local/www/blog fetch https://wordpress.org/latest.tar.gz tar -xzvf latest.tar.gz mv wordpress/* . rm -rf wordpress latest.tar.gz chown -R www:www /usr/local/www/blog`

### 5.2 Configurar `wp-config.php`

Edita el archivo `wp-config.php`:

`define('DB_NAME', 'wordpress'); define('DB_USER', 'wordpress'); define('DB_PASSWORD', 'mypasswd'); define('DB_HOST', '127.0.0.1'); define('DB_CHARSET', 'utf8mb4'); define('DB_COLLATE', '');   $table_prefix = 'wp_';   define('WP_HOME', 'http://192.168.1.57'); define('WP_SITEURL', 'http://192.168.1.57');   define('WP_DEBUG', true); define('WP_DEBUG_LOG', true); define('WP_DEBUG_DISPLAY', false);   require_once  __DIR__ . '/wp-settings.php';`

----------

## 6. Configuración de Hugo

### 6.1 Crear el Sitio con Hugo

`mkdir -p /usr/local/www/merceponsautora.com cd /usr/local/www/merceponsautora.com hugo new site .`

### 6.2 Generar el Sitio Estático

`hugo`

----------

## 7. Configuración de PF (Packet Filter)

### 7.1 Configurar PF en el Host Principal

Edita el archivo `/etc/pf.conf` en el host principal:

`ext_if = "xn0" jail_net = "10.8.8.0/24"   nat on $ext_if from $jail_net to any -> ($ext_if)   rdr pass on $ext_if inet proto tcp from any to 192.168.1.57 port 8080 -> 10.8.8.2 port 8080 rdr pass on $ext_if inet proto tcp from any to 192.168.1.57 port 80 -> 10.8.8.2 port 80`

### 7.2 Habilitar y Recargar PF

`sysrc pf_enable=yes service pf start pfctl -f /etc/pf.conf`

----------

## 8. Probar el Acceso

### 8.1 Desde el Jail

`curl http://10.8.8.2:8080 # Para Hugo curl http://10.8.8.2 # Para WordPress`

### 8.2 Desde Otro Host en la LAN

`curl http://192.168.1.57:8080 # Para Hugo curl http://192.168.1.57 # Para WordPress`
