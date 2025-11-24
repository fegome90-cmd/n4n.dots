# Tasklist de Implementación: N4N en macOS (Atomic Commits)

**Objetivo**: Montar el entorno de desarrollo N4N en macOS desde cero hasta la primera evolución completa, con commits atómicos por cada tarea.

**Filosofía**: Una tarea = una acción = un commit. Sin mezclar responsabilidades.

---

## 📋 Reglas del Tasklist

1. **Cada tarea hace UNA sola cosa**
2. **Cada tarea puede ser un commit independiente**
3. **Si una implementación requiere más pasos, divide la tarea antes de commitear**
4. **El orden es realista: desde herramientas hasta primera evolución**

---

## 🎯 Progreso General

```
Total de tareas: 41
├── A. Preparar herramientas en macOS (4 tareas)
├── B. Crear estructura base de N4N (6 tareas)
├── C. Script lanzador aislado (7 tareas)
├── D. Configuración mínima de Neovim (13 tareas)
├── E. Infraestructura de snippets clínicos (5 tareas)
├── F. Primer uso real de N4N (5 tareas)
└── G. Verificación final del flujo (1 tarea)
```

---

## A. Preparar Herramientas en macOS

### T01. Verificar presencia de Homebrew

**Acción**:
```bash
brew --version
```

**Resultado esperado**: Versión de Homebrew (ej: `Homebrew 4.x.x`)

**Si no está instalado**:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Commit**: Ninguno si ya existe (es prerequisito del sistema)

**Estado**: [ ] Pendiente | [ ] Completado

---

### T02. Instalar Neovim con Homebrew

**Acción**:
```bash
brew install neovim
```

**Verificación**:
```bash
nvim --version
# Debe mostrar: NVIM v0.9.x o superior
```

**Commit msg sugerido**: `chore: instalar neovim en entorno local`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T03. Instalar ripgrep con Homebrew

**Acción**:
```bash
brew install ripgrep
```

**Verificación**:
```bash
rg --version
# Debe mostrar: ripgrep x.x.x
```

**Commit msg sugerido**: `chore: instalar ripgrep para búsquedas en notas`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T04. Instalar fd con Homebrew

**Acción**:
```bash
brew install fd
```

**Verificación**:
```bash
fd --version
# Debe mostrar: fd x.x.x
```

**Commit msg sugerido**: `chore: instalar fd para navegación de archivos`

**Estado**: [ ] Pendiente | [ ] Completado

---

## B. Crear Estructura Base de N4N en macOS

### T05. Crear carpeta raíz n4n-dev

**Acción**:
```bash
mkdir -p ~/n4n-dev
```

**Verificación**:
```bash
ls -ld ~/n4n-dev
```

**Commit msg sugerido**: `chore: crear carpeta raiz n4n-dev`

**Nota**: Este commit puede agrupar las carpetas T05-T10 si prefieres, pero idealmente cada una es independiente para máxima atomicidad.

**Estado**: [ ] Pendiente | [ ] Completado

---

### T06. Crear carpeta config para N4N

**Acción**:
```bash
mkdir -p ~/n4n-dev/config
```

**Verificación**:
```bash
ls -ld ~/n4n-dev/config
```

**Commit msg sugerido**: `chore: crear carpeta config para n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T07. Crear carpeta data para N4N

**Acción**:
```bash
mkdir -p ~/n4n-dev/data
```

**Verificación**:
```bash
ls -ld ~/n4n-dev/data
```

**Commit msg sugerido**: `chore: crear carpeta data para n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T08. Crear carpeta state para N4N

**Acción**:
```bash
mkdir -p ~/n4n-dev/state
```

**Verificación**:
```bash
ls -ld ~/n4n-dev/state
```

**Commit msg sugerido**: `chore: crear carpeta state para n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T09. Crear carpeta cache para N4N

**Acción**:
```bash
mkdir -p ~/n4n-dev/cache
```

**Verificación**:
```bash
ls -ld ~/n4n-dev/cache
```

**Commit msg sugerido**: `chore: crear carpeta cache para n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T10. Crear carpeta de registros de práctica

**Acción**:
```bash
mkdir -p ~/n4n-dev/registros
```

**Verificación**:
```bash
ls -ld ~/n4n-dev/registros
```

**Commit msg sugerido**: `chore: crear carpeta registros para n4n-dev`

**Estado**: [ ] Pendiente | [ ] Completado

---

## C. Script Lanzador Aislado para N4N en macOS

