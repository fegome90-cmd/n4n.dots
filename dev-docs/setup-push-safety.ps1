# ==============================================================================
# Setup Push Safety - Configuración de Seguridad para Push (PowerShell)
# ==============================================================================
# Este script instala medidas de seguridad para asegurar que NUNCA hagas push
# accidentalmente al repositorio de Gentleman Programming.
# ==============================================================================

# Funciones de utilidad
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
Write-Header "🛡️  Configuración de Seguridad para Push"

Write-Host "Este script instalará medidas de seguridad para prevenir push accidental"
Write-Host "al repositorio de Gentleman Programming.`n"

Write-Host "Se instalarán:"
Write-Host "  1. Hook pre-push que bloquea push a repos no deseados"
Write-Host "  2. Alias de git para push seguro con confirmación"
Write-Host "  3. Script safe-push.ps1 para verificación visual`n"

# ==============================================================================
# Verificar que estamos en un repo git
# ==============================================================================

if (-not (Test-Path .git)) {
    Write-Error "Error: No estás en un repositorio git"
    exit 1
}

# ==============================================================================
# Verificar configuración actual
# ==============================================================================

Write-Header "Paso 1: Verificar Configuración Actual"

Write-Host "Remote actual:"
$remoteInfo = git remote -v | Select-String "origin" | Select-Object -First 1
Write-Host $remoteInfo
Write-Host ""

$remoteUrl = git config --get remote.origin.url

# Verificar que NO apunte a Gentleman-Programming
if ($remoteUrl -match "Gentleman-Programming") {
    Write-Error "ADVERTENCIA: Tu remote apunta a Gentleman-Programming"
    Write-Host "`nDeberías cambiar tu remote a TU repositorio:"
    Write-Host "  git remote set-url origin https://github.com/fegome90-cmd/n4n.dots.git`n"

    if (Confirm-Action "¿Quieres que lo cambie automáticamente?") {
        $newUrl = Read-Host "Ingresa la URL de TU repositorio"
        git remote set-url origin $newUrl
        Write-Success "Remote actualizado a: $newUrl"
    } else {
        Write-Warning "Remote no actualizado. Por favor cámbialo manualmente."
    }
} else {
    Write-Success "Remote apunta a tu repositorio"
}

# Verificar upstream
try {
    $upstreamUrl = git config --get remote.upstream.url 2>$null
    if ($upstreamUrl) {
        Write-Warning "Tienes un remote 'upstream' configurado"
        Write-Host "  $upstreamUrl`n"

        if (Confirm-Action "¿Quieres eliminar el upstream?") {
            git remote remove upstream
            Write-Success "Upstream eliminado"
        }
    } else {
        Write-Success "No hay upstream configurado"
    }
} catch {
    Write-Success "No hay upstream configurado"
}

# ==============================================================================
# Instalar Hook Pre-Push
# ==============================================================================

Write-Header "Paso 2: Instalar Hook Pre-Push"

$hookFile = ".git/hooks/pre-push"
$hookDir = ".git/hooks"

# Crear directorio si no existe
if (-not (Test-Path $hookDir)) {
    New-Item -ItemType Directory -Path $hookDir | Out-Null
}

$hookContent = @'
#!/bin/bash
# Pre-push hook para prevenir push a repositorios no deseados

# Obtener la URL del remote
REMOTE_URL=$(git config --get remote.origin.url)

# Lista de patrones bloqueados
BLOCKED_PATTERNS=(
    "Gentleman-Programming"
    "gentleman-programming"
)

# Verificar contra patrones bloqueados
for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$REMOTE_URL" | grep -qi "$pattern"; then
        echo ""
        echo "╔════════════════════════════════════════════════════════════╗"
        echo "║  ❌ ERROR: PUSH BLOQUEADO POR SEGURIDAD                   ║"
        echo "╚════════════════════════════════════════════════════════════╝"
        echo ""
        echo "Intentaste hacer push a: $REMOTE_URL"
        echo ""
        echo "Este remote contiene el patrón bloqueado: '$pattern'"
        echo ""
        echo "Para corregir tu configuración:"
        echo "  git remote set-url origin https://github.com/TU-USUARIO/TU-REPO.git"
        echo ""
        exit 1
    fi
done

# Mostrar confirmación visual
echo "✓ Push permitido a: $REMOTE_URL"
exit 0
'@

$hookContent | Out-File -FilePath $hookFile -Encoding ASCII
Write-Success "Hook pre-push instalado en $hookFile"

# Nota sobre ejecución en Windows
Write-Host "`nNota: En Windows, Git Bash ejecutará este hook automáticamente." -ForegroundColor Cyan

# ==============================================================================
# Configurar Alias de Git
# ==============================================================================

Write-Header "Paso 3: Configurar Alias de Git"

