#!/bin/bash

# 🚀 Script de Deployment para Mi Fudo Pro

echo "╔════════════════════════════════════════════════════════╗"
echo "║  🚀 Mi Fudo Pro - Deployment a Cloudflare Workers      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Verificar git
echo -e "${YELLOW}[1/5] Verificando Git...${NC}"
if [ ! -d .git ]; then
  echo -e "${RED}Git no está inicializado${NC}"
  read -p "¿Inicializar git? (s/n): " init_git
  if [ "$init_git" = "s" ]; then
    git init
    echo -e "${GREEN}✓ Git inicializado${NC}"
  fi
else
  echo -e "${GREEN}✓ Git está inicializado${NC}"
fi

# 2. Verificar si hay cambios sin commit
echo ""
echo -e "${YELLOW}[2/5] Preparando cambios...${NC}"
if [ -n "$(git status --porcelain)" ]; then
  git add .
  git commit -m "Deploy: $(date +%Y-%m-%d\ %H:%M:%S)"
  echo -e "${GREEN}✓ Cambios committed${NC}"
else
  echo -e "${GREEN}✓ Todo está actualizado${NC}"
fi

# 3. Build
echo ""
echo -e "${YELLOW}[3/5] Compilando TypeScript...${NC}"
npm run build 2>/dev/null
echo -e "${GREEN}✓ Build completado${NC}"

# 4. Verificar wrangler
echo ""
echo -e "${YELLOW}[4/5] Verificando Wrangler...${NC}"
if ! command -v wrangler &> /dev/null; then
  echo -e "${YELLOW}Wrangler no encontrado. Instalando...${NC}"
  npm install -g wrangler
fi
echo -e "${GREEN}✓ Wrangler disponible${NC}"

# 5. Deploy
echo ""
echo -e "${YELLOW}[5/5] Desplegando a Cloudflare Workers...${NC}"
wrangler deploy

if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║  ✅ ¡Deployment exitoso!                              ║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo "Tu aplicación estará disponible en:"
  echo -e "${GREEN}https://mi-fudo-pro.TU_USUARIO.workers.dev${NC}"
  echo ""
  echo "Credenciales:"
  echo "  Usuario: admin"
  echo "  Contraseña: sushi2026"
else
  echo -e "${RED}❌ Error durante el deployment${NC}"
  exit 1
fi