### T11. Crear script n4n-mac.sh con export de XDG

**Acción**:
```bash
cat > ~/n4n-dev/n4n-mac.sh << 'EOF'
#!/usr/bin/env bash

# Variables XDG para aislar este entorno
export XDG_CONFIG_HOME="$HOME/n4n-dev/config"
export XDG_DATA_HOME="$HOME/n4n-dev/data"
export XDG_STATE_HOME="$HOME/n4n-dev/state"
export XDG_CACHE_HOME="$HOME/n4n-dev/cache"
EOF
```

**Verificación**:
```bash
cat ~/n4n-dev/n4n-mac.sh
```

**Commit msg sugerido**: `feat: agregar script base n4n-mac con variables XDG`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T12. Añadir configuración de perfil N4N_PROFILE al script

**Acción**:
```bash
# Editar ~/n4n-dev/n4n-mac.sh y agregar después de las variables XDG:
echo '' >> ~/n4n-dev/n4n-mac.sh
echo '# Perfil de desarrollo' >> ~/n4n-dev/n4n-mac.sh
echo 'export N4N_PROFILE="mac_dev"' >> ~/n4n-dev/n4n-mac.sh
```

**Verificación**:
```bash
grep N4N_PROFILE ~/n4n-dev/n4n-mac.sh
```

**Commit msg sugerido**: `feat: definir perfil mac_dev en script n4n-mac`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T13. Añadir creación automática de carpetas XDG en el script

**Acción**:
```bash
cat >> ~/n4n-dev/n4n-mac.sh << 'EOF'

# Crear carpetas XDG si no existen
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$XDG_CACHE_HOME"
EOF
```

**Verificación**:
```bash
grep "mkdir -p" ~/n4n-dev/n4n-mac.sh
```

**Commit msg sugerido**: `feat: asegurar creacion de carpetas XDG en n4n-mac`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T14. Añadir cambio de directorio a carpeta registros en el script

**Acción**:
```bash
cat >> ~/n4n-dev/n4n-mac.sh << 'EOF'

# Posicionarse en carpeta de registros
cd "$HOME/n4n-dev/registros"
EOF
```

**Verificación**:
```bash
grep "cd.*registros" ~/n4n-dev/n4n-mac.sh
```

**Commit msg sugerido**: `feat: iniciar n4n en carpeta registros`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T15. Añadir llamada a nvim en el script

**Acción**:
```bash
cat >> ~/n4n-dev/n4n-mac.sh << 'EOF'

# Lanzar Neovim
nvim "$@"
EOF
```

**Verificación**:
```bash
tail -2 ~/n4n-dev/n4n-mac.sh
```

**Commit msg sugerido**: `feat: lanzar neovim desde n4n-mac`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T16. Marcar script como ejecutable

**Acción**:
```bash
chmod +x ~/n4n-dev/n4n-mac.sh
```

**Verificación**:
```bash
ls -l ~/n4n-dev/n4n-mac.sh
# Debe mostrar: -rwxr-xr-x
```

**Commit msg sugerido**: `chore: hacer ejecutable script n4n-mac`

**Estado**: [ ] Pendiente | [ ] Completado

---

### T17. Probar ejecución básica del script sin config de nvim

**Acción**:
```bash
~/n4n-dev/n4n-mac.sh
# Debe abrir Neovim en ~/n4n-dev/registros
# Salir con :q
```

**Verificación**: Neovim abre sin errores (aunque sin plugins aún)

**Commit**: Solo si necesitas corregir el script

**Estado**: [ ] Pendiente | [ ] Completado

---

## D. Configuración Mínima de Neovim para N4N

### D1. Estructura de nvim

#### T18. Crear carpeta de configuración Neovim específica para N4N

**Acción**:
```bash
mkdir -p ~/n4n-dev/config/nvim
```

**Verificación**:
```bash
ls -ld ~/n4n-dev/config/nvim
```

**Commit msg sugerido**: `chore: crear carpeta config nvim para n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T19. Crear archivo init.lua vacío en config nvim

**Acción**:
```bash
touch ~/n4n-dev/config/nvim/init.lua
```

**Verificación**:
```bash
ls -l ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `chore: crear init.lua vacio para n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

### D2. Opciones básicas de edición

#### T20. Definir opciones de indentación en init.lua

**Acción**:
```bash
cat > ~/n4n-dev/config/nvim/init.lua << 'EOF'
-- init.lua para N4N-dev

