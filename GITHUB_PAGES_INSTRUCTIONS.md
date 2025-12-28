# Instrucciones para Publicar la Política de Privacidad en GitHub Pages

## Pasos para publicar el archivo HTML

### 1. Crear un repositorio en GitHub (si no tienes uno)

1. Ve a [GitHub.com](https://github.com) e inicia sesión
2. Haz clic en el botón "+" (arriba a la derecha) y selecciona "New repository"
3. Nombra el repositorio (ejemplo: `imcapp-privacy` o `imcapp`)
4. Marca como **público** (necesario para GitHub Pages gratis)
5. Haz clic en "Create repository"

### 2. Subir el archivo HTML

**Opción A: Desde la web de GitHub**
1. En tu repositorio, haz clic en "Add file" → "Upload files"
2. Arrastra el archivo `privacy_policy.html` a la página
3. Haz clic en "Commit changes"

**Opción B: Desde Git (línea de comandos)**
```bash
git init
git add privacy_policy.html
git commit -m "Add privacy policy"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/TU-REPOSITORIO.git
git push -u origin main
```

### 3. Activar GitHub Pages

1. Ve a tu repositorio en GitHub
2. Haz clic en "Settings" (Configuración)
3. En el menú lateral, busca "Pages"
4. En "Source", selecciona "Deploy from a branch"
5. Selecciona la rama "main" y la carpeta "/ (root)"
6. Haz clic en "Save"
7. Espera unos minutos y GitHub te dará una URL como:
   `https://TU-USUARIO.github.io/TU-REPOSITORIO/privacy_policy.html`

### 4. Actualizar la URL en la app

Una vez que tengas la URL de GitHub Pages, actualiza el archivo:
`lib/screens/about_screen.dart`

Busca la línea 58 y cambia:
```dart
const url = 'https://tu-usuario.github.io/imcapp/privacy_policy.html';
```

Por tu URL real:
```dart
const url = 'https://TU-USUARIO.github.io/TU-REPOSITORIO/privacy_policy.html';
```

## Nota importante

- El repositorio debe ser **público** para usar GitHub Pages gratis
- La URL será permanente una vez configurada
- Puedes actualizar el HTML cuando quieras, solo haz commit y push

