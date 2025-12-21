# ⚙️ Instalación y Configuración del Servidor XCP-ng

Esta guía detalla el proceso para establecer la plataforma de virtualización utilizando **XCP-ng**, la interfaz web ligera y moderna para gestionar el hypervisor **XCP-ng** (o XenServer).  

> Nota: XCP-ng **no es el hypervisor**, sino la interfaz de gestión. Primero se instala XCP-ng y luego se accede a su interfaz web integrada.

---

## 📋 1. Prerrequisitos

Antes de comenzar, asegúrate de contar con:

- Un servidor físico o máquina virtual para instalar el hypervisor XCP-ng.
- Medios de instalación de XCP-ng (USB o ISO).
- Acceso a la red local.

!!! warning "Importante"
    Guarda cuidadosamente la contraseña de root que establecerás durante la instalación. Será esencial para la gestión del servidor.

---

## 🖥️ 2. Instalación del Hypervisor XCP-ng

La instalación del hypervisor es el paso fundamental para acceder a XCP-ng.

### 2.1 Arranque desde el medio de instalación

Inicia el servidor usando la imagen ISO o USB de XCP-ng. El asistente te guiará paso a paso:

1. Selecciona el **idioma** y la distribución del teclado.  
2. Acepta el **acuerdo de licencia (EULA)**.  
3. Selecciona el **disco** donde se instalará el sistema operativo del hypervisor.  
4. Configura la **contraseña de root**.  
5. Configura la **red** (se recomienda IP estática para servidores).  
6. Configura la **zona horaria**.  
7. Finalización: el sistema instalará los archivos y te pedirá retirar el medio y reiniciar.

---

## 🌐 3. Acceso Inicial a la Interfaz XCP-ng

Tras reiniciar el servidor:

### 3.1 Obtener la Dirección IP

La consola de XCP-ng mostrará la IP asignada (ejemplo: `192.168.1.10`).

### 3.2 Acceder desde el navegador

Abre un navegador web y navega a:

https://192.168.1.10


!!! info "Certificado autofirmado"
    Es probable que tu navegador muestre una advertencia de seguridad. Acepta el certificado para continuar.

### 3.3 Inicio de sesión en XCP-ng

- **Usuario:** `root`  
- **Contraseña:** La que configuraste durante la instalación de XCP-ng

---

## ⚙️ 4. Configuración Post-Instalación en XCP-ng

Dentro de XCP-ng, realiza estas configuraciones básicas:

### 4.1 Configuración de Red

- Verifica que la interfaz de red (NIC) tenga la **IP, máscara y gateway** correctos.  
- Configura redes virtuales o VLANs si es necesario.

### 4.2 Configuración de Almacenamiento (Storage)

- Crea un **SR (Storage Repository)** para alojar las máquinas virtuales.  
- Ejemplos de opciones comunes:  
  - **LVM Local** (disco físico dedicado)  
  - **NFS** o **SMB** (almacenamiento en red)  

!!! tip
    Si instalaste en un disco pequeño y tienes un disco más grande para VMs, crea un SR separado en ese disco para optimizar el rendimiento.

### 4.3 Actualizaciones

XCP-ng facilita la aplicación de parches y actualizaciones del hypervisor.  
Asegúrate de que XCP-ng esté **actualizado** antes de desplegar tus VMs.

---

> ✅ Con la instalación y configuración básica de XCP-ng completada, tu hypervisor XCP-ng está listo para administrar máquinas virtuales de forma eficiente y segura.

---

➡️ **Siguiente paso recomendado:**  
Continúa con la preparación del entorno para contenedores:  
[Preparación de Podman](../web/preparacion_podman.md)
