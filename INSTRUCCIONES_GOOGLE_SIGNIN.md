# 🔐 Instrucciones para Configurar Google Sign-In con Firebase

## ✅ Importante: Seguridad

**SÍ, puedes tener tu repositorio público en GitHub** si sigues estas instrucciones:

- ✅ `google-services.json` NO contiene secretos sensibles
- ✅ Las credenciales reales están en Firebase Console (servidor seguro)
- ✅ Este es el método estándar recomendado por Google y Firebase
- ✅ El archivo `google-services.json` ya está protegido en `.gitignore`

## 📋 Pasos para Configurar

### Paso 1: Crear Proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en **"Agregar proyecto"** (o "Add project")
3. Nombre del proyecto: `imcapp` (o el que prefieras)
4. Puedes desactivar Google Analytics si no lo necesitas
5. Haz clic en **"Crear proyecto"** (o "Create project")

### Paso 2: Agregar App Android

1. En el panel de Firebase, haz clic en el ícono de Android
2. **Package name**: `com.example.imcapp` (debe coincidir con `applicationId` en `build.gradle.kts`)
3. **App nickname**: `IMC App Android` (opcional)
4. Haz clic en **"Registrar app"** (o "Register app")
5. Descarga el archivo `google-services.json`
6. Coloca el archivo en: `android/app/google-services.json`

### Paso 3: Habilitar Google Sign-In en Firebase

1. En Firebase Console, ve a **Authentication**
2. Haz clic en **"Comenzar"** (o "Get started")
3. Ve a la pestaña **"Sign-in method"** (o "Métodos de inicio de sesión")
4. Haz clic en **"Google"**
5. Activa el interruptor para habilitar Google Sign-In
6. Selecciona un **Email de apoyo del proyecto** (tu email)
7. Haz clic en **"Guardar"** (o "Save")

### Paso 4: Configurar SHA-1 (Opcional pero recomendado)

Para usar Google Sign-In en modo Release, necesitas obtener el SHA-1:

**Windows (PowerShell):**
```powershell
cd android
.\gradlew signingReport
```

Busca la línea que dice `SHA1:` y copia el valor. Luego:

1. Ve a Firebase Console → **Configuración del proyecto** (ícono de engranaje)
2. Ve a **"Tus apps"** → Selecciona tu app Android
3. Haz clic en **"Agregar huella digital"**
4. Pega el SHA-1 y guarda

### Paso 5: Instalar Dependencias

Las dependencias ya están agregadas en `pubspec.yaml`. Solo necesitas ejecutar:

```bash
flutter pub get
```

### Paso 6: Configurar Android

Los archivos de Android ya están configurados. Solo necesitas:

1. Asegurarte de que `google-services.json` esté en `android/app/`
2. Si no lo has hecho, ejecuta:
```bash
flutter clean
flutter pub get
```

## 🚀 Uso de Google Sign-In

La app ahora tiene Google Sign-In integrado. Los usuarios pueden:

1. Iniciar sesión con su cuenta de Google
2. Sus datos se sincronizarán con Firebase Authentication
3. Pueden cerrar sesión cuando quieran

## 📝 Notas Importantes

- ✅ **El repositorio puede ser público** - `google-services.json` no contiene secretos
- ✅ **Las credenciales están seguras** - Están en Firebase Console (servidor)
- ✅ **google-services.json ya está en .gitignore** - No se subirá accidentalmente
- ⚠️ **Nunca compartas** tus credenciales de Firebase Console

## 🔒 Verificación de Seguridad

Antes de hacer commit, verifica que estos archivos NO estén en git:

```bash
git status
```

No deberías ver:
- `google-services.json`
- `.env`
- Cualquier archivo `.key` o `.keystore`

Si los ves, ya están protegidos por `.gitignore` y no se subirán.

