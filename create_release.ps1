# Script para crear un release en GitHub con la APK
# Requiere un token de GitHub con permisos de repo

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubToken,
    
    [Parameter(Mandatory=$false)]
    [string]$Version = "1.1.0",
    
    [Parameter(Mandatory=$false)]
    [string]$RepoOwner = "operonte",
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "imcapp"
)

$ErrorActionPreference = "Stop"

Write-Host "Creando release v$Version en GitHub..." -ForegroundColor Green

# URL de la API de GitHub
$apiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/releases"

# Datos del release
$releaseData = @{
    tag_name = "v$Version"
    name = "v$Version"
    body = @"
## Calculadora IMC v$Version

### 📱 Descarga la APK

Descarga e instala la aplicación directamente en tu dispositivo Android.

### ✨ Características

- ✅ Calculadora de IMC con validación completa
- ✅ Gestión de usuarios múltiples
- ✅ Historial de progreso con fechas automáticas
- ✅ Estadísticas y gráficos de evolución
- ✅ Exportar datos a PDF
- ✅ Modo oscuro/claro/sistema configurable
- ✅ Soporte multiidioma (Español/Inglés)
- ✅ Almacenamiento local seguro
- ✅ Interfaz moderna y amigable

### 📥 Instalación

1. Descarga el archivo `imcapp-v$Version.apk`
2. Habilita la instalación desde fuentes desconocidas en tu dispositivo Android
3. Instala la APK
4. ¡Disfruta de la aplicación!

### 🔒 Notas de Seguridad

Esta APK está firmada y lista para producción. Asegúrate de descargarla solo desde este repositorio oficial.
"@
    draft = $false
    prerelease = $false
} | ConvertTo-Json

# Headers para la autenticación
$headers = @{
    "Authorization" = "token $GitHubToken"
    "Accept" = "application/vnd.github.v3+json"
}

try {
    # Crear el release
    Write-Host "Creando el release..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $releaseData -ContentType "application/json"
    
    $releaseId = $response.id
    Write-Host "Release creado con ID: $releaseId" -ForegroundColor Green
    
    # Subir la APK
    $apkPath = "release\imcapp-v$Version.apk"
    if (Test-Path $apkPath) {
        Write-Host "Subiendo APK..." -ForegroundColor Yellow
        
        $uploadUrl = "https://uploads.github.com/repos/$RepoOwner/$RepoName/releases/$releaseId/assets?name=imcapp-v$Version.apk"
        
        $fileBytes = [System.IO.File]::ReadAllBytes((Resolve-Path $apkPath))
        $fileEnc = [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetString($fileBytes)
        
        $uploadHeaders = @{
            "Authorization" = "token $GitHubToken"
            "Accept" = "application/vnd.github.v3+json"
            "Content-Type" = "application/vnd.android.package-archive"
        }
        
        $uploadResponse = Invoke-RestMethod -Uri $uploadUrl -Method Post -Headers $uploadHeaders -Body ([System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($fileEnc))
        
        Write-Host "APK subida exitosamente!" -ForegroundColor Green
        Write-Host "Release disponible en: $($response.html_url)" -ForegroundColor Cyan
    } else {
        Write-Host "Error: No se encontró el archivo APK en $apkPath" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Error al crear el release: $_" -ForegroundColor Red
    Write-Host "Detalles: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n¡Release creado exitosamente!" -ForegroundColor Green
Write-Host "URL del release: $($response.html_url)" -ForegroundColor Cyan

