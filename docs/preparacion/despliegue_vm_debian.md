2. Despliegue y Configuración de la VM Debian Trixie
Una vez que el servidor XCP-ng/XO-Lite está operativo, el siguiente paso es crear y configurar nuestra Máquina Virtual (VM) invitada que servirá como host para Podman y los servicios de monitoreo.

2.1. Creación de la VM en XO-Lite
Utilizaremos la interfaz XO-Lite para iniciar el proceso de creación de la nueva VM.

Navegar al Asistente: En XO-Lite, dirígete a la sección de VMs y selecciona la opción para crear una nueva máquina virtual.

Selección de Plantilla (Template):

Elige una plantilla de Debian 12 (64-bit). Esto optimizará los parámetros iniciales de la VM.

Configuración de Recursos: Asigna los recursos iniciales a la VM. Ajusta estos valores según tus necesidades, pero se recomiendan los siguientes mínimos:

Nombre: vm-podman-web (o un nombre descriptivo).

CPU: 2 vCPUs

RAM: 2 GB (o 4 GB si se planea una carga considerable en WordPress).

Disco: 40 GB (asegúrate de que el SR configurado tenga espacio suficiente).

Configuración de Red: Asegúrate de que la VM esté conectada a la red virtual correcta que permite el acceso desde tu red local.

Instalación del SO:

Carga la imagen ISO de instalación de Debian 12 "Trixie" en la biblioteca de ISOs de XO-Lite y selecciónala para el primer arranque de la VM.

Inicio de la VM: Enciende la VM y la consola se abrirá, mostrando el instalador de Debian.

2.2. Proceso de Instalación de Debian 12
Sigue el proceso de instalación estándar de Debian, prestando atención a los siguientes puntos clave:

Particionado: Se recomienda usar la opción de particionado guiado para principiantes, o crear un esquema con una partición /home separada para mayor flexibilidad.

Configuración de Red: El instalador detectará la red. Es crucial configurar una dirección IP estática para el servidor, ya que alojará servicios críticos.

IP estática: 192.168.1.XX (elige una que no esté en el rango DHCP).

Máscara de red, Gateway y Servidores DNS (por ejemplo, los de Cloudflare, 1.1.1.1).

Usuarios: Crea una cuenta de usuario estándar (ej: admin). No olvides la contraseña de root.

Selección de Software: Desmarca cualquier entorno de escritorio (GNOME, KDE, etc.) ya que este será un servidor sin interfaz gráfica. Asegúrate de que solo estén marcados "servidor SSH" y "utilidades estándar del sistema".

2.3. Configuración Post-Instalación
Una vez que la instalación haya finalizado y hayas reiniciado la VM, accede a ella a través de SSH usando el usuario estándar que creaste:

ssh admin@192.168.1.XX
A. Actualización del Sistema
Es fundamental mantener el sistema actualizado:

sudo apt update
sudo apt upgrade -y

B. Instalación de Herramientas Esenciales
Instala herramientas que facilitarán la gestión y la configuración posterior:

sudo apt install -y vim curl wget net-tools


