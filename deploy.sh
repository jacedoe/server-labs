#!/bin/sh

# En FreeBSD /bin/sh es muy robusto, pero si instalaste bash 
# y lo prefieres, puedes usar #!/usr/local/bin/bash

# Validar que exista un mensaje
if [ -z "$1" ]; then
    echo "Uso: ./deploy.sh 'mensaje del commit'"
    exit 1
fi

# Flujo de trabajo
echo "==> Agregando cambios a Git..."
git add .

echo "==> Creando commit..."
git commit -m "$1"

echo "==> Subiendo a GitHub (main)..."
git push origin main

echo "==> Ejecutando MkDocs Build & Deploy..."
# Usamos --clean para asegurar que no queden archivos huérfanos
mkdocs gh-deploy --clean --force

echo "==> Proceso completado con éxito."
