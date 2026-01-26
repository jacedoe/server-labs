📝 Guía de Despliegue: WordPress + PHP 8.4 en Alpine Linux

Esta guía detalla la instalación del stack dinámico para blog.merceponsautora.com.
1. Instalación de PHP 8.4 y Extensiones

Alpine es modular. Para que WordPress funcione correctamente, necesitamos el motor de PHP y sus extensiones de procesamiento de imágenes y base de datos.
Bash

# Actualizar repositorios
apk update

# Instalar PHP 8.4 y módulos necesarios
apk add php84 php84-fpm php84-mysqli php84-json php84-openssl php84-curl \
    php84-zlib php84-xml php84-phar php84-intl php84-dom php84-xmlreader \
    php84-ctype php84-session php84-mbstring php84-gd php84-iconv

2. Configuración de PHP-FPM (El Socket)

Para que coincida con tu configuración de Nginx, debemos decirle a PHP que escuche en el archivo de socket que definiste: /var/run/php-fpm84.sock.

    Edita el archivo de configuración: vi /etc/php84/php-fpm.d/www.conf

    Modifica estas líneas:
    Ini, TOML

listen = /var/run/php-fpm84.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0660

Habilita y arranca el servicio:
Bash

    rc-update add php-fpm84 default
    rc-service php-fpm84 start

3. Base de Datos (MariaDB)

Instalaremos MariaDB de forma nativa para gestionar el contenido del blog.
Bash

# Instalar MariaDB
apk add mariadb mariadb-client

# Configurar directorios e instalar base de datos inicial
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Arrancar servicio
rc-update add mariadb default
rc-service mariadb start

# Configuración de seguridad (poner password de root)
mysql_secure_installation

Crear la base de datos para el blog:
SQL

-- Accede con: mysql -u root -p
CREATE DATABASE db_mercepons_blog;
CREATE USER 'user_blog'@'localhost' IDENTIFIED BY 'tu_password_seguro';
GRANT ALL PRIVILEGES ON db_mercepons_blog.* TO 'user_blog'@'localhost';
FLUSH PRIVILEGES;
EXIT;

4. Instalación de WordPress

Descargamos la última versión directamente en la ruta que definiste en tu Nginx (/var/www/blog).
Bash

# Crear directorio y descargar
mkdir -p /var/www/blog
cd /var/www/blog
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz --strip-components=1
rm latest.tar.gz

# Configurar permisos para que Nginx y PHP puedan escribir (subir fotos, etc)
chown -R nginx:nginx /var/www/blog

5. Configuración del wp-config.php

Crea el archivo de configuración uniendo WordPress con tu base de datos:
Bash

cp wp-config-sample.php wp-config.php
vi wp-config.php

Ajusta los valores con el nombre de la DB y el usuario que creamos en el paso 3.