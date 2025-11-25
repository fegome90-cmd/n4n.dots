# 🚀 Guía de Implementación - Snippets PDF 3000 + Telescope

Esta guía te muestra cómo implementar el sistema completo de snippets de normalidad basado en el PDF 3000 con menús Telescope.

---

## 📋 Índice

- [Archivos Incluidos](#archivos-incluidos)
- [Prerequisitos](#prerequisitos)
- [Instalación Paso a Paso](#instalación-paso-a-paso)
- [Verificación](#verificación)
- [Primer Uso](#primer-uso)
- [Troubleshooting](#troubleshooting)

---

## 📁 Archivos Incluidos

En esta carpeta `config-templates/` encontrarás:

| Archivo | Descripción | Destino |
|---------|-------------|---------|
| `markdown.json` | 11 snippets completos (evo, nbo, hst, rst, ist, mst, elm, dst, ost, efn, pen) | `~/n4n-dev/config/nvim/snippets/` |
| `telescope_systems.lua` | Módulo Telescope con menús por sistema | `~/n4n-dev/config/nvim/lua/n4n/` |
| `n4n-keymaps.lua` | Keymaps para todos los menús | `~/n4n-dev/config/nvim/lua/n4n/` o en `init.lua` |

---

## ✅ Prerequisitos

Antes de empezar, asegúrate de tener:

- [ ] Neovim instalado (v0.9.0 o superior)
- [ ] LuaSnip instalado y funcionando
- [ ] Telescope instalado (si no, se instala en paso 3)
- [ ] lazy.nvim como gestor de plugins
- [ ] Entorno N4N configurado (o GentlemanNvim si usas Alternativa A/B)

**Verificación rápida**:

```bash
# Verificar Neovim
nvim --version
# Debe mostrar: NVIM v0.9.x o superior

# Verificar que tienes el entorno N4N
ls ~/n4n-dev/config/nvim/init.lua
# O si usas GentlemanNvim:
ls ~/.config/nvim/init.lua
```

---

## 🔧 Instalación Paso a Paso

### Paso 1: Agregar Telescope a lazy.nvim (si no lo tienes)

Abre tu `init.lua` y agrega Telescope dentro de `require("lazy").setup({ ... })`:

**Archivo**: `~/n4n-dev/config/nvim/init.lua` (o `~/.config/nvim/init.lua`)

```lua
require("lazy").setup({
  -- ... tus plugins existentes ...

  -- LuaSnip (ya deberías tenerlo)
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },
  { "rafamadriz/friendly-snippets" },

  -- Telescope y dependencias (AGREGAR ESTO)
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
})
```

**Guardar y recargar**:

```vim
:w
:source %
:Lazy sync
```

**Esperar** a que Telescope se instale (puede tomar 30-60 segundos).

**Verificar**:

```vim
:Telescope
# Debe abrir el menú de Telescope sin errores
```

---

### Paso 2: Copiar Snippets

Copia el archivo `markdown.json` a tu directorio de snippets:

```bash
# Crear directorio si no existe
mkdir -p ~/n4n-dev/config/nvim/snippets
# O si usas GentlemanNvim:
# mkdir -p ~/.config/nvim/snippets

# Copiar archivo de snippets
cp ~/n4n.dots/dev-docs/config-templates/markdown.json \
   ~/n4n-dev/config/nvim/snippets/markdown.json

# O si usas GentlemanNvim:
# cp ~/n4n.dots/dev-docs/config-templates/markdown.json \
#    ~/.config/nvim/snippets/markdown.json
```

**Verificar**:

```bash
cat ~/n4n-dev/config/nvim/snippets/markdown.json | head -20
# Debe mostrar el contenido del archivo JSON
```

---

### Paso 3: Copiar Módulo Telescope

Copia el módulo `telescope_systems.lua` a tu directorio de módulos N4N:

```bash
# Crear directorio si no existe
mkdir -p ~/n4n-dev/config/nvim/lua/n4n
# O si usas GentlemanNvim:
# mkdir -p ~/.config/nvim/lua/n4n

# Copiar módulo Telescope
cp ~/n4n.dots/dev-docs/config-templates/telescope_systems.lua \
   ~/n4n-dev/config/nvim/lua/n4n/telescope_systems.lua

# O si usas GentlemanNvim:
# cp ~/n4n.dots/dev-docs/config-templates/telescope_systems.lua \
#    ~/.config/nvim/lua/n4n/telescope_systems.lua
```

**Verificar**:

```bash
ls ~/n4n-dev/config/nvim/lua/n4n/
# Debe listar: telescope_systems.lua
```

---

### Paso 4: Agregar Keymaps

Tienes dos opciones:

#### Opción A: Crear archivo separado de keymaps (recomendado)

```bash
# Copiar keymaps a módulo N4N
cp ~/n4n.dots/dev-docs/config-templates/n4n-keymaps.lua \
   ~/n4n-dev/config/nvim/lua/n4n/keymaps.lua
```

**Luego en tu `init.lua`, agregar al final**:

```lua
-- Cargar keymaps N4N
require("n4n.keymaps")
```

#### Opción B: Pegar directamente en init.lua

Abre `~/n4n-dev/config/nvim/init.lua` y pega **al final** el contenido de `n4n-keymaps.lua`:

```lua
-- ... tu init.lua existente ...

-- ============================================
-- KEYMAPS N4N: Menús Telescope por sistema
-- ============================================

vim.keymap.set("n", "<leader>hh", function()
  require("n4n.telescope_systems").open("hemo")
end, { desc = "[N4N] Menú hemodinamia" })

-- ... resto de keymaps ...
```

**Guardar y recargar**:

```vim
:w
:source %
```

---

### Paso 5: Configurar LuaSnip para Cargar Snippets

Asegúrate de que LuaSnip esté configurado para cargar snippets desde tu directorio.

**En tu `init.lua`, agregar o verificar que exista**:

```lua
-- Configuración de LuaSnip
local ls = require("luasnip")

-- Cargar snippets de VSCode (friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

-- Cargar snippets personalizados de VSCode-format
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { "~/n4n-dev/config/nvim/snippets" }
  -- O si usas GentlemanNvim:
  -- paths = { "~/.config/nvim/snippets" }
})

-- Configurar Tab para expandir y saltar entre campos
vim.keymap.set({"i", "s"}, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    return "<Tab>"
  end
end, { silent = true, expr = true })

vim.keymap.set({"i", "s"}, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    return "<S-Tab>"
  end
end, { silent = true, expr = true })
```

**Guardar y recargar**:

```vim
:w
:source %
```

---

## ✅ Verificación

### 1. Verificar que Telescope funciona

```vim
:Telescope
# Debe abrir menú sin errores
```

### 2. Verificar que los snippets están cargados

Abre un archivo markdown:

```vim
:e test.md
```

En modo INSERT, escribe:

```
nbo
```

Luego presiona `Tab`. Debe expandirse el snippet de neuro normal.

Si no funciona:
- Verifica que estás en un archivo `.md`
- Verifica la ruta en `lazy_load({ paths = {...} })`
- Recarga: `:LuaSnipUnlinkCurrent` y `:source %`

### 3. Verificar que los menús Telescope funcionan

En modo NORMAL:

```vim
# Presiona: Espacio h h
<leader>hh
```

Debe abrir un menú Telescope con:
```
Sistema HEMO (N4N)
> Hemodinamia normal estable [hst]
```

Si funciona, presiona `Enter` → debe insertar `hst` → luego presiona `Tab` → debe expandirse el snippet.

---

## 🎯 Primer Uso

### Flujo Completo para Evolución "Todo Normal"

1. **Abrir archivo de turno**:

```bash
# Si usas entorno N4N aislado:
~/n4n-dev/n4n-mac.sh UPC-2025-11-24-Noche.md

# Si usas GentlemanNvim:
nvim ~/Documents/RegistrosEnfermeria/UPC-2025-11-24-Noche.md
```

2. **Insertar estructura**:

```vim
# Modo INSERT
i
evo<Tab>

# Aparece toda la estructura:
# EVOLUCIÓN STANDARD - N4N
# Recibo paciente conforme...
# ## NEUROLÓGICO
# ## HEMODINÁMICO
# ...
```

3. **Llenar sistemas con snippets**:

Método 1: **Snippet directo** (más rápido):

```vim
# Bajo sección NEUROLÓGICO
nbo<Tab>
# Expande texto neuro normal

# Bajo HEMODINÁMICO
hst<Tab>
# Expande texto hemo estable
```

Método 2: **Menú Telescope** (más descubrible):

```vim
# Bajo sección NEUROLÓGICO
<Esc>
<leader>nn
# Aparece menú → selecciona "Neurológico basal normal [nbo]"
# Presiona Enter → inserta "nbo"
# Presiona Tab → expande snippet
```

4. **Completar examen físico**:

```vim
# Bajo EXAMEN FÍSICO SEGMENTADO
<Esc>
<leader>xf
# Selecciona "Examen físico segmentado normal [efn]"
# Enter → efn → Tab
```

5. **Agregar plan**:

```vim
# Bajo PENDIENTES / PLAN
<Esc>
<leader>xp
# Selecciona "Pendientes / Plan estándar [pen]"
# Enter → pen → Tab
```

6. **Guardar**:

```vim
:wq
```

**Tiempo estimado**: 2-3 minutos para evolución completa "todo normal".

---

## 🛠️ Troubleshooting

### Problema 1: Telescope no se abre

**Error**: `Telescope no disponible`

**Solución**:

```vim
:Lazy
# Busca "telescope.nvim"
# Si no está instalado: :Lazy install telescope.nvim
# Si está instalado: :Lazy sync
```

---

### Problema 2: Snippets no se expanden

**Síntomas**: Escribes `nbo<Tab>` y no pasa nada.

**Diagnóstico**:

1. **Verifica que estás en archivo markdown**:
```vim
:set filetype?
# Debe decir: filetype=markdown
```

2. **Verifica que LuaSnip cargó los snippets**:
```vim
:lua print(vim.inspect(require("luasnip").get_snippets("markdown")))
# Debe mostrar lista de snippets, incluyendo "nbo", "hst", etc.
```

3. **Verifica la ruta de snippets**:
```bash
ls ~/n4n-dev/config/nvim/snippets/markdown.json
# Debe existir
```

**Solución**:

Si la ruta es incorrecta, edita `init.lua`:

```lua
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { "~/n4n-dev/config/nvim/snippets" } -- Ajustar esta ruta
})
```

Luego recarga:

```vim
:source %
:lua require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/n4n-dev/config/nvim/snippets" } })
```

---

### Problema 3: Menú Telescope se abre pero no inserta nada

**Síntomas**: Presionas `<leader>hh`, aparece menú, seleccionas opción, presionas Enter, pero no se inserta `hst`.

**Diagnóstico**:

```vim
:lua print(vim.inspect(require("n4n.telescope_systems")))
# Si da error: módulo no encontrado
```

**Solución**:

Verifica que el archivo existe:

```bash
ls ~/n4n-dev/config/nvim/lua/n4n/telescope_systems.lua
```

Si no existe, repite Paso 3 de instalación.

Si existe, verifica que Lua encuentra el módulo:

```vim
:lua require("n4n.telescope_systems")
# No debe dar error
```

---

### Problema 4: Tab no expande, solo inserta tabulación

**Síntomas**: Presionas Tab y solo se inserta un tab, no expande snippet.

**Solución**:

Verifica configuración de Tab en `init.lua`:

```lua
-- Debe existir este mapeo:
vim.keymap.set({"i", "s"}, "<Tab>", function()
  if require("luasnip").expand_or_jumpable() then
    require("luasnip").expand_or_jump()
  else
    return "<Tab>"
  end
end, { silent = true, expr = true })
```

Si no existe, agrégalo y recarga:

```vim
:source %
```

---

### Problema 5: Leader key no funciona

**Síntomas**: Presionas `Espacio h h` y no pasa nada.

**Diagnóstico**:

```vim
:let mapleader
# Si está vacío o es diferente de espacio
```

**Solución**:

Configura leader explícitamente en `init.lua` (al inicio):

```lua
-- Configurar leader ANTES de lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "
```

Recarga:

```vim
:source %
```

---

## 📊 Resumen de Comandos

### Snippets Directos (más rápido)

| Snippet | Sistema | Uso |
|---------|---------|-----|
| `evo<Tab>` | Estructura completa | Al inicio de evolución |
| `nbo<Tab>` | Neuro normal | Bajo ## NEUROLÓGICO |
| `hst<Tab>` | Hemo estable | Bajo ## HEMODINÁMICO |
| `rst<Tab>` | Resp normal | Bajo ## RESPIRATORIO |
| `ist<Tab>` | Inf estable | Bajo ## INFECCIOSO |
| `mst<Tab>` | Meta normal | Bajo ## METABÓLICO |
| `elm<Tab>` | Elim normal | Bajo ## ELIMINACIÓN |
| `dst<Tab>` | Dolor OK | Bajo ## DOLOR Y CONFORT |
| `ost<Tab>` | Onco estable | Bajo ## ONCOLÓGICO |
| `efn<Tab>` | EF normal | Bajo ## EXAMEN FÍSICO |
| `pen<Tab>` | Plan estándar | Bajo ## PENDIENTES / PLAN |

---

### Menús Telescope (más descubrible)

| Keymap | Sistema | Menú |
|--------|---------|------|
| `<leader>hh` | Hemodinamia | Lista opciones hemo |
| `<leader>nn` | Neurológico | Lista opciones neuro |
| `<leader>rr` | Respiratorio | Lista opciones resp |
| `<leader>ii` | Infeccioso | Lista opciones inf |
| `<leader>mm` | Metabólico | Lista opciones meta |
| `<leader>ee` | Eliminación | Lista opciones elim |
| `<leader>dd` | Dolor/Confort | Lista opciones dolor |
| `<leader>oo` | Oncológico | Lista opciones onco |
| `<leader>xf` | Examen físico | Lista opciones EF |
| `<leader>xp` | Plan | Lista opciones plan |

**Flujo**: Keymap → Menú aparece → Enter → inserta prefijo → Tab → expande

---

## 🎓 Próximos Pasos

Una vez que tengas el sistema funcionando:

1. **Validar con 2-3 evoluciones reales**
   - Paciente estable postoperatorio
   - Paciente con alteración en 1 sistema
   - Paciente complejo

2. **Refinar textos**
   - ¿Algún snippet suena poco natural en tu UPC?
   - ¿Falta información clínica relevante?
   - Ajusta `markdown.json` según feedback

3. **Expandir a plantillas patológicas** (Fase 2)
   - Empieza con sistema hemodinámico
   - Agrega 4-6 plantillas patológicas comunes:
     - Shock séptico + noradrenalina
     - Hipotensión post-sedación
     - PA elevada + antihipertensivo
     - Arritmia + manejo
   - Agrega entradas en `telescope_systems.lua`
   - Crea snippets correspondientes en `markdown.json`

4. **Iterar según uso real**
   - Documental qué situaciones aparecen frecuentemente
   - Priorizar plantillas por frecuencia, no por exotismo
   - No agregar 200 plantillas "por si acaso"

---

**Última actualización**: 2025-11-24
**Mantenido por**: @fegome90-cmd
**Versión**: PDF 3000 normalidad + Telescope v1.0
