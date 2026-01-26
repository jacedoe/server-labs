Para cerrar el círculo de tu infraestructura en Alpine Linux, el túnel de Cloudflare (cloudflared) es la pieza clave: es lo que permite que tu servidor sea accesible desde internet sin abrir puertos en tu router y gestionando el SSL de forma automática.

Al no usar contenedores, instalaremos el binario de forma nativa y lo configuraremos como un servicio de OpenRC.
🛠️ Guía de Instalación: Cloudflare Tunnel en Alpine Linux
1. Instalación del binario

Alpine no siempre tiene la versión más reciente en sus repositorios oficiales, por lo que lo ideal es descargar el binario directamente de Cloudflare.
Bash

# Instalar dependencias necesarias
apk add libc6-compat

# Descargar el binario (arquitectura x86_64 para XCP-ng)
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64

# Mover y dar permisos
chmod +x cloudflared-linux-amd64
mv cloudflared-linux-amd64 /usr/local/bin/cloudflared

# Verificar instalación
cloudflared --version

2. Autenticación y Creación del Túnel

Desde la terminal de tu servidor, ejecuta el login (esto te dará un enlace que debes abrir en tu navegador):
Bash

cloudflared tunnel login

Una vez autorizado, crea el túnel para tu infraestructura:
Bash

# Nombre sugerido: server-labs
cloudflared tunnel create server-labs

Esto generará un archivo .json en ~/.cloudflared/. Anota el ID del túnel.
3. Configuración del archivo config.yml

Crea el archivo de configuración que redirigirá el tráfico a los puertos de Nginx que definimos antes:
Bash

mkdir -p /etc/cloudflared
vi /etc/cloudflared/config.yml

Contenido del archivo:
YAML

tunnel: TU_TUNNEL_ID
credentials-file: /etc/cloudflared/TU_TUNNEL_ID.json

ingress:
  # Sitio principal (Hugo)
  - hostname: merceponsautora.com
    service: http://localhost:8080
  - hostname: www.merceponsautora.com
    service: http://localhost:8080

  # Blog (WordPress)
  - hostname: blog.merceponsautora.com
    service: http://localhost:80

  # Regla por defecto (404 si no coincide nada)
  - service: http_status:404

No olvides mover el archivo .json de credenciales a /etc/cloudflared/ para que sea accesible globalmente.
4. Configuración como Servicio nativo (OpenRC)

Para que el túnel arranque solo al iniciar la VM en XCP-ng, crearemos un script de servicio para Alpine.

    Crea el archivo de servicio: vi /etc/init.d/cloudflared

    Pega este contenido:

Bash

#!/sbin/openrc-run

name="cloudflared"
description="Cloudflare Tunnel"
command="/usr/local/bin/cloudflared"
command_args="tunnel --config /etc/cloudflared/config.yml run"
command_background="yes"
pidfile="/run/${RC_SVCNAME}.pid"
output_log="/var/log/cloudflared.log"
error_log="/var/log/cloudflared.err"

depend() {
    need net
    after firewall
}

    Da permisos y activa el servicio:

Bash

chmod +x /etc/init.d/cloudflared
rc-update add cloudflared default
rc-service cloudflared start

5. Configuración en el Panel de Cloudflare (DNS)

El último paso es decirle a Cloudflare que use el túnel para tus dominios. Puedes hacerlo desde la web de Cloudflare o por comando:
Bash

cloudflared tunnel route dns server-labs merceponsautora.com
cloudflared tunnel route dns server-labs blog.merceponsautora.com