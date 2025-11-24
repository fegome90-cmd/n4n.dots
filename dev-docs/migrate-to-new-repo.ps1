# ==============================================================================
# Script de Migración: Separar Fork de Repositorio Original (PowerShell)
# ==============================================================================
# Este script automatiza el proceso de migrar tu fork a un repositorio
# completamente independiente en Windows.
#
# Uso: .\migrate-to-new-repo.ps1 -NewRepoUrl <URL>
# Ejemplo: .\migrate-to-new-repo.ps1 -NewRepoUrl "https://github.com/fegome90-cmd/nvim-nursing.git"
# ==============================================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$NewRepoUrl
)

# Colores para output
function Write-Header {
    param([string]$Message)
    Write-Host "`n===================================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "===================================================`n" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Confirm-Action {
    param([string]$Message)
    $response = Read-Host "$Message (y/n)"
    return $response -match '^[Yy]$'
}

# ==============================================================================
# Banner
# ==============================================================================

Clear-Host
Write-Header "Migración de Repositorio Fork → Independiente"

Write-Host "Este script te ayudará a migrar tu proyecto a un nuevo repositorio"
Write-Host "completamente independiente del original.`n"

Write-Host "IMPORTANTE:" -ForegroundColor Yellow
Write-Host "  1. Asegúrate de haber creado el nuevo repositorio en GitHub"
Write-Host "  2. El nuevo repo debe estar VACÍO (sin README, .gitignore, etc)"
Write-Host "  3. Todos tus cambios locales deben estar commiteados`n"

Write-Host "Nuevo repositorio: " -NoNewline
Write-Host $NewRepoUrl -ForegroundColor Green
Write-Host ""

if (-not (Confirm-Action "¿Continuar con la migración?")) {
    Write-Warning "Migración cancelada por el usuario"
    exit 0
}

# ==============================================================================
# Verificaciones previas
# ==============================================================================

Write-Header "Paso 1: Verificaciones Previas"

# Verificar que estamos en un repo git
if (-not (Test-Path .git)) {
    Write-Error "Error: No estás en un repositorio git"
    exit 1
}
Write-Success "Repositorio git detectado"

# Verificar que no hay cambios sin commit
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Error "Error: Hay cambios sin commitear"
    Write-Host "`nPor favor, commitea o stash tus cambios antes de continuar:"
    Write-Host "  git add ."
    Write-Host "  git commit -m 'chore: preparing for migration'`n"
    exit 1
}
Write-Success "No hay cambios pendientes"

# Mostrar remotes actuales
Write-Host "`nRemotes actuales:"
git remote -v | ForEach-Object { Write-Host "  $_" }
Write-Host ""

# ==============================================================================
# Backup de configuración actual
# ==============================================================================

Write-Header "Paso 2: Backup de Configuración"

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupFile = ".git-remotes-backup-$timestamp.txt"
git remote -v | Out-File -FilePath $backupFile
Write-Success "Backup guardado en: $backupFile"

# ==============================================================================
# Obtener información del repo actual
# ==============================================================================

$currentBranch = git branch --show-current
Write-Success "Rama actual: $currentBranch"

# ==============================================================================
# Eliminar remotes antiguos
# ==============================================================================

Write-Header "Paso 3: Limpiar Remotes Antiguos"

$remotes = git remote

if (-not $remotes) {
    Write-Warning "No hay remotes configurados"
} else {
    Write-Host "Se eliminarán los siguientes remotes:"
    $remotes | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""

    if (Confirm-Action "¿Eliminar estos remotes?") {
        foreach ($remote in $remotes) {
            git remote remove $remote
            Write-Success "Remote '$remote' eliminado"
        }
    } else {
        Write-Warning "Remotes no eliminados. Cancelando migración."
        exit 0
    }
}

# ==============================================================================
# Agregar nuevo remote
# ==============================================================================

Write-Header "Paso 4: Configurar Nuevo Remote"

git remote add origin $NewRepoUrl
Write-Success "Nuevo remote 'origin' agregado"

Write-Host "`nConfiguración actual:"
git remote -v | ForEach-Object { Write-Host "  $_" }
Write-Host ""

# ==============================================================================
# Push al nuevo repositorio
# ==============================================================================

Write-Header "Paso 5: Push al Nuevo Repositorio"

Write-Host "Se hará push de todas las ramas y tags al nuevo repositorio`n"

if (-not (Confirm-Action "¿Continuar con el push?")) {
    Write-Warning "Push cancelado. Tu repo local apunta al nuevo remote pero no se ha subido nada."
    Write-Host "`nPara hacer push manualmente más tarde:"
    Write-Host "  git push -u origin --all"
    Write-Host "  git push -u origin --tags"
    exit 0
}

Write-Host ""
Write-Success "Haciendo push de todas las ramas..."