# Alias safe-push
git config alias.safe-push '!f() {
    echo "🔍 Verificando configuración...";
    echo "";
    echo "Remote:";
    git remote -v | grep origin | head -1;
    echo "";
    echo "Rama: $(git branch --show-current)";
    echo "";
    echo "Últimos commits:";
    git log --oneline -3;
    echo "";
    read -p "¿Hacer push con estos cambios? (y/n) " -n 1 -r;
    echo;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push "$@";
    else
        echo "❌ Push cancelado";
        return 1;
    fi;
}; f'

Write-Success "Alias 'git safe-push' configurado"

# Alias verify-remote
git config alias.verify-remote '!f() {
    echo "═══════════════════════════════════════════════════════════";
    echo "  🔍 VERIFICACIÓN DE CONFIGURACIÓN";
    echo "═══════════════════════════════════════════════════════════";
    echo "";
    echo "📡 Remotes:";
    git remote -v;
    echo "";
    echo "🌿 Rama actual: $(git branch --show-current)";
    echo "";
    echo "📝 Últimos 3 commits:";
    git log --oneline -3;
    echo "";
}; f'

Write-Success "Alias 'git verify-remote' configurado"

# ==============================================================================
# Crear Script safe-push.ps1
# ==============================================================================

Write-Header "Paso 4: Crear Script safe-push.ps1"

$safePushContent = @'
# Safe Push Script - Verificación antes de push

Write-Host "═══════════════════════════════════════════════════════════"
Write-Host "  🛡️  VERIFICACIÓN DE SEGURIDAD ANTES DE PUSH"
Write-Host "═══════════════════════════════════════════════════════════"
Write-Host ""

# Mostrar remote
Write-Host "📡 Remote actual:"
$remoteInfo = git remote -v | Select-String "origin" | Select-Object -First 1
Write-Host $remoteInfo
Write-Host ""

# Verificar que NO sea Gentleman-Programming
$remoteUrl = git config --get remote.origin.url
if ($remoteUrl -match "Gentleman-Programming") {
    Write-Host "❌ PELIGRO: Este remote apunta a Gentleman-Programming" -ForegroundColor Red
    Write-Host "❌ PUSH BLOQUEADO PARA TU SEGURIDAD" -ForegroundColor Red
    Write-Host "`nCambia tu remote con:"
    Write-Host "  git remote set-url origin https://github.com/TU-USUARIO/TU-REPO.git"
    exit 1
}

# Mostrar rama y commit
Write-Host "🌿 Rama actual:"
$currentBranch = git branch --show-current
Write-Host $currentBranch
Write-Host ""

Write-Host "📝 Últimos commits:"
git log --oneline -3
Write-Host ""

# Confirmación
$confirmation = Read-Host "¿Hacer push de estos cambios? (y/n)"

if ($confirmation -match '^[Yy]$') {
    Write-Host "🚀 Haciendo push de '$currentBranch' a origin..."

    git push origin $currentBranch

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Push exitoso a: $remoteUrl" -ForegroundColor Green
        Write-Host ""

        # Extraer URL de GitHub si es posible
        if ($remoteUrl -match "github.com[:/]([^/]+)/([^.]+)") {
            $githubUrl = "https://github.com/$($matches[1])/$($matches[2])"
            Write-Host "Verifica en GitHub:"
            Write-Host "  $githubUrl"
        }
    } else {
        Write-Host ""
        Write-Host "❌ Error en el push" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Push cancelado" -ForegroundColor Yellow
    exit 0
}
'@

$safePushContent | Out-File -FilePath "safe-push.ps1" -Encoding UTF8
Write-Success "Script safe-push.ps1 creado en la raíz del proyecto"

# ==============================================================================
# Resumen Final
# ==============================================================================

Write-Header "✅ Configuración Completada"

Write-Host "Las siguientes medidas de seguridad han sido instaladas:`n"

Write-Host "1. 🔒 Hook pre-push (.git/hooks/pre-push)"
Write-Host "   - Bloquea automáticamente push a Gentleman-Programming"
Write-Host "   - Se ejecuta en CADA push`n"

Write-Host "2. 🛠️  Alias de Git"
Write-Host "   - 'git safe-push [branch]' - Push con confirmación"
Write-Host "   - 'git verify-remote' - Verificar configuración rápidamente`n"

Write-Host "3. 📜 Script safe-push.ps1"
Write-Host "   - Ejecuta: .\safe-push.ps1"
Write-Host "   - Verificación visual completa antes de push`n"

Write-Host "Comandos disponibles:" -ForegroundColor Green
Write-Host ""
Write-Host "  git verify-remote              # Verificar configuración"
Write-Host "  git safe-push origin main      # Push con confirmación"
Write-Host "  .\safe-push.ps1                # Push con verificación visual (PowerShell)`n"

Write-Host "Para push normal (con protección de hook):" -ForegroundColor Blue
Write-Host "  git push origin main           # El hook te protegerá`n"

Write-Host "═══════════════════════════════════════════════════════════"
Write-Host ""

# Verificación final
Write-Host "🔍 Verificación final de tu configuración:`n"
git remote -v | Select-String "origin"
Write-Host ""
Write-Success "¡Estás protegido! Todos tus push van a TU repositorio."
Write-Host ""
