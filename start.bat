@echo off
color 0A
echo ========================================
echo Limpiando proyecto Flutter...
echo ========================================
echo.

REM Cambiar al directorio del script
cd /d "%~dp0"

REM Limpiar con Flutter Clean (comando oficial)
echo [1/5] Ejecutando flutter clean...
flutter clean
if errorlevel 1 (
    echo ERROR: flutter clean fallo
    pause
    exit /b 1
)
echo.

REM Eliminar carpetas adicionales que pueden causar conflictos
echo [2/5] Eliminando carpetas de build adicionales...
if exist "build" (
    echo Eliminando carpeta build...
    rmdir /s /q "build" 2>nul
)

if exist ".dart_tool" (
    echo Eliminando carpeta .dart_tool...
    rmdir /s /q ".dart_tool" 2>nul
)

if exist ".flutter-plugins" (
    echo Eliminando archivo .flutter-plugins...
    del /f /q ".flutter-plugins" 2>nul
)

if exist ".flutter-plugins-dependencies" (
    echo Eliminando archivo .flutter-plugins-dependencies...
    del /f /q ".flutter-plugins-dependencies" 2>nul
)

if exist ".packages" (
    echo Eliminando archivo .packages...
    del /f /q ".packages" 2>nul
)
echo.

REM Limpiar Android
echo [3/5] Limpiando archivos de Android...
if exist "android\.gradle" (
    echo Eliminando android\.gradle...
    rmdir /s /q "android\.gradle" 2>nul
)

if exist "android\app\build" (
    echo Eliminando android\app\build...
    rmdir /s /q "android\app\build" 2>nul
)

if exist "android\.idea" (
    echo Eliminando android\.idea...
    rmdir /s /q "android\.idea" 2>nul
)

if exist "android\build" (
    echo Eliminando android\build...
    rmdir /s /q "android\build" 2>nul
)
echo.

REM Limpiar iOS
echo [4/5] Limpiando archivos de iOS...
if exist "ios\Pods" (
    echo Eliminando ios\Pods...
    rmdir /s /q "ios\Pods" 2>nul
)

if exist "ios\.symlinks" (
    echo Eliminando ios\.symlinks...
    rmdir /s /q "ios\.symlinks" 2>nul
)

if exist "ios\Flutter\Flutter.framework" (
    echo Eliminando ios\Flutter\Flutter.framework...
    rmdir /s /q "ios\Flutter\Flutter.framework" 2>nul
)

if exist "ios\Flutter\Flutter.podspec" (
    echo Eliminando ios\Flutter\Flutter.podspec...
    del /f /q "ios\Flutter\Flutter.podspec" 2>nul
)

if exist "ios\Podfile.lock" (
    echo Eliminando ios\Podfile.lock...
    del /f /q "ios\Podfile.lock" 2>nul
)
echo.

REM Obtener dependencias
echo [5/5] Obteniendo dependencias de Flutter...
flutter pub get
if errorlevel 1 (
    echo ERROR: flutter pub get fallo
    pause
    exit /b 1
)
echo.

echo ========================================
echo Limpieza completada exitosamente!
echo ========================================
echo.
echo El proyecto esta listo para ejecutarse.
echo Puedes ejecutar ahora: flutter run
echo.
color 07
pause

