7. 🕵️‍♂️ Script de Escaneo de Infraestructura con arp-scan
Este script Bash se encarga de monitorear la red local para detectar nuevos dispositivos (o dispositivos que desaparecen) y notificar al administrador por correo electrónico.

7.1. Instalación de arp-scan
La herramienta arp-scan es necesaria para escanear la red a nivel ARP y obtener información precisa sobre los hosts conectados, incluso si tienen un firewall activo a nivel IP.

Bash

# Instalar arp-scan
sudo apt install -y arp-scan

# Nota: arp-scan debe ejecutarse con privilegios de root (sudo)
7.2. Creación de la Lista de Referencia
Necesitas un archivo que contenga la lista de dispositivos "conocidos" en tu infraestructura. Este archivo será la base de la comparación.

Realizar el primer escaneo de la red (como root): Ajusta el rango de red (192.168.1.0/24) a tu subred.

Bash

sudo arp-scan --localnet | grep -E '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}' | awk '{print $2, $1}' | sort > ~/scripts/infra-scan/known_devices.txt
Este comando escanea, filtra solo las líneas con direcciones MAC, invierte el orden (MAC primero) y guarda la lista ordenada.

Verificar el contenido:

Bash

cat ~/scripts/infra-scan/known_devices.txt
El formato de cada línea debe ser: [Dirección IP] [Dirección MAC].

7.3. Desarrollo del Script Bash (infra_scan.sh)
Crea el directorio y el archivo del script.

Bash

mkdir -p ~/scripts/infra-scan
nano ~/scripts/infra-scan/infra_scan.sh
Añade el siguiente código al archivo. Asegúrate de reemplazar las variables con tus valores (dirección IP, correo).

Bash

#!/bin/bash

# --- VARIABLES DE CONFIGURACIÓN ---
SUBNET="192.168.1.0/24"
KNOWN_DEVICES_FILE="/home/admin/scripts/infra-scan/known_devices.txt"
LOG_FILE="/home/admin/scripts/infra-scan/scan_log.txt"
RECIPIENT_EMAIL="tu_correo_personal@ejemplo.com"
SENDER_NAME="VM-Monitoreo"
TEMP_CURRENT_SCAN="/tmp/current_scan.txt"

# --- FUNCIONES ---

# Función para enviar la alerta por correo
send_alert() {
    local subject="$1"
    local message="$2"
    echo -e "$message" | mail -s "$subject" -a "From: $SENDER_NAME <$RECIPIENT_EMAIL>" "$RECIPIENT_EMAIL"
}

# --- EJECUCIÓN DEL ESCANEO ---

# 1. Realizar un escaneo actual y limpiar el resultado (REQUIERE SUDO)
sudo arp-scan --localnet --interface eth0 | grep -E '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}' | awk '{print $2, $1}' | sort > $TEMP_CURRENT_SCAN

# 2. Comparar el escaneo actual con la lista de dispositivos conocidos

# 2.1. Buscar dispositivos NUEVOS
NEW_DEVICES=$(comm -13 "$KNOWN_DEVICES_FILE" "$TEMP_CURRENT_SCAN")

if [ -n "$NEW_DEVICES" ]; then
    ALERT_SUBJECT="🚨 ALERTA DE SEGURIDAD: Dispositivos Nuevos Detectados"
    ALERT_MESSAGE="Se han detectado los siguientes dispositivos no registrados en la red:\n\n$NEW_DEVICES\n\nPor favor, verifica su origen."
    send_alert "$ALERT_SUBJECT" "$ALERT_MESSAGE"
    echo "$(date): Dispositivos nuevos detectados. Alerta enviada." >> $LOG_FILE
fi

# 2.2. Buscar dispositivos DESAPARECIDOS
# Nota: La comparación se invierte para encontrar líneas que están en el archivo conocido pero no en el actual
MISSING_DEVICES=$(comm -23 "$KNOWN_DEVICES_FILE" "$TEMP_CURRENT_SCAN")

if [ -n "$MISSING_DEVICES" ]; then
    ALERT_SUBJECT="⚠️ NOTIFICACIÓN: Dispositivos Desaparecidos"
    ALERT_MESSAGE="Los siguientes dispositivos han desaparecido de la red:\n\n$MISSING_DEVICES"
    send_alert "$ALERT_SUBJECT" "$ALERT_MESSAGE"
    echo "$(date): Dispositivos desaparecidos. Notificación enviada." >> $LOG_FILE
fi


# 3. Si no hay cambios
if [ -z "$NEW_DEVICES" ] && [ -z "$MISSING_DEVICES" ]; then
    echo "$(date): Escaneo completado. No se detectaron cambios." >> $LOG_FILE
fi

# 4. Actualizar la lista de dispositivos conocidos (si se desea que los nuevos se "acepten" automáticamente)
# Si no quieres que se actualice automáticamente, comenta la línea de abajo y actualiza manualmente el archivo known_devices.txt
# cat $TEMP_CURRENT_SCAN > $KNOWN_DEVICES_FILE

# 5. Limpieza
rm $TEMP_CURRENT_SCAN
7.4. Permisos de Ejecución
Otorga permisos de ejecución al script:

Bash

chmod +x ~/scripts/infra-scan/infra_scan.sh
7.5. Prueba Manual
Antes de automatizar con cron, prueba el script manualmente como root (ya que arp-scan lo requiere):

Bash

sudo ~/scripts/infra-scan/infra_scan.sh
Si tienes cambios en la red o borraste known_devices.txt, deberías recibir un correo.