-- Opciones de indentación
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
EOF
```

**Verificación**:
```bash
cat ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: configurar indentacion basica en n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T21. Activar numeración de líneas en init.lua

**Acción**:
```bash
cat >> ~/n4n-dev/config/nvim/init.lua << 'EOF'

-- Numeración de líneas
vim.opt.number = true
vim.opt.relativenumber = true
EOF
```

**Verificación**:
```bash
grep "number" ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: activar numeracion de lineas en n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T22. Activar corrección ortográfica en español más inglés en init.lua

**Acción**:
```bash
cat >> ~/n4n-dev/config/nvim/init.lua << 'EOF'

-- Corrección ortográfica
vim.opt.spell = true
vim.opt.spelllang = { "es", "en" }
EOF
```

**Verificación**:
```bash
grep "spell" ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: activar correccion ortografica es en`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T23. Definir archivo de diccionario médico en init.lua

**Acción**:
```bash
cat >> ~/n4n-dev/config/nvim/init.lua << 'EOF'

-- Diccionario médico personalizado
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/medical.utf-8.add"
EOF
```

**Verificación**:
```bash
grep "spellfile" ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: definir diccionario medico personalizado`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T24. Crear carpeta para diccionario médico

**Acción**:
```bash
mkdir -p ~/n4n-dev/config/nvim/spell
```

**Verificación**:
```bash
ls -ld ~/n4n-dev/config/nvim/spell
```

**Commit msg sugerido**: `chore: crear carpeta spell para diccionario medico`

**Estado**: [ ] Pendiente | [ ] Completado

---

### D3. Gestor de plugins y snippets

#### T25. Añadir bootstrap de lazy.nvim en init.lua

**Acción**:
```bash
cat >> ~/n4n-dev/config/nvim/init.lua << 'EOF'

-- Bootstrap de lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
EOF
```

**Verificación**:
```bash
grep "lazy.nvim" ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: integrar lazy como gestor de plugins`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T26. Definir llamada a require lazy.setup en init.lua

**Acción**:
```bash
cat >> ~/n4n-dev/config/nvim/init.lua << 'EOF'

-- Setup de lazy.nvim
require("lazy").setup({
  -- Plugins aquí
})
EOF
```

**Verificación**:
```bash
grep 'require("lazy")' ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: agregar setup inicial de lazy`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T27. Añadir plugin LuaSnip en lazy.setup

**Acción**: Editar `~/n4n-dev/config/nvim/init.lua` y reemplazar el comentario `-- Plugins aquí` con:

```lua
  -- Engine de snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
  },
```

**Verificación**:
```bash
grep "LuaSnip" ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: agregar plugin luasnip para snippets`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T28. Añadir plugin friendly-snippets en lazy.setup

**Acción**: Editar `~/n4n-dev/config/nvim/init.lua` y agregar después de LuaSnip:

```lua
  -- Snippets en formato VSCode
  { "rafamadriz/friendly-snippets" },
```

**Verificación**:
```bash
grep "friendly-snippets" ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: agregar plugin friendly-snippets`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T29. Cargar snippets tipo VSCode en init.lua

**Acción**:
```bash
cat >> ~/n4n-dev/config/nvim/init.lua << 'EOF'

-- Cargar snippets custom en formato VSCode
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})

-- Configurar Tab para snippets
local luasnip = require("luasnip")

vim.keymap.set({"i", "s"}, "<Tab>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    return "<Tab>"
  end
end, {silent = true, expr = true})

vim.keymap.set({"i", "s"}, "<S-Tab>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    return "<S-Tab>"
  end
end, {silent = true, expr = true})
EOF
```

**Verificación**:
```bash
grep "from_vscode" ~/n4n-dev/config/nvim/init.lua
```

**Commit msg sugerido**: `feat: habilitar carga de snippets vscode en n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

### D4. Verificación básica

#### T30. Ejecutar n4n-mac y verificar instalación de lazy más plugins

**Acción**:
```bash
~/n4n-dev/n4n-mac.sh
# Esperar instalación automática de lazy + plugins
# Verificar que no hay errores críticos
# Salir con :q
```

**Verificación en Neovim**:
```vim
:Lazy
# Debe mostrar plugins instalados: LuaSnip, friendly-snippets
```

**Commit**: Solo si hay corrección en init.lua

**Estado**: [ ] Pendiente | [ ] Completado

---

## E. Crear Infraestructura de Snippets Clínicos

### E1. Carpeta y archivo de snippets

