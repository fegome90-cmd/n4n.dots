# Alternativas de Setup: Aprovechando GentlemanNvim Existente

**Problema identificado**: El plan original (`mac-dev-environment.md`) asume que no tienes Neovim configurado, pero **tú ya tienes GentlemanNvim funcionando** en tu Mac con toda la infraestructura necesaria (lazy.nvim, LuaSnip, plugins, etc.).

**¿Para qué reinventar la rueda?** Analicemos las alternativas inteligentes.

---

## 🎯 Contexto: Lo que Ya Tienes

Basado en el repo `GentlemanNvim` que estás forkeando, ya tienes:

```
~/.config/nvim/
├── init.lua                    # ✅ Ya configurado
├── lua/
│   ├── config/
│   │   ├── lazy.lua           # ✅ Lazy.nvim ya instalado
│   │   └── ...
│   └── plugins/
│       ├── luasnip configurado # ✅ Engine de snippets ya disponible
│       └── ... (50+ plugins)
├── snippets/                   # Probablemente existe o se puede agregar
└── lazy-lock.json             # ✅ Plugins ya instalados
```

**Lo que necesitas para N4N**:
- ✅ LuaSnip (ya lo tienes)
- ✅ Soporte para snippets VSCode (probablemente ya configurado)
- ❓ Solo agregar snippets clínicos (evo3000, hcp, sno)

---

## 📊 Tres Alternativas (Ordenadas por Simplicidad)

### Alternativa A: Agregar Snippets Directamente a GentlemanNvim ⭐
**Nivel de complejidad**: 🟢 Muy simple
**Tiempo de setup**: 5-10 minutos
**Aislamiento**: Ninguno (todo en tu config principal)

### Alternativa B: Config Paralela con NVIM_APPNAME
**Nivel de complejidad**: 🟡 Moderado
**Tiempo de setup**: 30-45 minutos
**Aislamiento**: Completo (configs independientes que coexisten)

### Alternativa C: Entorno Aislado Completo (Plan Original)
**Nivel de complejidad**: 🔴 Complejo
**Tiempo de setup**: 2-3 horas
**Aislamiento**: Total (entorno separado con variables XDG)

---

## 🟢 Alternativa A: Agregar Snippets a GentlemanNvim (Recomendada)

### Ventajas
- ✅ **Más rápido**: 5 minutos vs 3 horas
- ✅ **Aprovechas todo lo que ya tienes**: Plugins, temas, atajos
- ✅ **Un solo Neovim**: No alternas entre configs
- ✅ **Snippets disponibles siempre**: En cualquier archivo .md

### Desventajas
- ⚠️ Los snippets clínicos están mezclados con tu config personal
- ⚠️ Si algo se rompe, afecta todo tu Neovim

### Cuándo Usar
- ✅ Si quieres empezar YA con mínimo esfuerzo
- ✅ Si no te importa mezclar snippets clínicos con tu config principal
- ✅ Si ya confías en tu config de Neovim

---

### Setup de Alternativa A (5 minutos)

#### Paso 1: Verificar que tienes LuaSnip

```bash
# Abre tu Neovim
nvim

# Dentro de Neovim:
:Lazy
# Busca "LuaSnip" en la lista
# Si está, ya lo tienes ✓
```

**Si NO tienes LuaSnip**, agrégalo:

```lua
-- En ~/.config/nvim/lua/plugins/luasnip.lua (crear si no existe)
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
}
```

---

#### Paso 2: Verificar soporte para snippets VSCode

```lua
-- En ~/.config/nvim/lua/config/lazy.lua o donde cargues plugins
-- Busca si ya tienes friendly-snippets o from_vscode loader

-- Si NO lo tienes, agrega:
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})
```

---

#### Paso 3: Crear carpeta de snippets clínicos

```bash
# Crear carpeta para snippets custom
mkdir -p ~/.config/nvim/snippets

# Crear package.json
cat > ~/.config/nvim/snippets/package.json << 'EOF'
{
  "name": "n4n-clinical-snippets",
  "version": "1.0.0",
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

# Crear archivo de snippets
cat > ~/.config/nvim/snippets/markdown.json << 'EOF'
{
  "Evolución N4N 3000": {
    "prefix": "evo3000",
    "body": [
      "# Evolución de Enfermería - ${1:Fecha} ${2:Hora}",
      "... (contenido completo del snippet)"
    ],
    "description": "Evolución por sistemas + examen físico"
  },
  "HCP - Hemodinamia": {
    "prefix": "hcp",
    "body": [...],
    "description": "Comando hemodinámico"
  },
  "SNO - Sistema Núcleo Objetivo": {
    "prefix": "sno",
    "body": [...],
    "description": "Frase estructurada"
  }
}
EOF
```

