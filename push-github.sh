#!/bin/bash

# Script para hacer el primer push a GitHub

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  📤 Primer Push a GitHub - Mi Fudo Pro                    ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Pedir datos
read -p "👤 Tu usuario de GitHub: " GITHUB_USER
read -p "🔗 ¿URL del repositorio? (https://github.com/$GITHUB_USER/mi-fudo-pro.git): " REPO_URL

if [ -z "$REPO_URL" ]; then
  REPO_URL="https://github.com/$GITHUB_USER/mi-fudo-pro.git"
fi

echo ""
echo "📝 Iniciando push..."

# Inicializar git
if [ ! -d .git ]; then
  git init
  git config user.email "admin@mifudopro.local"
  git config user.name "Mi Fudo Pro"
fi

# Agregar todos los archivos
git add .

# Commit
git commit -m "🚀 Initial commit: Mi Fudo Pro v1.0 - Sistema de Gestión de Pedidos para Restaurantes"

# Crear rama main si no existe
git branch -M main

# Agregar remoto
git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"

# Push
echo ""
echo "🚀 Subiendo a GitHub..."
git push -u origin main

echo ""
echo "✅ ¡Hecho! Tu repositorio está en:"
echo "   $REPO_URL"
echo ""
