# Detectar dónde está la carpeta dotfiles
$DotfilesDir = "$HOME\dotfiles"
$ProfileDir = Split-Path $PROFILE

# Crear carpeta de perfil si no existe
if (!(Test-Path $ProfileDir)) { New-Item -ItemType Directory -Path $ProfileDir }

$eSuccess = [char]0x2705
$eError = [char]0x274C
$eInfo = "$([char]0x2139)$([char]0xFE0F)"
$eWarning = "$([char]0x26A0)$([char]0xFE0F)"

# 0. Instalar dependencias
Write-Host "Verificando dependencias..." -ForegroundColor Cyan

# Oh-My-Posh
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

# PowerShell Core (Upgrade if < 7)
Write-Host "Verificando versión de PowerShell..." -ForegroundColor Cyan
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "$eWarning Estás usando PowerShell 5 (Legacy). Instalando PowerShell 7..." -ForegroundColor Yellow
    try {
        winget install Microsoft.PowerShell --source winget
        Write-Host "$eSuccess PowerShell 7 instalado/actualizado." -ForegroundColor Green
        Write-Host "$eInfo    IMPORTANTE: Deberás abrir 'PowerShell 7' (pwsh) en lugar de 'Windows PowerShell' para ver los cambios." -ForegroundColor Cyan
    } catch {
        Write-Host "$eError Error actualizando PowerShell. Intenta: winget install Microsoft.PowerShell" -ForegroundColor Red
    }
} else {
    Write-Host "$eSuccess Usando PowerShell Moderno (v$($PSVersionTable.PSVersion.ToString())). Genial!" -ForegroundColor Green
}

# PSReadLine (Update to fix OMP errors)
Write-Host "Verificando PSReadLine..." -ForegroundColor Cyan
try {
    # Check version or just force install/update for CurrentUser
    Install-Module PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -AllowPrerelease -ErrorAction Stop
    Write-Host "$eSuccess PSReadLine actualizado." -ForegroundColor Green
} catch {
    Write-Host "$eWarning No se pudo actualizar PSReadLine. Si ves errores de 'KeyHandler', intenta ejecutar como Admin: Install-Module PSReadLine -Force" -ForegroundColor Yellow
}

# 1. Enlazar el perfil de PowerShell
# En Windows usamos HardLinks o copiamos, los symlinks a veces requieren permisos de admin
Write-Host "Configurando perfil de PowerShell..." -ForegroundColor Cyan

$SourceProfile = "$DotfilesDir\windows\Microsoft.PowerShell_profile.ps1"

if (Test-Path $SourceProfile) {
    # Reescribir el perfil para evitar duplicados y conflictos
    # Opción Única: Sourcear (Mejor para actualizaciones)
    $ImportLine = ". '$SourceProfile'"

    # Crear backup si existe y no es solo nuestro link
    if (Test-Path $PROFILE) {
        $Content = Get-Content $PROFILE -Raw
        if ($Content -notmatch "Microsoft.PowerShell_profile.ps1") {
            Copy-Item $PROFILE "$PROFILE.bak" -Force
            Write-Host "$eInfo  Backup creado en $PROFILE.bak" -ForegroundColor Cyan
        }
    }

    # Sobreescribir con el link limpio
    Set-Content -Path $PROFILE -Value $ImportLine -Force
    Write-Host "$eSuccess Perfil vinculado correctamente." -ForegroundColor Green

    Write-Host "$eSuccess Configuración finalizada." -ForegroundColor Green
} else {
    Write-Host "$eWarning No se encontró el perfil en el repo." -ForegroundColor Yellow
}