---

#### Paso 4: Crear launcher específico para N4N

```bash
# Crear script que abre Neovim directo en carpeta de registros
cat > ~/n4n-start.sh << 'EOF'
#!/usr/bin/env bash
cd ~/Documents/RegistrosEnfermeria/UPC/2025
nvim "$@"
EOF

chmod +x ~/n4n-start.sh
```

**Uso**:
```bash
~/n4n-start.sh UPC-2025-11-24-Noche.md
```

---

#### Paso 5: Probar

```bash
# Abrir Neovim
nvim test-evo.md

# En modo INSERT:
evo3000<Tab>
# Debe expandir el snippet ✓

hcp<Tab>
# Debe expandir comando hemodinámico ✓

sno<Tab>
# Debe expandir comando SNO ✓
```

---

### Resultado de Alternativa A

**Tienes**:
- ✅ Todos tus plugins y config de GentlemanNvim
- ✅ Snippets clínicos (evo3000, hcp, sno) disponibles
- ✅ Un launcher que abre directamente en carpeta de registros
- ✅ Listo para usar en 5 minutos

**No tienes**:
- ❌ Aislamiento total
- ❌ Múltiples configs de Neovim

---

## 🟡 Alternativa B: Config Paralela con NVIM_APPNAME

### Concepto

Neovim permite tener **múltiples configuraciones independientes** usando la variable `NVIM_APPNAME`.

**Por defecto**:
- `nvim` lee de `~/.config/nvim/`

**Con NVIM_APPNAME**:
- `NVIM_APPNAME=nvim-n4n nvim` lee de `~/.config/nvim-n4n/`

**Resultado**: Dos Neovim independientes en el mismo sistema.

---

### Ventajas
- ✅ **Aislamiento completo**: Config clínica separada de tu config personal
- ✅ **Aprovechas conocimiento**: Misma estructura que GentlemanNvim
- ✅ **Fácil de borrar**: Solo eliminas `~/.config/nvim-n4n/`
- ✅ **Coexisten sin conflicto**: `nvim` (personal) y `nvim-n4n` (clínico)

### Desventajas
- ⚠️ Duplicas plugins (lazy.nvim se instala dos veces)
- ⚠️ Tienes que mantener dos configs
- ⚠️ ~500 MB adicionales en disco

### Cuándo Usar
- ✅ Si quieres aislamiento pero sin complejidad de variables XDG
- ✅ Si tu config personal es muy customizada y no quieres mezclar
- ✅ Si quieres poder borrar la config clínica sin afectar nada más

---

### Setup de Alternativa B (30-45 minutos)

#### Paso 1: Crear estructura mínima de nvim-n4n

```bash
# Crear carpeta de config paralela
mkdir -p ~/.config/nvim-n4n

# Copiar estructura básica desde GentlemanNvim (opcional)
# O crear desde cero con init.lua mínimo
```

---

#### Paso 2: Crear init.lua mínimo para N4N

```bash
cat > ~/.config/nvim-n4n/init.lua << 'EOF'
-- init.lua mínimo para N4N clínico

-- Opciones básicas
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.spell = true
vim.opt.spelllang = { "es", "en" }

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins mínimos
require("lazy").setup({
  { "L3MON4D3/LuaSnip", version = "v2.*" },
  { "rafamadriz/friendly-snippets" },
})

-- Cargar snippets clínicos
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})

-- Tab para snippets
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
  end
end, {silent = true})

-- Leader
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>")
EOF
```

---

#### Paso 3: Agregar snippets clínicos

```bash
mkdir -p ~/.config/nvim-n4n/snippets

# Copiar package.json y markdown.json
# (Igual que Alternativa A, paso 3)
```

---

#### Paso 4: Crear launcher con NVIM_APPNAME

```bash
cat > ~/n4n-clinical.sh << 'EOF'
#!/usr/bin/env bash
export NVIM_APPNAME="nvim-n4n"
cd ~/Documents/RegistrosEnfermeria/UPC/2025
nvim "$@"
EOF

chmod +x ~/n4n-clinical.sh
```

---

#### Paso 5: Alias para fácil acceso

```bash
# Agregar a ~/.zshrc o ~/.bashrc
echo 'alias n4n="NVIM_APPNAME=nvim-n4n nvim"' >> ~/.zshrc
source ~/.zshrc

# Usar:
n4n test.md
```

---

### Resultado de Alternativa B

**Estructura final**:
```
~/.config/
├── nvim/           # Tu config principal (GentlemanNvim)
└── nvim-n4n/       # Config clínica (solo snippets)
    ├── init.lua
    └── snippets/
        └── markdown.json
```

