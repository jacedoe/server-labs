# 1. Despliegue VM Alpine Linux

Este apartado describe el proceso completo para desplegar una máquina virtual con Alpine Linux sobre un servidor XCP-ng, así como su configuración inicial para dejarla lista para administración remota y uso de contenedores con Docker.

### 2. Requisitos previos

Antes de comenzar, asegúrate de contar con:

Servidor XCP-ng correctamente instalado y operativo

Acceso a Xen Orchestra (XO Lite o completo)

Imagen ISO de Alpine Linux (Standard x86_64)

Conectividad de red funcional

Conocimientos básicos de consola Linux

### 3. Creación de la máquina virtual en XCP-ng

Accede a Xen Orchestra

Selecciona New VM

Elige la plantilla:

Other install media

Asigna los recursos recomendados:

CPU: 1–2 vCPU

RAM: 512 MB (mínimo) / 1 GB recomendado

Disco: 8–16 GB

Adjunta la ISO de Alpine Linux

Configura la interfaz de red (bridge por defecto)

Finaliza y arranca la VM

### 4. Instalación base de Alpine Linux

En la consola de la VM, inicia sesión como:

login: root


Ejecuta el instalador:

setup-alpine


Responde a las preguntas principales:

Teclado: es o us

Hostname: (ej. alpine-vm)

Red: DHCP (recomendado)

Zona horaria: Europe/Madrid (o la correspondiente)

Repositorio: por defecto

Disco: sys

Modo: standard

Confirma la instalación y espera a que finalice.

Reinicia el sistema:

reboot

### 5. Configuración del acceso por SSH

Instala el servidor OpenSSH:
```
apk add openssh
```

Habilita el servicio:
```
rc-update add sshd
rc-service sshd start
```

Verifica que el servicio esté activo:
```
rc-service sshd status
```

(Opcional pero recomendado) Edita la configuración:
```
vi /etc/ssh/sshd_config
```

Asegúrate de:
```
PermitRootLogin no
PasswordAuthentication yes
```

Reinicia SSH:
```
rc-service sshd restart
```
### 6. Creación de un nuevo usuario

Crea un usuario (ejemplo: admin):
```
adduser admin
```

Añádelo a los grupos necesarios:
```
addgroup admin wheel
```

Verifica:
```
id admin
```
### 7. Configuración de doas (sudo en Alpine)

Alpine utiliza doas en lugar de sudo.

Instala doas:
```
apk add doas
```

Edita el archivo de configuración:
```
vi /etc/doas.conf
```

Añade la siguiente línea:
```
permit persist :wheel
```

Asegura permisos correctos:
```
chmod 0400 /etc/doas.conf
```

Cambia al nuevo usuario y prueba:
```
su - admin
doas apk update
```
### 8. Instalación de herramientas básicas

Instala utilidades comunes para administración:
```
doas apk add \
  curl \
  wget \
  vim \
  btop \
  bash \
  git \
  ca-certificates
```

Establece Bash como shell por defecto (opcional):
```
doas chsh -s /bin/bash admin
```
### 9. Instalación y configuración de Docker

Instala Docker:
```
doas apk add docker
```

Habilita el servicio:
```
doas rc-update add docker
doas rc-service docker start
```

Añade el usuario al grupo docker:
```
doas addgroup admin docker
```

Cierra sesión y vuelve a entrar para aplicar cambios.

Verifica la instalación:
```
docker version
docker run hello-world
```
### 10. Configuración final recomendada

Actualiza el sistema:
```
doas apk update && doas apk upgrade
```

Configura IP estática (opcional):
```
vi /etc/network/interfaces
```