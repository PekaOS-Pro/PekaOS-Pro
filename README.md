# 🍱 Mi Fudo Pro - Sistema de Gestión de Pedidos

Sistema integral para restaurantes y negocios de comidas. Administra pedidos, clientes, productos y realiza seguimiento de entregas.

## 🚀 Características

- ✅ Gestión completa de pedidos (Delivery y Retiro)
- 📦 Catálogo de productos con categorías
- 👥 Registro y búsqueda de clientes
- 💾 Historial de pedidos e impresión de comprobantes
- 💰 Control de zonas de envío y costos
- 📊 Panel de administración
- 🔐 Autenticación segura

## 📋 Requisitos

- Node.js 18+ 
- npm o yarn
- Cuenta en Cloudflare (para deployment)

## 🏠 Desarrollo Local

### Instalación

```bash
npm install
```

### Ejecutar servidor

```bash
npm run dev
```

Abre tu navegador en `http://localhost:3000`

**Credenciales por defecto:**
- Usuario: `admin`
- Contraseña: `sushi2026`

## 🌐 Despliegue en Cloudflare Workers

### 1. Crear base de datos D1

```bash
# Instalar Wrangler CLI
npm install -g wrangler

# Iniciar sesión en Cloudflare
wrangler login

# Crear base de datos D1
wrangler d1 create mi-fudo-pro
```

### 2. Aplicar esquema a la base de datos

```bash
# Copiar el database_id del output anterior
wrangler d1 execute mi-fudo-pro --file=./schema.sql
```

### 3. Actualizar wrangler.toml

Reemplaza `your-database-id-here` con el ID obtenido:

```toml
[[d1_databases]]
binding = "DB"
database_name = "mi-fudo-pro"
database_id = "xxxxx-xxxxx-xxxxx"
```

### 4. Instalar dependencias de Cloudflare

```bash
npm install
```

### 5. Desplegar a Cloudflare Workers

```bash
# Ambiente de desarrollo
npm run deploy

# Ambiente de producción
npm run deploy:prod
```

## 📁 Estructura del Proyecto

```
mi-fudo-pro/
├── src/
│   └── index.ts          # API principal (Hono)
├── public/
│   ├── index.html        # Dashboard principal
│   ├── login.html        # Página de login
│   ├── cocina.html       # Pantalla de cocina
│   └── arqueo.html       # Módulo de arqueo
├── schema.sql            # Esquema de base de datos
├── wrangler.toml         # Configuración de Cloudflare Workers
└── package.json          # Dependencias
```

## 🗄️ Base de Datos (D1 SQLite)

La base de datos incluye:
- **productos**: Catálogo de productos
- **clientes**: Información de clientes
- **pedidos**: Historial de pedidos
- **items_pedido**: Detalles de cada pedido
- **tramos_delivery**: Zonas de envío
- **ingredientes**: Stock de ingredientes
- **recetas**: Relación producto-ingredientes
- **arqueos_caja**: Registro de caja

## 🔑 Variables de Entorno

Crear `.env.local` para desarrollo:

```
API_URL=http://localhost:3000/api
```

## 📝 API Endpoints

### Autenticación
- `POST /api/login` - Login de usuario

### Clientes
- `GET /api/clientes/:telefono` - Buscar cliente
- `POST /api/clientes` - Crear/actualizar cliente

### Pedidos
- `GET /api/pedidos` - Listar todos los pedidos
- `POST /api/pedidos` - Crear nuevo pedido
- `GET /api/pedidos/ultimo/:telefono` - Último pedido del cliente
- `GET /api/pedidos/pendientes` - Pedidos pendientes

### Productos
- `GET /api/inicializar` - Obtener productos y tramos
- `POST /api/productos` - Crear producto

### Zonas
- `POST /api/tramos` - Crear zona de envío

## 🛠️ Scripts

```bash
npm run dev          # Desarrollo local con watch
npm run build        # Compilar TypeScript
npm run deploy       # Desplegar a Cloudflare
npm run deploy:prod  # Desplegar a producción
```

## 🐛 Troubleshooting

### Problema: "No se pudo obtener el ID del pedido"
**Solución**: Asegúrate de que la base de datos está inicializada correctamente:
```bash
wrangler d1 execute mi-fudo-pro --file=./schema.sql
```

### Problema: CORS errors
Verifica que `wrangler.toml` tiene CORS configurado correctamente.

## 📱 Navegadores Soportados

- Chrome/Chromium 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 🔒 Seguridad

- Login con credenciales
- Cookies de sesión con expiración
- CORS habilitado para desarrollo
- Preparado para HTTPS en producción

## 📞 Soporte

Para reportar problemas, crea un issue en GitHub.

## 📄 Licencia

Privado - Mi Fudo Pro 2026
