# 🚀 Guía Paso a Paso: Crear Release en GitHub

## 📋 Pasos para Crear el Release

### Paso 1: Ir a la Página de Crear Release

1. Abre tu navegador y ve a:
   **https://github.com/operonte/imcapp/releases/new**

   O alternativamente:
   - Ve a: https://github.com/operonte/imcapp
   - Haz clic en el botón **"Releases"** (en el menú lateral derecho)
   - Haz clic en **"Create a new release"** o **"Draft a new release"**

### Paso 2: Completar el Formulario

#### 2.1. Tag Version
- En el campo **"Choose a tag"**, escribe: `v1.1.0`
- Si el tag no existe, GitHub te preguntará si quieres crearlo. Selecciona **"Create new tag: v1.1.0 on publish"**

#### 2.2. Release Title
- En el campo **"Release title"**, escribe: `v1.1.0`

#### 2.3. Description (Notas del Release)
- En el campo **"Describe this release"**, copia y pega el contenido del archivo `RELEASE_NOTES_v1.1.0.md`
- O copia este texto:

```
## Calculadora IMC v1.1.0

### 📱 Descarga la APK

Descarga e instala la aplicación directamente en tu dispositivo Android.

### ✨ Características

- ✅ **Calculadora de IMC** con validación completa
- ✅ **Gestión de usuarios** múltiples
- ✅ **Historial de progreso** con fechas automáticas
- ✅ **Estadísticas y gráficos** de evolución
- ✅ **Exportar datos** a PDF
- ✅ **Modo oscuro/claro/sistema** configurable
- ✅ **Soporte multiidioma** (Español/Inglés)
- ✅ **Almacenamiento local** seguro
- ✅ **Interfaz moderna** y amigable

### 📥 Instalación

1. Descarga el archivo `imcapp-v1.1.0.apk`
2. Habilita la instalación desde fuentes desconocidas en tu dispositivo Android
3. Instala la APK
4. ¡Disfruta de la aplicación!

### 🔒 Notas de Seguridad

Esta APK está firmada y lista para producción. Asegúrate de descargarla solo desde este repositorio oficial.
```

### Paso 3: Subir el Archivo APK

1. En la sección **"Attach binaries by dropping them here or selecting them"**:
   - **Opción A:** Arrastra y suelta el archivo `release/imcapp-v1.1.0.apk`
   - **Opción B:** Haz clic en **"selecting them"** y navega hasta la carpeta `release` y selecciona `imcapp-v1.1.0.apk`

2. Espera a que el archivo se suba completamente (verás una barra de progreso)

### Paso 4: Publicar el Release

1. Revisa que todo esté correcto:
   - ✅ Tag: `v1.1.0`
   - ✅ Título: `v1.1.0`
   - ✅ Descripción completa
   - ✅ Archivo APK adjunto

2. Haz clic en el botón **"Publish release"** (botón verde en la parte inferior)

### Paso 5: Verificar que Funciona

1. Una vez publicado, serás redirigido a la página del release
2. Verifica que:
   - El release esté visible
   - El archivo APK esté disponible para descarga
   - La descripción se vea correctamente

3. Prueba el enlace del README:
   - Ve a: https://github.com/operonte/imcapp
   - Haz clic en el enlace de descarga en el README
   - Debe llevarte al release que acabas de crear

## ✅ Checklist Final

- [ ] Tag `v1.1.0` creado
- [ ] Release publicado
- [ ] Archivo APK adjunto y descargable
- [ ] Descripción completa y bien formateada
- [ ] Enlace del README funciona correctamente

## 🔗 Enlaces Útiles

- **Crear Release:** https://github.com/operonte/imcapp/releases/new
- **Ver Releases:** https://github.com/operonte/imcapp/releases
- **Último Release:** https://github.com/operonte/imcapp/releases/latest

## 💡 Notas Importantes

- El archivo APK debe estar en la carpeta `release/` del repositorio
- El nombre del tag debe coincidir con la versión (v1.1.0)
- Una vez publicado, el release no se puede eliminar fácilmente (solo se puede hacer draft)
- El enlace `/releases/latest` siempre apunta al último release publicado

