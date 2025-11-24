#!/bin/bash
# ==============================================================================
# Script de Migración: Separar Fork de Repositorio Original
# ==============================================================================
# Este script automatiza el proceso de migrar tu fork a un repositorio
# completamente independiente.
#
# Uso: ./migrate-to-new-repo.sh <URL-del-nuevo-repo>
# Ejemplo: ./migrate-to-new-repo.sh https://github.com/fegome90-cmd/nvim-nursing.git
# ==============================================================================

set -e  # Salir si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de utilidad
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

confirm() {
    read -p "$(echo -e ${YELLOW}$1${NC}) (y/n): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# ==============================================================================
# Validación de parámetros
# ==============================================================================

if [ -z "$1" ]; then
    print_error "Error: Debes proporcionar la URL del nuevo repositorio"
    echo ""
    echo "Uso: $0 <URL-del-nuevo-repo>"
    echo ""
    echo "Ejemplos:"
    echo "  $0 https://github.com/tu-usuario/nvim-nursing.git"
    echo "  $0 git@github.com:tu-usuario/nvim-nursing.git"
    echo ""
    exit 1
fi

NEW_REPO_URL="$1"

# ==============================================================================
# Banner
# ==============================================================================

clear
print_header "Migración de Repositorio Fork → Independiente"

echo "Este script te ayudará a migrar tu proyecto a un nuevo repositorio"
echo "completamente independiente del original."
echo ""
echo -e "${YELLOW}IMPORTANTE:${NC}"
echo "  1. Asegúrate de haber creado el nuevo repositorio en GitHub"
echo "  2. El nuevo repo debe estar VACÍO (sin README, .gitignore, etc)"
echo "  3. Todos tus cambios locales deben estar commiteados"
echo ""
echo -e "Nuevo repositorio: ${GREEN}$NEW_REPO_URL${NC}"
echo ""

if ! confirm "¿Continuar con la migración?"; then
    print_warning "Migración cancelada por el usuario"
    exit 0
fi

# ==============================================================================
# Verificaciones previas
# ==============================================================================

print_header "Paso 1: Verificaciones Previas"

# Verificar que estamos en un repo git
if [ ! -d .git ]; then
    print_error "Error: No estás en un repositorio git"
    exit 1
fi
print_success "Repositorio git detectado"

# Verificar que no hay cambios sin commit
if ! git diff-index --quiet HEAD --; then
    print_error "Error: Hay cambios sin commitear"
    echo ""
    echo "Por favor, commitea o stash tus cambios antes de continuar:"
    echo "  git add ."
    echo "  git commit -m 'chore: preparing for migration'"
    echo ""
    exit 1
fi
print_success "No hay cambios pendientes"

# Mostrar remotes actuales
echo ""
echo "Remotes actuales:"
git remote -v | sed 's/^/  /'
echo ""

# ==============================================================================
# Backup de configuración actual
# ==============================================================================

print_header "Paso 2: Backup de Configuración"

BACKUP_FILE=".git-remotes-backup-$(date +%Y%m%d-%H%M%S).txt"
git remote -v > "$BACKUP_FILE"
print_success "Backup guardado en: $BACKUP_FILE"

# ==============================================================================
# Obtener información del repo actual
# ==============================================================================

CURRENT_BRANCH=$(git branch --show-current)
print_success "Rama actual: $CURRENT_BRANCH"

# ==============================================================================
# Eliminar remotes antiguos
# ==============================================================================

print_header "Paso 3: Limpiar Remotes Antiguos"

# Listar todos los remotes
REMOTES=$(git remote)

if [ -z "$REMOTES" ]; then
    print_warning "No hay remotes configurados"
else
    echo "Se eliminarán los siguientes remotes:"
    for remote in $REMOTES; do
        echo "  - $remote"
    done
    echo ""

    if confirm "¿Eliminar estos remotes?"; then
        for remote in $REMOTES; do
            git remote remove "$remote"
            print_success "Remote '$remote' eliminado"
        done
    else
        print_warning "Remotes no eliminados. Cancelando migración."
        exit 0
    fi
fi

# ==============================================================================
# Agregar nuevo remote
# ==============================================================================

print_header "Paso 4: Configurar Nuevo Remote"

git remote add origin "$NEW_REPO_URL"
print_success "Nuevo remote 'origin' agregado"

echo ""
echo "Configuración actual:"
git remote -v | sed 's/^/  /'
echo ""

# ==============================================================================
# Push al nuevo repositorio
# ==============================================================================

print_header "Paso 5: Push al Nuevo Repositorio"

echo "Se hará push de todas las ramas y tags al nuevo repositorio"
echo ""

if ! confirm "¿Continuar con el push?"; then
    print_warning "Push cancelado. Tu repo local apunta al nuevo remote pero no se ha subido nada."
    echo ""
    echo "Para hacer push manualmente más tarde:"
    echo "  git push -u origin --all"
    echo "  git push -u origin --tags"
    exit 0
fi

echo ""
print_success "Haciendo push de todas las ramas..."

if git push -u origin --all; then
    print_success "Todas las ramas subidas exitosamente"
else
    print_error "Error al hacer push de las ramas"
    echo ""
    echo "Posibles soluciones:"
    echo "  1. Verifica que la URL del repo sea correcta"
    echo "  2. Asegúrate de tener permisos de escritura"
    echo "  3. Verifica tu autenticación (token o SSH key)"
    echo ""
    echo "Para reintentar manualmente:"
    echo "  git push -u origin --all --force  # CUIDADO con --force"
    exit 1
fi

echo ""
print_success "Haciendo push de todos los tags..."

if git push -u origin --tags 2>/dev/null; then
    print_success "Todos los tags subidos exitosamente"
else
    print_warning "No hay tags para subir (esto es normal)"
fi

# ==============================================================================
# Verificación final
# ==============================================================================

print_header "Paso 6: Verificación Final"

echo "Configuración final del repositorio:"
echo ""
git remote -v | sed 's/^/  /'
echo ""

print_success "Rama actual: $(git branch --show-current)"
print_success "Último commit: $(git log -1 --oneline)"

# ==============================================================================
# Instrucciones post-migración
# ==============================================================================

print_header "¡Migración Completada! 🎉"

echo "Tu proyecto ahora está en un repositorio completamente independiente."
echo ""
echo -e "${GREEN}Próximos pasos recomendados:${NC}"
echo ""
echo "1. Verifica en GitHub que todo se subió correctamente:"
echo -e "   ${BLUE}Abre tu navegador y verifica el nuevo repo${NC}"
echo ""
echo "2. Confirma que ya NO aparece 'forked from [repo-original]'"
echo ""
echo "3. Actualiza la documentación:"
echo "   - README.md (cambia URLs y referencias)"
echo "   - LICENSE (agrega tu copyright)"
echo "   - Archivos en dev-docs/"
echo ""
echo "4. (Opcional) Renombra el proyecto para darle identidad propia:"
echo "   - Cambia 'GentlemanNvim' → 'NursingNvim' o similar"
echo "   - Actualiza nombres en configuraciones"
echo ""
echo "5. (Opcional) Si todo está bien, elimina el fork viejo en GitHub:"
echo "   Settings → Danger Zone → Delete this repository"
echo ""
echo -e "${YELLOW}Información de backup:${NC}"
echo "  - Backup de remotes guardado en: $BACKUP_FILE"
echo ""
echo -e "${GREEN}¡Tu proyecto ahora es 100% independiente!${NC}"
echo ""

# ==============================================================================
# Cleanup opcional
# ==============================================================================

echo ""
if confirm "¿Deseas ver una guía de renombramiento del proyecto?"; then
    cat << 'EOF'

================================================================================
Guía Rápida: Renombrar el Proyecto
================================================================================

1. CAMBIAR NOMBRE DEL PROYECTO EN ARCHIVOS

   # Buscar todas las referencias a "Gentleman"
   grep -r "Gentleman" --include="*.md" --include="*.lua" .

   # Reemplazar en archivos principales
   sed -i 's/GentlemanNvim/NursingNvim/g' README.md
   sed -i 's/Gentleman\.Dots/NursingNvim/g' README.md

2. ACTUALIZAR URLs DEL REPOSITORIO

   # Viejo: github.com/fegome90-cmd/n4n.dots
   # Nuevo: github.com/fegome90-cmd/nvim-nursing

   grep -r "n4n\.dots" --include="*.md" .
   sed -i 's/n4n\.dots/nvim-nursing/g' README.md
   sed -i 's/n4n\.dots/nvim-nursing/g' dev-docs/*.md

3. ACTUALIZAR BRANDING

   # Editar README.md
   nvim README.md

   # Cambiar:
   - Título del proyecto
   - Descripción
   - Badges/shields
   - Enlaces de instalación

4. COMMIT DE CAMBIOS

   git add .
   git commit -m "rebrand: rename project to NursingNvim"
   git push origin main

================================================================================

EOF
fi

print_header "Fin del Script de Migración"