**Comandos**:
```bash
nvim               # Abre tu Neovim personal (GentlemanNvim)
n4n                # Abre Neovim clínico (solo snippets)
~/n4n-clinical.sh  # Abre N4N en carpeta de registros
```

---

## 🔴 Alternativa C: Entorno Aislado Completo (Ya Documentado)

Esta es la alternativa del `mac-dev-environment.md` original.

### Cuándo Usar
- Solo si NO tienes Neovim configurado
- O si quieres aislamiento total con variables XDG

**Para ti, probablemente NO es necesario** porque ya tienes GentlemanNvim.

---

## 📊 Comparación de Alternativas

| Característica | A. Agregar a GentlemanNvim | B. NVIM_APPNAME | C. Aislado Total |
|----------------|----------------------------|-----------------|------------------|
| **Tiempo setup** | 5 min | 30-45 min | 2-3 horas |
| **Complejidad** | 🟢 Muy simple | 🟡 Moderada | 🔴 Alta |
| **Aislamiento** | ❌ Ninguno | ✅ Completo | ✅✅ Total |
| **Plugins duplicados** | No | Sí | Sí |
| **Fácil de borrar** | ⚠️ Mezclado | ✅ Sí | ✅ Sí |
| **Aprovecha config existente** | ✅✅ Totalmente | ⚠️ Parcial | ❌ No |
| **Espacio en disco** | 0 MB | ~500 MB | ~500 MB |

---

## 🎯 Recomendación por Caso de Uso

### Si quieres empezar HOY (5 minutos)
→ **Alternativa A**: Agregar snippets a GentlemanNvim

```bash
mkdir -p ~/.config/nvim/snippets
# Copiar snippets
# Probar con evo3000<Tab>
# ¡Listo!
```

---

### Si quieres aislamiento pero aprovechas GentlemanNvim
→ **Alternativa B**: NVIM_APPNAME

```bash
# Config paralela ligera
mkdir -p ~/.config/nvim-n4n
# init.lua mínimo
# Snippets clínicos
# Launcher: n4n test.md
```

---

### Si NO tienes Neovim configurado o quieres empezar desde cero
→ **Alternativa C**: Entorno aislado completo (plan original)

---

## 💡 Mi Recomendación para Ti

Basado en que **ya tienes GentlemanNvim funcionando**:

### 1. Empieza con Alternativa A (5 minutos)
- Agrega snippets a tu config existente
- Prueba con 2-3 evoluciones reales
- Valida que los snippets funcionan

### 2. Si decides que quieres aislamiento (después)
- Migra a Alternativa B con NVIM_APPNAME
- Copia solo lo que necesitas
- Mantén GentlemanNvim intacto

### 3. Alternativa C solo si...
- Quieres empezar desde cero (no tiene sentido en tu caso)
- O quieres máximo aislamiento con XDG (overkill)

---

## 🚀 Quick Start para Ti (Alternativa A)

### Opción más rápida (5 minutos):

```bash
# 1. Verificar LuaSnip
nvim -c ':Lazy' -c 'q'

# 2. Crear snippets
mkdir -p ~/.config/nvim/snippets
# Copiar markdown.json con evo3000, hcp, sno

# 3. Probar
nvim test-evo.md
# i
# evo3000<Tab>
# ✓ Funciona

# 4. Crear launcher
cat > ~/n4n.sh << 'EOF'
#!/usr/bin/env bash
cd ~/Documents/RegistrosEnfermeria/UPC/2025
nvim "$@"
EOF
chmod +x ~/n4n.sh

# 5. Usar
~/n4n.sh UPC-2025-11-24-Noche.md
```

**¡Listo en 5 minutos!** Ya tienes N4N funcionando con toda la potencia de GentlemanNvim.

---

## 🔍 Verificar tu Setup Actual

Antes de decidir, verifica qué tienes:

```bash
# ¿Tienes Neovim?
nvim --version

# ¿Dónde está tu config?
ls -la ~/.config/nvim/

# ¿Tienes LuaSnip?
nvim -c ':Lazy' -c 'q'
# Busca LuaSnip en la lista

# ¿Tienes carpeta de snippets?
ls ~/.config/nvim/snippets/ 2>/dev/null || echo "No existe aún"
```

---

## 📝 Próximo Paso

**Respóndeme estas preguntas**:

1. ¿Ya tienes Neovim configurado en tu Mac?
2. ¿Es GentlemanNvim o alguna otra config?
3. ¿Prefieres simplicidad (5 min) o aislamiento (30-45 min)?
4. ¿Te importa mezclar snippets clínicos con tu config personal?

Con esa info te puedo dar la ruta exacta a seguir.

---

*Última actualización: 2025-11-24*
*Basado en análisis de GentlemanNvim existente*
