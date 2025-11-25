3. Preparación del Entorno para Contenedores con Podman
Podman es una herramienta de gestión de contenedores daemonless (sin demonio), lo que lo convierte en una opción más ligera y segura que Docker, especialmente para entornos rootless (sin privilegios de root).

3.1. Instalación de Podman y Podman-Compose
Podman está disponible en los repositorios de Debian Trixie (12).
```
Instalar Podman y podman-compose:
```
# Podman (el motor de contenedores)

sudo apt install -y podman

# Podman-compose (para orquestación multi-contenedor, similar a docker-compose)
```
sudo apt install -y podman-compose
```
Verificar la Instalación:
```
podman --version
podman-compose --version
```
3.2. Configuración de Entornos Rootless (Sin Root)
Por seguridad, es una buena práctica ejecutar contenedores con un usuario normal en lugar de root. Esto se conoce como modo Rootless.

Verificar la configuración de subordinate IDs: El sistema Debian ya debe haber configurado los archivos /etc/subuid y /etc/subgid para permitir al usuario estándar tener rangos de IDs para contenedores.

Confirma que tu usuario (admin o el que hayas creado) aparece en estos archivos.

Inicialización del Entorno Rootless: La primera vez que ejecutas un comando Podman como tu usuario normal, el sistema inicializa automáticamente el entorno:

# Ejecuta un comando simple para forzar la inicialización
```
podman info
```
Configuración del Registro de Contenedores: Si planeas utilizar registros no oficiales, edita el archivo de registros:

# Opcional: Para permitir imágenes no firmadas o de otros registros
```
sudo vim /etc/containers/registries.conf
```
3.3. Estructura de Redes y Volúmenes de Podman
Para la comunicación entre los contenedores de WordPress, NGINX y MariaDB, y para asegurar la persistencia de los datos, configuraremos una red y volúmenes dedicados.

A. Crear una Red Dedicada
La red interna permitirá que los contenedores se comuniquen usando sus nombres de servicio.

# Crea una nueva red Podman llamada 'web_net'
```
podman network create web_net
```
B. Conceptos de Volúmenes Persistentes
En el archivo podman-compose.yml (que veremos a continuación), mapearemos directorios locales a directorios dentro de los contenedores (volumes:).

WordPress Data: Mapearemos una carpeta local (ej: /home/admin/data/wordpress) al directorio /var/www/html del contenedor de WordPress.

Database Data: Mapearemos otra carpeta (ej: /home/admin/data/mariadb) al directorio de datos de MariaDB.

Crear la estructura de carpetas de datos:

```
mkdir -p ~/data/wordpress
mkdir -p ~/data/mariadb
```
Con Podman y su entorno rootless instalados, la red interna configurada y las carpetas de datos creadas, estamos listos para pasar al despliegue del stack de WordPress.