#### T31. Crear carpeta snippets para n4n

**Acción**:
```bash
mkdir -p ~/n4n-dev/config/nvim/snippets
```

**Verificación**:
```bash
ls -ld ~/n4n-dev/config/nvim/snippets
```

**Commit msg sugerido**: `chore: crear carpeta snippets para markdown`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T32. Crear archivo markdown.json vacío para snippets clínicos

**Acción**:
```bash
cat > ~/n4n-dev/config/nvim/snippets/package.json << 'EOF'
{
  "name": "n4n-clinical-snippets",
  "version": "1.0.0",
  "description": "Snippets clínicos para N4N",
  "contributes": {
    "snippets": [
      {
        "language": "markdown",
        "path": "./markdown.json"
      }
    ]
  }
}
EOF

cat > ~/n4n-dev/config/nvim/snippets/markdown.json << 'EOF'
{}
EOF
```

**Verificación**:
```bash
ls ~/n4n-dev/config/nvim/snippets/
```

**Commit msg sugerido**: `chore: crear archivo markdown json para snippets clinicos`

**Estado**: [ ] Pendiente | [ ] Completado

---

### E2. Snippet principal de evolución agnóstica (evo3000)

#### T33. Añadir estructura JSON para snippet Evolución N4N 3000

**Acción**: Reemplazar el contenido de `~/n4n-dev/config/nvim/snippets/markdown.json` con el snippet completo de evo3000.

Ver contenido completo en: `dev-docs/planning/mac-dev-environment.md` sección "Snippet Base: Evolución por Sistemas"

**Commit msg sugerido**: `feat: agregar snippet base evolucion n4n 3000`

**Nota**: Este snippet tiene 71 campos y es el más extenso. Copia exactamente como está en la documentación de planificación.

**Estado**: [ ] Pendiente | [ ] Completado

---

### E3. Snippet comando hemodinámico hcp

#### T34. Añadir snippet HCP a markdown.json

**Acción**: Editar `~/n4n-dev/config/nvim/snippets/markdown.json` y agregar (después de evo3000, separando con coma):

```json
,
  "HCP - Hemodinamia Cambio Presión": {
    "prefix": "hcp",
    "body": [
      "**Hemo:** ${1:PAM} pasa de ${2:valor previo} a ${3:valor actual} mmHg en contexto de ${4:sedación/dolor/fiebre/hipovolemia/otro}.",
      "Se ${5:ajusta/mantiene/inicia/suspende} ${6:noradrenalina/dobutamina/otro} a ${7:dosis} con objetivo de PAM ≥ ${8:meta} mmHg.",
      "Se reevaluará en ${9:tiempo (min)} min y se informará a ${10:médico tratante/equipo} si persiste alteración."
    ],
    "description": "Comando hemodinámico HCP (Cambio de presión y ajuste)"
  }
```

**Verificación**:
```bash
grep '"hcp"' ~/n4n-dev/config/nvim/snippets/markdown.json
```

**Commit msg sugerido**: `feat: agregar snippet comando hcp para hemodinamia`

**Estado**: [ ] Pendiente | [ ] Completado

---

### E4. Snippet comando SNO (sno)

#### T35. Añadir snippet SNO a markdown.json

**Acción**: Editar `~/n4n-dev/config/nvim/snippets/markdown.json` y agregar (después de hcp, separando con coma):

```json
,
  "SNO - Sistema Núcleo Objetivo": {
    "prefix": "sno",
    "body": [
      "**${1:Sistema}:** ${2:núcleo del problema/estado actual}. Objetivo: ${3:meta o criterio de éxito}."
    ],
    "description": "Plantilla corta sistema-núcleo-objetivo (SNO)"
  }
```

**Verificación**:
```bash
grep '"sno"' ~/n4n-dev/config/nvim/snippets/markdown.json
```

**Commit msg sugerido**: `feat: agregar snippet comando sno para frases por sistema`

**Estado**: [ ] Pendiente | [ ] Completado

---

## F. Primer Uso Real de N4N en macOS (Primera Evolución)

### F1. Preparar archivo de prueba

#### T36. Crear archivo de prueba de evolución en carpeta registros

**Acción**:
```bash
touch ~/n4n-dev/registros/UPC-2025-11-24-Noche.md
```

**Verificación**:
```bash
ls -l ~/n4n-dev/registros/UPC-2025-11-24-Noche.md
```

**Commit msg sugerido**: `chore: agregar archivo de prueba para evolucion n4n`

