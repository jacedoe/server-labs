Parece que la búsqueda se ha centrado en X-Lite (un softphone o aplicación de teléfono SIP), y no en XO-Lite (la interfaz web ligera para administrar el hypervisor XCP-ng/XenServer).

Voy a enfocarme en la documentación de XO-Lite (la interfaz de XCP-ng) como acordamos.

Aquí tienes el borrador para el primer archivo de tu documentación, que irá en la ruta: docs/preparacion/instalacion_xo_lite.md.

1. Instalación y Configuración del Servidor XO-Lite
Este documento detalla el proceso para establecer la plataforma de virtualización. Utilizaremos XO-Lite, una interfaz web ligera y moderna, para gestionar el hypervisor XCP-ng (o XenServer).

1.1. Prerrequisitos
Antes de comenzar, asegúrate de tener:

Un servidor físico o máquina donde se instalará el hypervisor XCP-ng.

Medios de instalación de XCP-ng (USB o ISO).

Acceso a la red local.

Nota Importante: XO-Lite no es el hypervisor, sino la interfaz de gestión. Primero se instala XCP-ng y luego se accede a su interfaz web integrada.

1.2. Instalación del Hypervisor XCP-ng
La instalación de XCP-ng es el paso fundacional para acceder a XO-Lite.

Arranque desde el medio de instalación: Inicia el servidor usando la imagen ISO o USB de XCP-ng.

Sigue el asistente de instalación:

Selecciona el idioma y la distribución del teclado.

Acepta el acuerdo de licencia (EULA).

Selecciona el disco donde se instalará el sistema operativo del hypervisor.

Configura la contraseña de root. ¡Guarda esta contraseña de forma segura! Es esencial para la gestión.

Configura la red (IP estática recomendada para un servidor).

Configura la zona horaria.

Finalización: El sistema se instalará y te pedirá que retires el medio y reinicies.

1.3. Acceso Inicial a la Interfaz XO-Lite
Una vez que el servidor XCP-ng se haya reiniciado, verás la consola de bienvenida.

Obtener la Dirección IP: La consola mostrará la dirección IP asignada al servidor (la que configuraste). Por ejemplo: 192.168.1.10.

Acceder al Navegador: Abre tu navegador web y navega a la dirección IP del servidor usando HTTPS:

https://[Dirección IP del Servidor XCP-ng]
Aceptar el Certificado: Es probable que tu navegador muestre una advertencia de seguridad (certificado autofirmado). Acepta la advertencia para continuar.

Inicio de Sesión: Serás redirigido a la interfaz XO-Lite.

Usuario: root

Contraseña: La que configuraste durante la instalación de XCP-ng.

1.4. Configuración Post-Instalación en XO-Lite
Una vez dentro de XO-Lite, realiza las siguientes configuraciones básicas:

A. Configuración de Red
Verifica que la configuración de la interfaz de red (NIC) sea correcta (IP, máscara, gateway).

Si deseas tener diferentes VLANs o redes, este es el lugar para configurar Redes Virtuales.

B. Configuración de Almacenamiento (Storage)
Crear un SR (Storage Repository): Para alojar las máquinas virtuales, debes definir dónde se guardarán.

Si instalaste en un disco pequeño y tienes un disco más grande para VMs, crea un nuevo SR utilizando ese espacio.

Opciones comunes: LVM Local (si es un disco físico dedicado), NFS o SMB (si usas almacenamiento en red).

C. Actualizaciones
Asegúrate de que el hypervisor esté actualizado. XO-Lite facilita la aplicación de parches y actualizaciones de XCP-ng.
