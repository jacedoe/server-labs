🛠️ Comandos Útiles y de Referencia
Este apéndice contiene una lista de comandos esenciales para la gestión diaria y la solución de problemas (troubleshooting) de los componentes clave de la infraestructura.

1. ⚙️ Gestión de la Máquina Virtual (XCP-ng Console)
Estos comandos se ejecutan en la consola de root del servidor XCP-ng.

Verificar el estado del host:
```
xe host-list
```
Verificar el estado de las VMs:
```
xe vm-list
```
Encender una VM (usando el nombre):
```
xe vm-start vm=[Nombre de la VM]
```
Apagar una VM (apagado limpio):
```
xe vm-shutdown vm=[Nombre de la VM]
```
Verificar el estado de los Storage Repositories (SR):
```
xe sr-list
```

1.2. Ejemplo de redimensionamiento de una VM Alpine Linux de 20 GiB a 40 GiB

Ejecutar en el host Xen
```
xe vm-shutdown vm=VM
xe vm-disk-list vm=VM
xe vdi-resize uuid=VDI_UUID disk-size=40GiB
xe vm-start vm=VM

```
Ejecutar en la VM Alpine
```
apk add util-linux e2fsprogs
growpart /dev/xvda 3
resize2fs /dev/xvda3
df -h

```

```

🛠️ 

