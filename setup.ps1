# Detectar dónde está la carpeta dotfiles
$DotfilesDir = "$HOME\dotfiles"
$ProfileDir = Split-Path $PROFILE

# Crear carpeta de perfil si no existe
if (!(Test-Path $ProfileDir)) { New-Item -ItemType Directory -Path $ProfileDir }

$eSuccess = [char]0x2705
$eError = [char]0x274C
$eInfo = "$([char]0x2139)$([char]0xFE0F)"
$eWarning = "$([char]0x26A0)$([char]0xFE0F)"

# 0. Instalar dependencias (Oh-My-Posh)
Write-Host "Verificando dependencias..." -ForegroundColor Cyan
if (!(Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "$eWarning  Oh-My-Posh no encontrado. Instalando..." -ForegroundColor Yellow
    try {
        winget install JanDeDobbeleer.OhMyPosh --source winget
        Write-Host "$eSuccess Oh-My-Posh instalado. Por favor reinicia tu terminal al finalizar." -ForegroundColor Green
    } catch {
        Write-Host "$eError Error instalando Oh-My-Posh. Intenta manual: winget install JanDeDobbeleer.OhMyPosh" -ForegroundColor Red
    }
} else {
    Write-Host "$eSuccess Oh-My-Posh ya está instalado." -ForegroundColor Green
}

# 1. Enlazar el perfil de PowerShell
# En Windows usamos HardLinks o copiamos, los symlinks a veces requieren permisos de admin
Write-Host "Configurando perfil de PowerShell..." -ForegroundColor Cyan

$SourceProfile = "$DotfilesDir\windows\Microsoft.PowerShell_profile.ps1"

if (Test-Path $SourceProfile) {
    # Opción A: Copiar (Más seguro en Windows)
    Copy-Item -Path $SourceProfile -Destination $PROFILE -Force

    # Opción B: Sourcear (Mejor para actualizaciones)
    # Escribe una línea en tu perfil real que llame al archivo del repo
    $ImportLine = ". $SourceProfile"
    if (!(Select-String -Path $PROFILE -Pattern $ImportLine -SimpleMatch -Quiet)) {
        Add-Content -Path $PROFILE -Value $ImportLine -ErrorAction SilentlyContinue
        Write-Host "$eSuccess Perfil vinculado." -ForegroundColor Green
    } else {
        Write-Host "$eInfo  El perfil ya estaba vinculado." -ForegroundColor Cyan
    }

    Write-Host "$eSuccess Configuracion finalizada." -ForegroundColor Green
} else {
    Write-Host "$eWarning No se encontró el perfil en el repo." -ForegroundColor Yellow
}
