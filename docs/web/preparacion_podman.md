# 3. Preparación del Entorno para Contenedores con Podman
Podman es una herramienta de gestión de contenedores daemonless (sin demonio), lo que lo convierte en una opción más ligera y segura que Docker, especialmente para entornos rootless (sin privilegios de root).

3.1. Instalación de Podman y Podman-Compose
Podman está disponible en los repositorios de Debian Trixie (12).

```
sudo apt install -y podman
```
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

# 🐳 Características Clave de Podman
Podman destaca por su enfoque en la seguridad y la arquitectura descentralizada.

1. ## Arquitectura Sin Demonio (Daemonless)
Seguridad: A diferencia de Docker, Podman no utiliza un demonio central (daemon) que se ejecuta como root. En su lugar, utiliza un modelo de arquitectura fork-exec, donde el comando podman inicia directamente el proceso del contenedor, que a su vez utiliza runc (el tiempo de ejecución OCI).Ventaja: Esto elimina el riesgo de que un atacante que comprometa el daemon obtenga privilegios de root en el sistema operativo host.

2. ## Contenedores Sin Privilegios (Rootless Containers)
Seguridad: La característica más destacada de Podman es su capacidad para ejecutar contenedores como un usuario normal, sin requerir privilegios de root.Funcionamiento: Esto se logra utilizando los namespaces de usuario de Linux, mapeando el UID de root dentro del contenedor a un UID sin privilegios en el sistema host. Si el contenedor es comprometido, el atacante solo tiene los bajos privilegios del usuario host.

3. ## Soporte para Pods 
Orquestación Local: Podman es compatible con la idea de Pods, una característica central de Kubernetes. Un Pod es un grupo de uno o más contenedores que comparten recursos como el namespace de red, el almacenamiento local y el IPC.Kubernetes: Podman puede generar archivos YAML de Kubernetes directamente a partir de contenedores o Pods en ejecución, simplificando la transición del desarrollo local a la orquestación en clústeres.4. Compatibilidad con DockerInterfaz CLI: Podman utiliza comandos idénticos o casi idénticos a los de Docker (por ejemplo, podman run, podman ps, podman images), lo que permite a los usuarios con experiencia en Docker cambiar a Podman rápidamente.Imágenes: Podman puede usar y construir imágenes de contenedor compatibles con Docker y OCI.

