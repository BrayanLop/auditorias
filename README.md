# Dashboard de auditorías de calidad (Q10)

Página estática (GitHub Pages) que lee los Excel de auditorías y guarda todo en una base de datos
PostgreSQL de **Supabase**: auditorías, retroalimentaciones y categorizaciones quedan guardadas y
compartidas entre los usuarios autorizados.

## Archivos

| Archivo | Para qué |
|---|---|
| `index.html` | La aplicación (login, carga de Excel, dashboard, detalle por persona, exportar CSV) |
| `config.js` | URL y clave pública de Supabase |
| `supabase/schema.sql` | Tabla, índices y reglas de seguridad de la base de datos |

## Configuración (una sola vez)

### 1. Supabase
1. Crea un proyecto en https://supabase.com (plan gratis).
2. **SQL Editor → New query**: pega `supabase/schema.sql` y ejecútalo.
3. **Authentication → Sign In / Providers → Email**: desactiva **"Allow new users to sign up"**
   (así nadie puede crearse una cuenta por su cuenta).
4. **Authentication → Users → Add user → Create new user**: crea cada usuario con correo y contraseña
   (marca *Auto Confirm User*).
5. **Project Settings → API**: copia la **Project URL** y la **anon public key** en `config.js`.
   Nunca uses la `service_role key` en la página.

### 2. GitHub Pages
1. Crea un repositorio en GitHub y sube estos archivos.
2. **Settings → Pages → Build and deployment**: *Deploy from a branch*, rama `main`, carpeta `/ (root)`.
3. En 1–2 minutos la página queda en `https://<tu-usuario>.github.io/<repositorio>/`.

> Si el repositorio es **público**, el código es visible (no los datos: la base exige iniciar sesión).
> Para que también el código sea privado, el repositorio privado con Pages requiere GitHub Pro o Team.

## Uso
- Inicia sesión con un usuario creado en Supabase.
- **Cargar Excel**: agrega las auditorías nuevas y actualiza las existentes. No borra nada ni pisa
  la retroalimentación o categorización que ya se hayan editado.
- Cada auditoría se identifica por su contenido (canal, persona, fecha, cliente, hallazgo y criterios),
  así que volver a cargar el mismo archivo, aunque cambie de nombre o de orden, no duplica registros.
- La base guarda quién y cuándo modificó cada registro (`actualizado_por`, `actualizado_en`).

## Probar en local
Abre la carpeta con un servidor estático (por ejemplo la extensión *Live Server* de VS Code o
`npx serve .`) y entra a la URL que te indique. Abrir el archivo con doble clic también funciona en la
mayoría de navegadores.
