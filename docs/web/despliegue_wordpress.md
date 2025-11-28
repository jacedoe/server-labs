4. Despliegue del Sitio Web con Podman Compose
Este documento detalla la creación y ejecución del stack de tres contenedores (MariaDB, WordPress y NGINX) utilizando podman-compose. Este método asegura que los servicios se orquesten correctamente, se comuniquen a través de una red interna y persistan sus datos.

4.1. Estructura de Directorios
Trabajaremos dentro del directorio de nuestro usuario (admin en este ejemplo).

cd ~
mkdir -p projects/wordpress-stack
cd projects/wordpress-stack
Dentro de este directorio, crearemos nuestro archivo de orquestación y una carpeta para los archivos de configuración de NGINX.

4.2. Creación del Archivo de Configuración de NGINX
Aunque NGINX actuará como proxy inverso, necesita un archivo de configuración simple para redirigir el tráfico al contenedor de WordPress.

Crear el directorio de configuración:

mkdir -p nginx/conf.d
Crear el archivo default.conf (nginx/conf.d/default.conf):

Nginx
```
server {
    listen 80;

    location / {
        # El nombre del servidor debe coincidir con el nombre del servicio de WordPress en podman-compose
        proxy_pass http://wordpress:80; 
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
Este archivo le dice a NGINX que escuche en el puerto 80 y pase todas las peticiones al servicio interno http://wordpress:80.

4.3. El Archivo podman-compose.yml
Este archivo define los tres servicios, sus dependencias, variables de entorno y los volúmenes persistentes. Crea el archivo podman-compose.yml en la raíz de ~/projects/wordpress-stack/.
```
version: '3.8'

services:
  # 1. Base de Datos (MariaDB)
  db:
    image: mariadb:10.11
    container_name: mariadb_wp
    restart: always
    environment:
      # *** MODIFICAR ESTOS VALORES ***
      MARIADB_ROOT_PASSWORD: <tu_password_root_db> 
      MARIADB_DATABASE: wordpress
      MARIADB_USER: wpuser
      MARIADB_PASSWORD: <tu_password_usuario_db>
    volumes:
      - ~/data/mariadb:/var/lib/mysql # Persistencia de datos
    networks:
      - web_net

  # 2. Aplicación (WordPress)
  wordpress:
    image: wordpress:latest
    container_name: wordpress_app
    restart: always
    depends_on:
      - db # Asegura que la DB se inicie antes que WordPress
    environment:
      # Utiliza los mismos valores que en el servicio 'db'
      WORDPRESS_DB_HOST: db:3306 # El nombre del servicio DB
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: <tu_password_usuario_db>
    volumes:
      - ~/data/wordpress:/var/www/html # Persistencia de código y uploads
    networks:
      - web_net

  # 3. Proxy (NGINX)
  nginx:
    image: nginx:stable
    container_name: nginx_proxy
    restart: always
    depends_on:
      - wordpress
    ports:
      - "80:80"  # Puerto HTTP
      - "443:443" # Puerto HTTPS
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d:ro # Monta el archivo de configuración creado
    networks:
      - web_net

networks:
  # Referencia a la red creada en el paso anterior (preparacion_podman.md)
  web_net:
    external: true
```

4.4. Despliegue de los Servicios
Una vez que el archivo podman-compose.yml esté listo, despliega el stack en modo detached (segundo plano):

podman-compose up -d

4.5. Verificación
Verificar el estado de los contenedores:

podman ps
Deberías ver los tres contenedores (mariadb_wp, wordpress_app, nginx_proxy) con el estado Up.

Verificar el log de WordPress (opcional):

podman logs -f wordpress_app
Esto confirmará que WordPress se ha conectado correctamente a la base de datos MariaDB.

Acceso Local: Si la red local lo permite, intenta acceder al sitio desde tu máquina local usando la IP de la VM: http://192.168.1.XX. Deberías ver la pantalla de configuración inicial de WordPress.

Script para solucinonar poibles problemas con los permisos de Wordpress a la hora de subir archivos como imágenes al servidor

```
#!/bin/bash
# Script para preparar directorios y permisos rootless de WordPress en Podman

set -e

# Variables
VOLUME_PATH="$HOME/.local/share/containers/storage/volumes/www_wp_data/_data"
WP_CONTENT="$VOLUME_PATH/wp-content"

echo "✅ Creando directorios necesarios..."
podman unshare mkdir -p "$WP_CONTENT/uploads"
podman unshare mkdir -p "$WP_CONTENT/plugins"
podman unshare mkdir -p "$WP_CONTENT/cache"

echo "✅ Ajustando propietario a www-data (UID 33:GID 33)..."
podman unshare chown -R 33:33 "$WP_CONTENT"

echo "✅ Ajustando permisos a 775..."
podman unshare chmod -R 775 "$WP_CONTENT"

echo "✅ Todo listo. WordPress puede escribir en wp-content."
``` 