**Estado**: [ ] Pendiente | [ ] Completado

---

### F2. Escribir la primera evolución con evo3000

#### T37. Abrir N4N en archivo de evolución de prueba

**Acción**:
```bash
~/n4n-dev/n4n-mac.sh UPC-2025-11-24-Noche.md
```

**Verificación**: Neovim abre directamente el archivo

**Commit**: Solo si ajustas algo en config

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T38. Insertar snippet evo3000 en el archivo de prueba

**Acción dentro de Neovim**:
```vim
i                   # Entrar a INSERT
evo3000<Tab>        # Expandir snippet
# Navegar con Tab entre campos
# Completar algunos campos básicos:
# - Fecha: 2025-11-24
# - Hora: 20:00
# - Paciente: vigil, tranquilo, cooperador
# - PA: 120/80, FC: 80, PAM: >65
# - Etc. (completa 10-15 campos mínimo)
<Esc>               # Salir de INSERT
:w                  # Guardar
```

**Verificación**:
```bash
wc -l ~/n4n-dev/registros/UPC-2025-11-24-Noche.md
# Debe tener 80+ líneas
```

**Commit msg sugerido**: `feat: registrar primera evolucion de prueba con snippet evo3000`

**Estado**: [ ] Pendiente | [ ] Completado

---

### F3. Usar comandos hcp más sno dentro de la evolución

#### T39. Insertar snippet hcp en sección hemodinámica

**Acción dentro de Neovim**:
```vim
# Posicionarse en la sección HEMODINÁMICO
/HEMODINÁMICO<Enter>
G                   # Ir al final de esa sección
o                   # Nueva línea debajo
hcp<Tab>            # Expandir snippet
# Completar campos:
# ${1:PAM} → PAM
# ${2:75} → valor previo
# ${3:58} → valor actual
# ${4:sedación profunda} → contexto
# ${5:ajusta} → acción
# ${6:noradrenalina} → fármaco
# ${7:0.25 mcg/kg/min} → dosis
# ${8:65} → meta
# ${9:15} → tiempo
# ${10:Dr. García} → informar a
<Esc>
:w
```

**Verificación**: El archivo ahora tiene el comando hcp expandido en la sección hemodinámica

**Commit msg sugerido**: `feat: documentar cambio hemodinamico con comando hcp`

**Estado**: [ ] Pendiente | [ ] Completado

---

#### T40. Insertar snippet sno en otro sistema de la evolución

**Acción dentro de Neovim**:
```vim
# Buscar sección METABÓLICO
/METABÓLICO<Enter>
G                   # Final de sección
o                   # Nueva línea
sno<Tab>            # Expandir snippet
# Completar:
# ${1:Metabólico} → Sistema
# ${2:euglicémico con insulina ajustada} → núcleo
# ${3:mantener HGT 100-160 mg/dL} → objetivo
<Esc>
:w
:q                  # Salir de Neovim
```

**Verificación**:
```bash
grep "Metabólico:" ~/n4n-dev/registros/UPC-2025-11-24-Noche.md
```

**Commit msg sugerido**: `feat: documentar frase por sistema con comando sno`

**Estado**: [ ] Pendiente | [ ] Completado

---

## G. Verificación Final del Flujo

### T41. Revisar archivo de evolución en editor externo más terminal

**Acción**:
```bash
# Opción 1: Ver en terminal
cat ~/n4n-dev/registros/UPC-2025-11-24-Noche.md

# Opción 2: Abrir en editor de texto
open ~/n4n-dev/registros/UPC-2025-11-24-Noche.md

# Opción 3: Ver con less
less ~/n4n-dev/registros/UPC-2025-11-24-Noche.md
```

**Verificar que contiene**:
- ✅ Encabezado "# Evolución de Enfermería"
- ✅ Todas las secciones de sistemas (NEUROLÓGICO, HEMODINÁMICO, etc.)
- ✅ Examen físico segmentado
- ✅ Comando hcp expandido en sección hemodinámica
- ✅ Comando sno expandido en otro sistema
- ✅ Formato markdown limpio y legible

**Commit msg sugerido**: `chore: validar salida de evolucion n4n en markdown`

**Estado**: [ ] Pendiente | [ ] Completado

---

## 📊 Resumen de Progreso

### Por Sección

