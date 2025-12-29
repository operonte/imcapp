# Guía Completa para Subir el Proyecto a GitHub

## Paso 1: Preparar el Proyecto

El proyecto ya está limpio gracias a `cleanapp`. Ahora verificamos que todo esté listo.

## Paso 2: Crear Repositorio en GitHub

1. Ve a [GitHub.com](https://github.com) e inicia sesión
2. Haz clic en el botón **"+"** (arriba a la derecha) → **"New repository"**
3. Configura el repositorio:
   - **Nombre**: `imcapp` (o el que prefieras)
   - **Descripción**: "Calculadora de IMC - Aplicación Flutter"
   - **Visibilidad**: Público (necesario para GitHub Pages gratis)
   - **NO marques** "Add a README file" (ya tienes uno)
   - **NO marques** "Add .gitignore" (ya tienes uno)
4. Haz clic en **"Create repository"**

## Paso 3: Inicializar Git en tu Proyecto (si no está inicializado)

Abre PowerShell o Terminal en la carpeta del proyecto y ejecuta:

```bash
# Verificar si ya hay un repositorio git
git status
```

Si dice "not a git repository", ejecuta:

```bash
# Inicializar git
git init
```

## Paso 4: Agregar Archivos al Repositorio

```bash
# Agregar todos los archivos (respetando .gitignore)
git add .

# Ver qué archivos se van a subir (opcional, para verificar)
git status
```

## Paso 5: Hacer el Primer Commit

```bash
# Crear el commit inicial
git commit -m "Initial commit: Calculadora IMC v1.1.0"
```

## Paso 6: Conectar con GitHub y Subir

```bash
# Agregar el repositorio remoto (reemplaza TU-USUARIO con tu usuario de GitHub)
git remote add origin https://github.com/TU-USUARIO/imcapp.git

# Cambiar a la rama main (si estás en otra)
git branch -M main

# Subir el código a GitHub
git push -u origin main
```

**Nota**: Si es la primera vez, GitHub te pedirá autenticación. Puedes usar:
- Token de acceso personal (recomendado)
- O autenticación con GitHub CLI

## Paso 7: Configurar GitHub Pages para la Política de Privacidad

1. En tu repositorio de GitHub, ve a **Settings** → **Pages**
2. En **Source**, selecciona:
   - Branch: `main`
   - Folder: `/ (root)`
3. Haz clic en **Save**
4. Espera 1-2 minutos
5. GitHub te dará una URL como: `https://TU-USUARIO.github.io/imcapp/privacy_policy.html`

## Paso 8: Actualizar la URL en la App

Una vez que tengas la URL de GitHub Pages:

1. Abre `lib/screens/about_screen.dart`
2. Busca la línea 59 (donde dice `const url = ...`)
3. Reemplaza con tu URL real:
   ```dart
   const url = 'https://TU-USUARIO.github.io/imcapp/privacy_policy.html';
   ```

## Paso 9: Verificar que Todo Funcione

1. Abre la app
2. Ve a Configuración → Acerca de
3. Haz clic en "Política de Privacidad"
4. Debe abrirse en el navegador

## Comandos Útiles para el Futuro

```bash
# Ver el estado del repositorio
git status

# Agregar cambios
git add .

# Hacer commit
git commit -m "Descripción de los cambios"

# Subir cambios
git push

# Ver historial
git log
```

## Solución de Problemas

### Si te pide autenticación al hacer push:
1. Ve a GitHub → Settings → Developer settings → Personal access tokens
2. Genera un nuevo token con permisos de "repo"
3. Úsalo como contraseña cuando te lo pida

### Si el repositorio ya existe y quieres actualizarlo:
```bash
git pull origin main  # Descargar cambios primero
git push origin main  # Subir tus cambios
```

