# 📋 GUÍA DE DESPLIEGUE A GITHUB Y CLOUDFLARE

## Paso 1: Preparar el código para GitHub

El proyecto ya está configurado con:
- ✅ `.gitignore` configurado
- ✅ `wrangler.toml` para Cloudflare Workers
- ✅ `schema.sql` para la base de datos
- ✅ `README.md` actualizado

## Paso 2: Crear repositorio en GitHub

### Opción A: Desde GitHub.com (Recomendado)

1. Ve a https://github.com/new
2. **Repository name**: `mi-fudo-pro`
3. **Description**: Sistema de Gestión de Pedidos para Restaurantes
4. **Visibility**: Private (si deseas privado) o Public
5. NO inicialices con README (ya tienes uno)
6. Click en "Create repository"

### Opción B: Desde Terminal

Si ya tienes GitHub configurado:

```bash
cd "c:\Users\Patricio\RESPALDO FUDO MIO - copia\mi-fudo-pro"

# Inicializar git si no está
git init

# Agregar todos los archivos
git add .

# Hacer primer commit
git commit -m "Initial commit: Sistema Mi Fudo Pro v1.0"

# Agregar remoto (reemplaza TU_USUARIO)
git remote add origin https://github.com/TU_USUARIO/mi-fudo-pro.git

# Subir a main
git branch -M main
git push -u origin main
```

## Paso 3: Configurar Cloudflare Workers y D1

### 1. Instalar Wrangler CLI

```bash
npm install -g wrangler
```

### 2. Autenticarse en Cloudflare

```bash
wrangler login
```

Se abrirá tu navegador para autorizar.

### 3. Crear Base de Datos D1

```bash
wrangler d1 create mi-fudo-pro
```

**OUTPUT IMPORTANTE**: Copia el `database_id` que aparece (similar a: `xxxxx-xxxxx-xxxxx`)

### 4. Ejecutar Migraciones

```bash
# Obtén el ID de arriba y ejecuta:
wrangler d1 execute mi-fudo-pro --file=./schema.sql
```

Esto crea todas las tablas en la base de datos.

### 5. Actualizar wrangler.toml

Reemplaza el `database_id`:

```toml
[[d1_databases]]
binding = "DB"
database_name = "mi-fudo-pro"
database_id = "TU_DATABASE_ID_AQUI"  # Reemplaza esto
```

## Paso 4: Desplegar a Cloudflare Workers

```bash
# Desplegar a desarrollo
wrangler deploy

# O a producción (si tienes configurado en wrangler.toml)
wrangler deploy --env production
```

**Resultado**: Tu aplicación estará disponible en:
```
https://mi-fudo-pro.TU_USUARIO.workers.dev
```

## Paso 5: Configurar Dominio (Opcional)

Si tienes un dominio personalizado:

1. Ve a tu panel de Cloudflare
2. Selecciona tu cuenta → Workers
3. Haz clic en "mi-fudo-pro"
4. Ve a Settings → Routes
5. Agrega tu dominio

Ejemplo:
```
Route: ejemplo.com/*
Worker: mi-fudo-pro
```

## 📊 Comandos Útiles

```bash
# Ver estado de despliegue
wrangler deployments

# Ver logs en tiempo real
wrangler tail

# Ejecutar SQL en la base de datos
wrangler d1 execute mi-fudo-pro --command "SELECT * FROM productos"

# Backup de la BD
wrangler d1 backup mi-fudo-pro

# Crear una nueva BD (si necesitas otra)
wrangler d1 create mi-fudo-pro-backup
```

## 🔍 Verificar que todo funciona

### 1. Acceder a tu Worker

Abre: `https://mi-fudo-pro.TU_USUARIO.workers.dev`

### 2. Login

- Usuario: `admin`
- Contraseña: `sushi2026`

### 3. Probar endpoints

```bash
# Verificar que la BD está conectada
curl https://mi-fudo-pro.TU_USUARIO.workers.dev/api/inicializar

# Crear un producto
curl -X POST https://mi-fudo-pro.TU_USUARIO.workers.dev/api/productos \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Test","precio_venta":5000,"categoria":"Test"}'
```

## 🐛 Solucionar Problemas

### Error: "database_id not found"
**Solución**: 
- Verifica que `wrangler.toml` tiene el ID correcto
- Ejecuta `wrangler d1 list` para ver tu BD

### Error: "CORS"
**Solución**:
- El código ya tiene CORS habilitado
- Si persiste, verifica `wrangler.toml`

### Error: "Tabla no existe"
**Solución**:
```bash
wrangler d1 execute mi-fudo-pro --file=./schema.sql
```

### Data no persiste
**Solución**:
- Asegúrate de usar D1 en tu Worker
- Verifica que `binding = "DB"` está correcto

## 📝 Actualizar después del Despliegue

Después de cambios locales:

```bash
# Commit a GitHub
git add .
git commit -m "Describe los cambios"
git push origin main

# Desplegar a Cloudflare
npm run deploy
```

## 🚨 Importante

- **NO commits credenciales** - `.env` está en `.gitignore`
- **Backup regular** - Usa `wrangler d1 backup`
- **Monitorea logs** - `wrangler tail` te muestra errors
- **Testing** - Prueba en desarrollo antes de producción

## 📞 Recursos

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [D1 Database Docs](https://developers.cloudflare.com/d1/)
- [Wrangler CLI Docs](https://developers.cloudflare.com/workers/wrangler/)
- [GitHub Getting Started](https://docs.github.com/en/get-started)

---

**¡Listo!** Tu aplicación está en línea con BD persistente en Cloudflare. 🎉
