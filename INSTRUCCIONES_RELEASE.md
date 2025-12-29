# Instrucciones para Crear el Release en GitHub

## Opción 1: Usar el Script de PowerShell (Recomendado)

1. **Obtener un Token de GitHub:**
   - Ve a: https://github.com/settings/tokens
   - Haz clic en "Generate new token (classic)"
   - Dale un nombre como "imcapp-release"
   - Selecciona el scope `repo` (permisos completos)
   - Copia el token generado

2. **Ejecutar el script:**
   ```powershell
   .\create_release.ps1 -GitHubToken "TU_TOKEN_AQUI"
   ```

   O con parámetros personalizados:
   ```powershell
   .\create_release.ps1 -GitHubToken "TU_TOKEN_AQUI" -Version "1.1.0"
   ```

## Opción 2: Crear el Release Manualmente desde GitHub

1. Ve a: https://github.com/operonte/imcapp/releases/new

2. Completa el formulario:
   - **Tag version:** `v1.1.0`
   - **Release title:** `v1.1.0`
   - **Description:** Copia el contenido del archivo `RELEASE_NOTES.md` (si existe) o usa:
     ```
     ## Calculadora IMC v1.1.0
     
     Descarga e instala la aplicación directamente en tu dispositivo Android.
     
     ### Características
     - Calculadora de IMC con validación completa
     - Gestión de usuarios múltiples
     - Historial de progreso
     - Estadísticas y gráficos
     - Exportar datos a PDF
     - Modo oscuro/claro/sistema
     - Soporte multiidioma
     ```

3. **Arrastra y suelta** el archivo `release/imcapp-v1.1.0.apk` en la sección de archivos

4. Haz clic en **"Publish release"**

## Opción 3: Usar GitHub CLI (si lo tienes instalado)

```bash
gh release create v1.1.0 release/imcapp-v1.1.0.apk --title "v1.1.0" --notes "Calculadora IMC v1.1.0 - Descarga la APK para Android"
```

## Verificar que Funciona

Una vez creado el release, verifica que el enlace funcione:
- https://github.com/operonte/imcapp/releases/latest

El enlace en el README debería funcionar correctamente y mostrar la última versión disponible.

