# Piping Tracker — Deploy en Supabase + Vercel

Stack 100% gratuito, sin Base44.

---

## PASO 1 — Crear cuenta en Supabase

1. Ir a https://supabase.com → **Start your project**
2. Crear cuenta con GitHub o email
3. Crear nuevo proyecto: **New Project**
   - Nombre: `pipetrace`
   - Password: (cualquiera, guardalo)
   - Región: South America (São Paulo)
4. Esperar ~2 minutos a que el proyecto se inicialice

---

## PASO 2 — Crear las tablas

1. En el dashboard de Supabase → **SQL Editor** → **New Query**
2. Pegar TODO el contenido del archivo `supabase-schema.sql`
3. Click en **Run** (▶)
4. Verificar que no hay errores

---

## PASO 3 — Obtener las credenciales

1. En Supabase → **Settings** → **API**
2. Copiar:
   - **Project URL** → es tu `VITE_SUPABASE_URL`
   - **anon / public key** → es tu `VITE_SUPABASE_ANON_KEY`

---

## PASO 4 — Instalar y probar local

```bash
# Instalar dependencias
npm install

# Crear archivo de variables de entorno
cp .env.example .env.local

# Editar .env.local con tus datos de Supabase
# (abrir con cualquier editor de texto)

# Iniciar en modo desarrollo
npm run dev
```

Abrir http://localhost:5173 — la app debería funcionar completa.

---

## PASO 5 — Crear cuenta en Vercel

1. Ir a https://vercel.com → **Sign Up**
2. Registrarse con GitHub (recomendado) o email

---

## PASO 6 — Subir el código a GitHub

```bash
# En la carpeta del proyecto
git init
git add .
git commit -m "Piping Tracker inicial"

# Crear repositorio en github.com → New repository → pipetrace
# Luego:
git remote add origin https://github.com/TU_USUARIO/pipetrace.git
git push -u origin main
```

---

## PASO 7 — Deploy en Vercel

1. En Vercel → **Add New Project**
2. Importar el repositorio `pipetrace` de GitHub
3. En **Environment Variables** agregar:
   ```
   VITE_SUPABASE_URL      = https://xxx.supabase.co
   VITE_SUPABASE_ANON_KEY = eyJ...
   ```
4. Click **Deploy**
5. En ~1 minuto tenés la URL pública: `https://pipetrace.vercel.app`

---

## Estructura del proyecto

```
src/
├── lib/
│   └── supabase.js        ← cliente Supabase + helper uploadFile
├── utils/
│   └── ndt.js             ← constantes NDT + cálculos de avance
├── components/layout/
│   └── Layout.jsx         ← navbar
├── pages/
│   ├── Dashboard.jsx      ← listado de líneas
│   ├── LineDetail.jsx     ← detalle + juntas + NDT
│   ├── Soldadores.jsx     ← gestión soldadores
│   └── Analitica.jsx      ← gráficos y métricas
├── App.jsx
└── main.jsx
```

---

## Tablas en Supabase

| Tabla         | Descripción                          |
|---------------|--------------------------------------|
| `projects`    | Proyectos / Obras                    |
| `welders`     | Soldadores con certificaciones       |
| `piping_lines`| Líneas con datos del isométrico      |
| `welds`       | Juntas con 7 ensayos NDT completos   |

## Storage en Supabase

| Bucket         | Uso                              |
|----------------|----------------------------------|
| `reports`      | PDFs de informes NDT por junta   |
| `certificates` | PDFs de certificados de soldadores|
