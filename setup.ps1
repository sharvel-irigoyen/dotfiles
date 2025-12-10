# Detectar dónde está la carpeta dotfiles
$DotfilesDir = "$HOME\dotfiles"
$ProfileDir = Split-Path $PROFILE

# Crear carpeta de perfil si no existe
if (!(Test-Path $ProfileDir)) { New-Item -ItemType Directory -Path $ProfileDir }

# 1. Enlazar el perfil de PowerShell
# En Windows usamos HardLinks o copiamos, los symlinks a veces requieren permisos de admin
Write-Host "Configurando perfil de PowerShell..." -ForegroundColor Cyan

$SourceProfile = "$DotfilesDir\windows\Microsoft.PowerShell_profile.ps1"

if (Test-Path $SourceProfile) {
    # Opción A: Copiar (Más seguro en Windows)
    Copy-Item -Path $SourceProfile -Destination $PROFILE -Force

    # Opción B: Sourcear (Mejor para actualizaciones)
    # Escribe una línea en tu perfil real que llame al archivo del repo
    Add-Content -Path $PROFILE -Value ". $SourceProfile" -ErrorAction SilentlyContinue

    Write-Host "✅ Perfil configurado." -ForegroundColor Green
} else {
    Write-Host "⚠️ No se encontró el perfil en el repo." -ForegroundColor Yellow
}
