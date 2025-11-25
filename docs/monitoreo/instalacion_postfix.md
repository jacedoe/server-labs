6. 🛡️ Instalación y Configuración de Postfix para Notificaciones
Para que el script de escaneo de infraestructura pueda enviarte alertas por correo electrónico, necesitamos configurar un agente de transferencia de correo (MTA). Usaremos Postfix como un relay simple para retransmitir correos a un servidor SMTP externo (como Gmail, Outlook, o tu proveedor de correo).

6.1. Instalación de Postfix
Instalar el paquete:

 

sudo apt update
sudo apt install -y postfix mailutils libsasl2-2 ca-certificates sasl2-bin
Asistente de Configuración: Durante la instalación, Postfix te preguntará sobre el tipo de configuración. Selecciona las siguientes opciones:

Tipo de configuración de correo (General type of mail configuration): Internet con 'smarthost' (esto nos permitirá usar un servidor externo para el envío).

Nombre de correo del sistema (System mail name): El hostname de tu VM (ej: vm-podman-web.local).

Servidor SmartHost (Smarthost): Aquí pondrás la dirección del servidor SMTP de tu proveedor (ej: smtp.gmail.com:587).

6.2. Configuración como Smarthost (Ejemplo con Gmail/TLS)
Si utilizaste el asistente, ya tienes la base. Ahora, editaremos el archivo de configuración principal para detallar la autenticación.

Editar main.cf:

 

sudo vim /etc/postfix/main.cf
Añadir las siguientes líneas al final del archivo:

 

# Configuraciones de TLS y SASL
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

# Restricción de dominios que envían (solo localhost)
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128

# Opcional: Reemplazar la dirección del remitente por un correo específico
# sender_canonical_maps = hash:/etc/postfix/sender_canonical
Asegúrate de que la línea relayhost = [smtp.gmail.com]:587 (o tu smarthost) esté presente y no comentada.

6.3. Configuración de Credenciales de Autenticación
Necesitas un archivo para almacenar el usuario y la contraseña (o la App Password en servicios como Gmail) del servidor SMTP externo.

Crear el archivo sasl_passwd:

 

sudo nano /etc/postfix/sasl_passwd
Añadir las credenciales:

[smtp.gmail.com]:587  tu_correo@gmail.com:tu_contraseña_o_app_password
¡ADVERTENCIA DE SEGURIDAD! Utiliza siempre una Contraseña de Aplicación específica para esto, y no tu contraseña principal, especialmente si usas 2FA.

Generar el archivo de hash y protegerlo:

 

sudo postmap /etc/postfix/sasl_passwd
sudo rm /etc/postfix/sasl_passwd # Elimina el archivo de texto plano
sudo chmod 600 /etc/postfix/sasl_passwd.db
6.4. Reiniciar y Probar el Servicio
Reiniciar Postfix:

 

sudo systemctl restart postfix
Prueba de Envío: Envía un correo de prueba a tu bandeja de entrada:

 

echo "Prueba de Postfix - Todo OK" | mail -s "Alerta: Postfix Configurado" tu_correo_personal@ejemplo.com
Verificar Logs: Si el correo no llega, revisa el log de Postfix:

 

tail /var/log/mail.log
Busca mensajes como status=sent para confirmar la entrega exitosa.

Con Postfix configurado, tenemos la capacidad de notificar sobre eventos de la infraestructura.
