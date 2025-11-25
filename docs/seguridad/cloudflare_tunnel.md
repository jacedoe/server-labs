5. 🔒 Conexión Segura con Cloudflare Tunnel
Cloudflare Tunnel (anteriormente conocido como Argo Tunnel) crea una conexión saliente segura entre tu VM (servidor local) y la red de Cloudflare. Esto permite que el tráfico web llegue a tus contenedores sin exponer directamente tu IP pública o requerir configuraciones complejas de firewall o redirección de puertos (port forwarding).

5.1. Prerrequisitos en Cloudflare
Dominio Activo: Tu dominio debe estar utilizando los servidores de nombres de Cloudflare.

Registro DNS: Asegúrate de tener un registro A o CNAME en Cloudflare para el subdominio que usarás (ej: web.tudominio.com). El valor de la IP puede ser ficticio, ya que el Tunnel lo anulará.

5.2. Instalación del Cliente cloudflared
Instalaremos el cliente que gestionará el túnel en tu VM Debian Trixie.

Descargar el Repositorio de Cloudflare:

curl -fsSL https://pkg.cloudflare.com/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloudflare.gpg
echo 'deb [signed-by=/usr/share/keyrings/cloudflare.gpg] https://pkg.cloudflare.com/cloudflared trixie main' | sudo tee /etc/apt/sources.list.d/cloudflared.list
Actualizar e Instalar:

sudo apt update
sudo apt install -y cloudflared
5.3. Creación y Configuración del Tunnel
La configuración se realiza en dos partes: autenticación y definición del túnel (rutas).

A. Autenticación
Autentica tu cloudflared con tu cuenta de Cloudflare. Se te pedirá iniciar sesión en el navegador.

cloudflared tunnel login
Se abrirá una URL en tu terminal. Pégala en tu navegador, inicia sesión en Cloudflare y selecciona tu dominio.

B. Crear el Túnel
Asigna un nombre a tu túnel y crea la configuración local.

Crear el Túnel:

 

cloudflared tunnel create wp-tunnel
# (Esto te dará un ID de túnel único que necesitarás)
Crear el Archivo de Configuración (config.yml): Crea el directorio de configuración para cloudflared y el archivo config.yml.

 

sudo mkdir /etc/cloudflared
sudo nano /etc/cloudflared/config.yml
Pega la siguiente configuración, asegurándote de reemplazar <TUNNEL-ID> con el ID único que obtuviste en el paso anterior:

YAML

tunnel: <TUNNEL-ID>
credentials-file: /root/.cloudflared/<TUNNEL-ID>.json

ingress:
  # Regla 1: Tráfico del dominio al puerto 80 del servidor local.
  - hostname: web.tudominio.com # Reemplaza con tu dominio
    service: http://localhost:80
  # Regla final: Bloquea cualquier otra petición no mapeada.
  - service: http_status:404 
Aquí, http://localhost:80 se refiere al puerto del host donde está escuchando tu contenedor NGINX.

C. Mapeo DNS y Túnel
Conecta el túnel a tu dominio en el panel de Cloudflare.

cloudflared tunnel route dns wp-tunnel web.tudominio.com
Esto crea automáticamente el registro DNS de tipo CNAME en tu zona de Cloudflare, apuntando a tu túnel.

5.4. Ejecución del Tunnel como Servicio
Ejecuta el cliente cloudflared como un servicio persistente.

Instalar el Servicio del Sistema (Systemd):

 

sudo cloudflared tunnel run --overwrite-service
Iniciar y Habilitar el Servicio:

 

sudo systemctl start cloudflared
sudo systemctl enable cloudflared
Verificar el Estado:

 

sudo systemctl status cloudflared
El estado debe mostrarse como active (running).

Una vez que el servicio esté activo, tu sitio web de WordPress será accesible a través de web.tudominio.com sin que hayas abierto un solo puerto en tu router o firewall local. Todo el tráfico pasa a través de la infraestructura segura de Cloudflare.

El entorno web y de seguridad ya está configurado. El último gran componente es el servicio de monitoreo.