- [ ] **A. Preparar herramientas** (0/4 completadas)
- [ ] **B. Estructura base** (0/6 completadas)
- [ ] **C. Script lanzador** (0/7 completadas)
- [ ] **D. Config Neovim** (0/13 completadas)
- [ ] **E. Snippets clínicos** (0/5 completadas)
- [ ] **F. Primer uso real** (0/5 completadas)
- [ ] **G. Verificación final** (0/1 completada)

### Total

**0 / 41 tareas completadas** (0%)

---

## 🎯 Hitos Clave

### Hito 1: Entorno Listo (T01-T17)
**Objetivo**: Tener N4N-dev funcional con Neovim abierto
**Completado**: [ ]

### Hito 2: Neovim Configurado (T18-T30)
**Objetivo**: Tener Neovim con lazy.nvim + LuaSnip funcionando
**Completado**: [ ]

### Hito 3: Snippets Instalados (T31-T35)
**Objetivo**: Tener evo3000, hcp, sno disponibles
**Completado**: [ ]

### Hito 4: Primera Evolución (T36-T41)
**Objetivo**: Archivo de evolución completo con todos los snippets
**Completado**: [ ]

---

## 🔍 Troubleshooting por Tarea

### Si falla T02 (Instalación de Neovim)
```bash
# Error común: "neovim not found"
# Solución: Actualiza Homebrew
brew update
brew install neovim
```

### Si falla T25 (lazy.nvim no instala)
```bash
# Verificar que git está instalado
git --version

# Limpiar y reintentar
rm -rf ~/n4n-dev/data/lazy
~/n4n-dev/n4n-mac.sh
# En Neovim: :Lazy sync
```

### Si falla T30 (Plugins no cargan)
```vim
# En Neovim, verificar estado
:Lazy
:checkhealth lazy
:checkhealth luasnip

# Reinstalar plugins
:Lazy clear
:Lazy sync
```

### Si falla T38 (Snippet no expande)
**Verificaciones**:
1. ¿Estás en modo INSERT? (debe decir `-- INSERT --` abajo)
2. ¿El archivo tiene extensión `.md`? (`:echo expand('%:e')`)
3. ¿Los snippets están en la ruta correcta?
   ```vim
   :lua print(vim.fn.stdpath("config") .. "/snippets")
   ```
4. ¿LuaSnip está cargado?
   ```vim
   :lua print(require("luasnip"))
   ```

---

## 📝 Notas de Implementación

### Agrupación de Commits (Opcional)

Si prefieres agrupar tareas relacionadas en un solo commit:

**Opción 1: Agrupar estructura de carpetas**
- T05-T10 en un solo commit: `chore: crear estructura de carpetas n4n-dev`

**Opción 2: Agrupar opciones de init.lua**
- T20-T23 en un solo commit: `feat: configurar opciones basicas de neovim`

**Opción 3: Agrupar plugins**
- T27-T28 en un solo commit: `feat: agregar plugins luasnip y friendly-snippets`

### Regla de Oro

**Si tienes duda, mantén tareas separadas**. Es mejor tener commits atómicos que commits que hacen demasiado.

---

## ✅ Checklist Final

Cuando completes todas las tareas, deberías poder:

- [ ] Ejecutar `~/n4n-dev/n4n-mac.sh` sin errores
- [ ] Crear un archivo `.md` nuevo
- [ ] Escribir `evo3000<Tab>` y expandir la evolución completa
- [ ] Navegar entre campos con Tab/Shift+Tab
- [ ] Usar `hcp<Tab>` para comandos hemodinámicos
- [ ] Usar `sno<Tab>` para frases estructuradas
- [ ] Guardar y abrir el archivo en cualquier editor
- [ ] Ver markdown limpio y bien formateado

**Si puedes hacer todo esto, el entorno está 100% funcional.** 🎉

---

## 🚀 Después de Completar el Tasklist

### Próximos Pasos

1. **Validación con casos reales** (2-3 evoluciones de prueba)
   - Caso 1: Paciente hemodinámicamente inestable
   - Caso 2: Paciente ventilado
   - Caso 3: Paciente paliativo

2. **Recopilar feedback**
   - ¿Qué sobra en evo3000?
   - ¿Qué falta?
   - ¿Qué comandos usarías todo el tiempo?

3. **Refinar snippets** según feedback real

4. **Diseñar lenguaje de comandos N4N**
   - vmp, dve, dpl, inf, gli, bal, etc.

---

*Última actualización: 2025-11-24*
*Basado en: mac-dev-environment.md*
*Total de tareas: 41*
*Tiempo estimado total: 2-3 horas*
