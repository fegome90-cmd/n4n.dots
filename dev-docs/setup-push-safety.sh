#!/bin/bash
# ==============================================================================
# Setup Push Safety - Configuración de Seguridad para Push
# ==============================================================================
# Este script instala medidas de seguridad para asegurar que NUNCA hagas push
# accidentalmente al repositorio de Gentleman Programming.
# ==============================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}===================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# ==============================================================================
# Banner
# ==============================================================================

clear
print_header "🛡️  Configuración de Seguridad para Push"

echo "Este script instalará medidas de seguridad para prevenir push accidental"
echo "al repositorio de Gentleman Programming."
echo ""
echo "Se instalarán:"
echo "  1. Hook pre-push que bloquea push a repos no deseados"
echo "  2. Alias de git para push seguro con confirmación"
echo "  3. Script safe-push.sh para verificación visual"
echo ""

# ==============================================================================
# Verificar que estamos en un repo git
# ==============================================================================

if [ ! -d .git ]; then
    print_error "Error: No estás en un repositorio git"
    exit 1
fi

# ==============================================================================
# Verificar configuración actual
# ==============================================================================

print_header "Paso 1: Verificar Configuración Actual"

echo "Remote actual:"
git remote -v | grep origin | head -1
echo ""

REMOTE_URL=$(git config --get remote.origin.url)

# Verificar que NO apunte a Gentleman-Programming
if echo "$REMOTE_URL" | grep -qi "Gentleman-Programming"; then
    print_error "ADVERTENCIA: Tu remote apunta a Gentleman-Programming"
    echo ""
    echo "Deberías cambiar tu remote a TU repositorio:"
    echo "  git remote set-url origin https://github.com/fegome90-cmd/n4n.dots.git"
    echo ""
    read -p "¿Quieres que lo cambie automáticamente? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Ingresa la URL de TU repositorio: " NEW_URL
        git remote set-url origin "$NEW_URL"
        print_success "Remote actualizado a: $NEW_URL"
    else
        print_warning "Remote no actualizado. Por favor cámbialo manualmente."
    fi
else
    print_success "Remote apunta a tu repositorio"
fi

# Verificar upstream
if git config --get remote.upstream.url > /dev/null 2>&1; then
    print_warning "Tienes un remote 'upstream' configurado"
    UPSTREAM_URL=$(git config --get remote.upstream.url)
    echo "  $UPSTREAM_URL"
    echo ""
    read -p "¿Quieres eliminar el upstream? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote remove upstream
        print_success "Upstream eliminado"
    fi
else
    print_success "No hay upstream configurado"
fi

# ==============================================================================
# Instalar Hook Pre-Push
# ==============================================================================

print_header "Paso 2: Instalar Hook Pre-Push"

HOOK_FILE=".git/hooks/pre-push"

cat > "$HOOK_FILE" << 'EOF'
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
EOF

chmod +x "$HOOK_FILE"
print_success "Hook pre-push instalado en $HOOK_FILE"

# ==============================================================================
# Configurar Alias de Git
# ==============================================================================

print_header "Paso 3: Configurar Alias de Git"

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

print_success "Alias 'git safe-push' configurado"

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

print_success "Alias 'git verify-remote' configurado"

# ==============================================================================
# Crear Script safe-push.sh
# ==============================================================================

print_header "Paso 4: Crear Script safe-push.sh"

cat > "safe-push.sh" << 'EOF'
#!/bin/bash

echo "═══════════════════════════════════════════════════════════"
echo "  🛡️  VERIFICACIÓN DE SEGURIDAD ANTES DE PUSH"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Mostrar remote
echo "📡 Remote actual:"
git remote -v | grep origin | head -1
echo ""

# Verificar que NO sea Gentleman-Programming
REMOTE_URL=$(git config --get remote.origin.url)
if echo "$REMOTE_URL" | grep -qi "Gentleman-Programming"; then
    echo "❌ PELIGRO: Este remote apunta a Gentleman-Programming"
    echo "❌ PUSH BLOQUEADO PARA TU SEGURIDAD"
    echo ""
    echo "Cambia tu remote con:"
    echo "  git remote set-url origin https://github.com/TU-USUARIO/TU-REPO.git"
    exit 1
fi

# Mostrar rama y commit
echo "🌿 Rama actual:"
git branch --show-current
echo ""

echo "📝 Últimos commits:"
git log --oneline -3
echo ""

# Confirmación
read -p "¿Hacer push de estos cambios? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    BRANCH=$(git branch --show-current)
    echo "🚀 Haciendo push de '$BRANCH' a origin..."
    git push origin "$BRANCH"

    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Push exitoso a: $REMOTE_URL"
        echo ""
        echo "Verifica en GitHub:"
        if echo "$REMOTE_URL" | grep -q "github.com"; then
            GITHUB_URL=$(echo "$REMOTE_URL" | sed -E 's|.*github.com[:/]([^/]+)/([^.]+).*|https://github.com/\1/\2|')
            echo "  $GITHUB_URL"
        fi
    else
        echo ""
        echo "❌ Error en el push"
        exit 1
    fi
else
    echo "❌ Push cancelado"
    exit 0
fi
EOF

chmod +x "safe-push.sh"
print_success "Script safe-push.sh creado en la raíz del proyecto"

# ==============================================================================
# Resumen Final
# ==============================================================================

print_header "✅ Configuración Completada"

echo "Las siguientes medidas de seguridad han sido instaladas:"
echo ""
echo "1. 🔒 Hook pre-push (.git/hooks/pre-push)"
echo "   - Bloquea automáticamente push a Gentleman-Programming"
echo "   - Se ejecuta en CADA push"
echo ""
echo "2. 🛠️  Alias de Git"
echo "   - 'git safe-push [branch]' - Push con confirmación"
echo "   - 'git verify-remote' - Verificar configuración rápidamente"
echo ""
echo "3. 📜 Script safe-push.sh"
echo "   - Ejecuta: ./safe-push.sh"
echo "   - Verificación visual completa antes de push"
echo ""
echo -e "${GREEN}Comandos disponibles:${NC}"
echo ""
echo "  git verify-remote              # Verificar configuración"
echo "  git safe-push origin main      # Push con confirmación"
echo "  ./safe-push.sh                 # Push con verificación visual"
echo ""
echo -e "${BLUE}Para push normal (con protección de hook):${NC}"
echo "  git push origin main           # El hook te protegerá"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""

# Verificación final
echo "🔍 Verificación final de tu configuración:"
echo ""
git remote -v | grep origin
echo ""
print_success "¡Estás protegido! Todos tus push van a TU repositorio."
echo ""