try {
    git push -u origin --all 2>&1 | Out-Null
    Write-Success "Todas las ramas subidas exitosamente"
} catch {
    Write-Error "Error al hacer push de las ramas"
    Write-Host "`nPosibles soluciones:"
    Write-Host "  1. Verifica que la URL del repo sea correcta"
    Write-Host "  2. Asegúrate de tener permisos de escritura"
    Write-Host "  3. Verifica tu autenticación (token o SSH key)`n"
    Write-Host "Para reintentar manualmente:"
    Write-Host "  git push -u origin --all --force  # CUIDADO con --force"
    exit 1
}

Write-Host ""
Write-Success "Haciendo push de todos los tags..."

try {
    git push -u origin --tags 2>&1 | Out-Null
    Write-Success "Todos los tags subidos exitosamente"
} catch {
    Write-Warning "No hay tags para subir (esto es normal)"
}

# ==============================================================================
# Verificación final
# ==============================================================================

Write-Header "Paso 6: Verificación Final"

Write-Host "Configuración final del repositorio:`n"
git remote -v | ForEach-Object { Write-Host "  $_" }
Write-Host ""

$lastCommit = git log -1 --oneline
Write-Success "Rama actual: $(git branch --show-current)"
Write-Success "Último commit: $lastCommit"

# ==============================================================================
# Instrucciones post-migración
# ==============================================================================

Write-Header "¡Migración Completada! 🎉"

Write-Host "Tu proyecto ahora está en un repositorio completamente independiente.`n"

Write-Host "Próximos pasos recomendados:`n" -ForegroundColor Green

Write-Host "1. Verifica en GitHub que todo se subió correctamente:"
Write-Host "   " -NoNewline
Write-Host "Abre tu navegador y verifica el nuevo repo" -ForegroundColor Blue
Write-Host ""

Write-Host "2. Confirma que ya NO aparece 'forked from [repo-original]'`n"

Write-Host "3. Actualiza la documentación:"
Write-Host "   - README.md (cambia URLs y referencias)"
Write-Host "   - LICENSE (agrega tu copyright)"
Write-Host "   - Archivos en dev-docs/`n"

Write-Host "4. (Opcional) Renombra el proyecto para darle identidad propia:"
Write-Host "   - Cambia 'GentlemanNvim' → 'NursingNvim' o similar"
Write-Host "   - Actualiza nombres en configuraciones`n"

Write-Host "5. (Opcional) Si todo está bien, elimina el fork viejo en GitHub:"
Write-Host "   Settings → Danger Zone → Delete this repository`n"

Write-Host "Información de backup:" -ForegroundColor Yellow
Write-Host "  - Backup de remotes guardado en: $backupFile`n"

Write-Host "¡Tu proyecto ahora es 100% independiente!" -ForegroundColor Green
Write-Host ""

# ==============================================================================
# Guía de renombramiento
# ==============================================================================

if (Confirm-Action "`n¿Deseas ver una guía de renombramiento del proyecto?") {
    Write-Host @"

================================================================================
Guía Rápida: Renombrar el Proyecto (PowerShell)
================================================================================

1. BUSCAR REFERENCIAS A "GENTLEMAN"

   # Buscar en archivos Markdown
   Get-ChildItem -Recurse -Include *.md | Select-String "Gentleman"

   # Buscar en archivos Lua
   Get-ChildItem -Recurse -Include *.lua | Select-String "Gentleman"

2. REEMPLAZAR EN ARCHIVOS PRINCIPALES

   # Cambiar GentlemanNvim → NursingNvim en README.md
   `$content = Get-Content README.md -Raw
   `$content = `$content -replace 'GentlemanNvim', 'NursingNvim'
   `$content = `$content -replace 'Gentleman\.Dots', 'NursingNvim'
   `$content | Set-Content README.md

3. ACTUALIZAR URLs DEL REPOSITORIO

   # Buscar referencias al repo viejo
   Get-ChildItem -Recurse -Include *.md | Select-String "n4n\.dots"

   # Reemplazar en dev-docs
   Get-ChildItem dev-docs/*.md | ForEach-Object {
       `$content = Get-Content `$_.FullName -Raw
       `$content = `$content -replace 'n4n\.dots', 'nvim-nursing'
       `$content | Set-Content `$_.FullName
   }

4. EDITAR README MANUALMENTE

   # Abrir en tu editor favorito
   notepad README.md
   # O si tienes nvim instalado:
   nvim README.md

   Cambiar:
   - Título del proyecto
   - Descripción
   - Badges/shields
   - Enlaces de instalación

5. COMMIT DE CAMBIOS

   git add .
   git commit -m "rebrand: rename project to NursingNvim"
   git push origin main

================================================================================

"@
}

Write-Header "Fin del Script de Migración"
