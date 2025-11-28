#!/bin/bash
# Script para preparar directorios y permisos rootless de WordPress en Podman

set -e

# Variables
VOLUME_PATH="$HOME/.local/share/containers/storage/volumes/www_wp_data/_data"
WP_CONTENT="$VOLUME_PATH/wp-content"

echo "✅ Creando directorios necesarios..."
podman unshare mkdir -p "$WP_CONTENT/uploads"
podman unshare mkdir -p "$WP_CONTENT/plugins"
podman unshare mkdir -p "$WP_CONTENT/cache"

echo "✅ Ajustando propietario a www-data (UID 33:GID 33)..."
podman unshare chown -R 33:33 "$WP_CONTENT"

echo "✅ Ajustando permisos a 775..."
podman unshare chmod -R 775 "$WP_CONTENT"

echo "✅ Todo listo. WordPress puede escribir en wp-content."

