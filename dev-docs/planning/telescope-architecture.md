# 🔭 Arquitectura Telescope + Snippets de Normalidad

> **Nueva estrategia**: Menús por sistema + snippets cortos para normalidad

---

## 📋 Índice

- [Filosofía del Diseño](#filosofía-del-diseño)
- [Arquitectura General](#arquitectura-general)
- [Parte A: Integración de Telescope](#parte-a-integración-de-telescope)
- [Parte B: Snippets de Normalidad](#parte-b-snippets-de-normalidad)
- [Flujo de Uso Real](#flujo-de-uso-real)
- [Roadmap de Expansión](#roadmap-de-expansión)

---

## 🎯 Filosofía del Diseño

### Problema Original

El diseño inicial con `evo3000` y comandos de 3 letras planteaba un desafío:
- **Normalidad**: fácil de expresar con snippet corto (`hst`, `nbo`)
- **Patología**: requiere muchas combinaciones (shock + DVA, SDRA + prono, sepsis + ATB, etc.)
- **Resultado**: explosión de prefijos difíciles de memorizar (200+ códigos)

### Solución: Telescope como Menú por Sistema

**Principio**: Separar normalidad de patología por método de acceso

| Situación | Método | Razón |
|-----------|--------|-------|
| **Normalidad** | Snippet directo (3 letras + Tab) | Frecuente, rápido, memorizable |
| **Patología** | Menú Telescope (`<leader>hh`) | Infrecuente, complejo, visual |

**Ventajas**:
- ✅ **Memorización mínima**: 8 códigos de normalidad vs. 200+ patológicos
- ✅ **Escalable**: agregar plantillas patológicas sin memorizar nuevos códigos
- ✅ **Descubrible**: menú muestra todas las opciones disponibles
- ✅ **Flexibilidad**: texto libre sigue siendo opción para casos únicos

---

## 🏗️ Arquitectura General

```
┌─────────────────────────────────────────────────────┐
│                  EVOLUCIÓN N4N                      │
│                                                     │
│  Sistema: HEMODINÁMICO                             │
│                                                     │
│  Opciones de entrada:                              │
│                                                     │
│  1. NORMALIDAD (snippet directo)                   │
│     hst<Tab> → texto de hemodinamia estable        │
│                                                     │
│  2. PATOLOGÍA (menú Telescope)                     │
│     <leader>hh → menú con opciones:                │
│       • Hemodinamia normal [hst]                   │
│       • Shock séptico + DVA [plantilla]            │
│       • Hipotensión post-sedación [plantilla]      │
│       • PA elevada + antihipertensivo [plantilla]  │
│       • ...                                        │
│                                                     │
│  3. TEXTO LIBRE (siempre disponible)               │
│     Casos únicos sin plantilla                     │
└─────────────────────────────────────────────────────┘
```

**Flujo de decisión**:

```
¿El paciente está "normal" en este sistema?
  ├─ SÍ → Snippet directo (hst, nbo, rst...)
  └─ NO → ¿Recuerdas el prefijo de la situación?
            ├─ SÍ → Úsalo directamente
            └─ NO → <leader>XX → menú Telescope → elige opción
```

---

## 🔧 Parte A: Integración de Telescope

### 1. Agregar Telescope al init.lua

**Archivo**: `~/n4n-dev/config/nvim/init.lua`

```lua
-- Añadir dentro del require("lazy").setup({ ... })

require("lazy").setup({
  -- Snippets (ya existentes)
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },
  { "rafamadriz/friendly-snippets" },

  -- Telescope y dependencias (NUEVO)
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
})
```

**Verificación**:

```bash
# Abre N4N dev
~/n4n-dev/n4n-mac.sh

# En Neovim:
:Lazy

# Debe aparecer "telescope.nvim" instalado
```

---

### 2. Crear Módulo de Menús por Sistema

**Archivo**: `~/n4n-dev/config/nvim/lua/n4n/telescope_systems.lua`

```lua
-- ~/n4n-dev/config/nvim/lua/n4n/telescope_systems.lua
local M = {}

-- Base de datos de sistemas y sus plantillas
local systems = {
  hemo = {
    { label = "Hemodinamia normal estable", snippet_prefix = "hst" },
    -- Más adelante: "Shock séptico + DVA", "Hipotensión post-sedación", etc.
  },
  neuro = {
    { label = "Neuro basal normal", snippet_prefix = "nbo" },
    -- Más adelante: "Glasgow alterado", "Pupilas asimétricas", etc.
  },
  resp = {
    { label = "Respiratorio dentro de metas", snippet_prefix = "rst" },
    -- Más adelante: "SDRA + prono", "Destete VM progresivo", etc.
  },
  inf = {
    { label = "Infeccioso sin foco activo", snippet_prefix = "ist" },
    -- Más adelante: "Sepsis + cultivos", "Foco respiratorio", etc.
  },
  meta = {
    { label = "Metabólico–nutricional compensado", snippet_prefix = "mst" },
    -- Más adelante: "Hiperglicemia descompensada", "Acidosis metabólica", etc.
  },
  elim = {
    { label = "Eliminación conservada", snippet_prefix = "elm" },
    -- Más adelante: "Oliguria + furosemida", "IRA + HD", etc.
  },
  dolor = {
    { label = "Dolor y confort adecuados", snippet_prefix = "dst" },
    -- Más adelante: "Dolor intenso refractario", "Sedación profunda", etc.
  },
  onco = {
    { label = "Oncológico sin eventos agudos", snippet_prefix = "ost" },
    -- Más adelante: "Neutropenia febril", "Síndrome lisis tumoral", etc.
  },
}

-- Función para abrir menú de un sistema específico
function M.open(system_key)
  -- Verificar que Telescope esté disponible
  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify("Telescope no disponible. Instala con :Lazy", vim.log.levels.ERROR)
    return
  end

  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  -- Obtener plantillas del sistema solicitado
  local items = systems[system_key]
  if not items then
    vim.notify("Sistema no definido: " .. tostring(system_key), vim.log.levels.ERROR)
    return
  end

  -- Crear picker de Telescope
  pickers
    .new({}, {
      prompt_title = "Sistema " .. system_key:upper() .. " (N4N)",
      finder = finders.new_table({
        results = items,
        entry_maker = function(item)
          return {
            value = item,
            display = item.label .. " [" .. item.snippet_prefix .. "]",
            ordinal = item.label .. " " .. item.snippet_prefix,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(_, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        -- Acción al presionar Enter: insertar prefijo del snippet
        local insert_snippet_prefix = function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if not selection or not selection.value then
            return
          end

          -- Insertar el prefijo en el buffer actual
          local prefix = selection.value.snippet_prefix
          vim.api.nvim_put({ prefix }, "c", true, true)

          -- Nota: el usuario deberá presionar Tab para expandir el snippet
          -- Más adelante podemos automatizar esto llamando a LuaSnip
        end

        -- Mapear Enter en modo insert y normal
        map("i", "<CR>", insert_snippet_prefix)
        map("n", "<CR>", insert_snippet_prefix)
        return true
      end,
    })
    :find()
end

return M
```

**Estructura del módulo**:
- `systems`: tabla con todas las plantillas por sistema
- `M.open(system_key)`: abre menú Telescope para un sistema específico
- Al seleccionar opción: inserta prefijo del snippet (luego Tab para expandir)

---

### 3. Configurar Keymaps por Sistema

**Archivo**: `~/n4n-dev/config/nvim/init.lua` (al final)

```lua
-- ============================================
-- KEYMAPS N4N: Menús Telescope por sistema
-- ============================================

-- Hemodinamia
vim.keymap.set("n", "<leader>hh", function()
  require("n4n.telescope_systems").open("hemo")
end, { desc = "[N4N] Menú hemodinamia" })

-- Neurológico
vim.keymap.set("n", "<leader>nn", function()
  require("n4n.telescope_systems").open("neuro")
end, { desc = "[N4N] Menú neuro" })

-- Respiratorio
vim.keymap.set("n", "<leader>rr", function()
  require("n4n.telescope_systems").open("resp")
end, { desc = "[N4N] Menú respiratorio" })

-- Infeccioso
vim.keymap.set("n", "<leader>ii", function()
  require("n4n.telescope_systems").open("inf")
end, { desc = "[N4N] Menú infeccioso" })

-- Metabólico/Nutricional
vim.keymap.set("n", "<leader>mm", function()
  require("n4n.telescope_systems").open("meta")
end, { desc = "[N4N] Menú metabólico" })

-- Eliminación
vim.keymap.set("n", "<leader>ee", function()
  require("n4n.telescope_systems").open("elim")
end, { desc = "[N4N] Menú eliminación" })

-- Dolor y Confort
vim.keymap.set("n", "<leader>dd", function()
  require("n4n.telescope_systems").open("dolor")
end, { desc = "[N4N] Menú dolor y confort" })

-- Oncológico
vim.keymap.set("n", "<leader>oo", function()
  require("n4n.telescope_systems").open("onco")
end, { desc = "[N4N] Menú oncológico" })
```

**Mnemotécnica**:
- `<leader>hh` = **H**emo **H**emo
- `<leader>nn` = **N**euro **N**euro
- `<leader>rr` = **R**esp **R**esp
- `<leader>ii` = **I**nf **I**nf
- `<leader>mm` = **M**eta **M**eta
- `<leader>ee` = **E**lim **E**lim
- `<leader>dd` = **D**olor **D**olor
- `<leader>oo` = **O**nco **O**nco

**Nota**: Si `<leader>` es espacio (default), entonces `Espacio + h + h` abre menú hemodinámico.

---

### 4. Crear Directorio para Módulos N4N

```bash
mkdir -p ~/n4n-dev/config/nvim/lua/n4n
touch ~/n4n-dev/config/nvim/lua/n4n/telescope_systems.lua
```

**Estructura resultante**:

```
~/n4n-dev/config/nvim/
├── init.lua
├── snippets/
│   └── markdown.json
└── lua/
    └── n4n/
        └── telescope_systems.lua
```

---

## 📝 Parte B: Snippets de Normalidad

### Filosofía de los Snippets de Normalidad

**Características**:
- **Prefijo de 3 letras**: fácil de memorizar (`hst`, `nbo`, `rst`)
- **Texto clínicamente completo**: describe "todo normal" sin campos vacíos
- **Lenguaje chileno UPC**: "presión arterial" (no "tensión"), terminología local
- **Auto-contenidos**: no requieren explicaciones adicionales

**Sistemas cubiertos** (8 snippets):

| Sistema | Prefijo | Descripción |
|---------|---------|-------------|
| Neurológico | `nbo` | **N**euro **B**asal **O**K |
| Hemodinámico | `hst` | **H**emo e**ST**able |
| Respiratorio | `rst` | **R**esp e**ST**able |
| Infeccioso | `ist` | **I**nf e**ST**able |
| Metabólico | `mst` | **M**eta e**ST**able |
| Eliminación | `elm` | **EL**i**M**inación |
| Dolor/Confort | `dst` | **D**olor e**ST**able |
| Oncológico | `ost` | **O**nco e**ST**able |

---

### Snippets Completos

**Archivo**: `~/n4n-dev/config/nvim/snippets/markdown.json`

```json
{
  "NEURO - Basal normal": {
    "prefix": "nbo",
    "body": [
      "**Neuro:** Paciente vigil, tranquilo y cooperador.",
      "Orienta en persona, lugar y tiempo. Lenguaje claro, sin alteraciones evidentes.",
      "No se pesquisa deficit motor ni sensitivo grosero, movimientos simetricos en las cuatro extremidades.",
      "Pupilas isocoricas, reactivas a la luz. Sin signos de compromiso de pares craneales.",
      "No refiere cefalea intensa, vision borrosa ni otros sintomas neurológicos agudos."
    ],
    "description": "Estado neurológico basal dentro de rangos normales"
  },

  "HEMO - Hemodinamia normal estable": {
    "prefix": "hst",
    "body": [
      "**Hemodinamia:** Presion arterial en rango objetivo (${1:120/70} mmHg aprox.), PAM ${2:>65} mmHg.",
      "Frecuencia cardiaca ${3:70-90} lpm en ritmo ${4:sinusal}.",
      "Perfusion periférica conservada: piel tibia, llene capilar <3s, pulsos periféricos palpables bilateralmente.",
      "Sin uso de drogas vasoactivas. Diuresis adecuada para peso y horario."
    ],
    "description": "Hemodinamia estable sin requerimiento de vasopresores"
  },

  "RESP - Ventilacion y oxigenacion dentro de metas": {
    "prefix": "rst",
    "body": [
      "**Respiratorio:** Ventila en forma ${1:espontanea/en VM} con Fio2 ${2:21%} logrando saturacion de oxigeno ${3:>=94%}.",
      "Frecuencia respiratoria ${4:12-20} rpm, sin uso de musculatura accesoria ni signos de dificultad respiratoria.",
      "A la auscultacion, murmullo pulmonar conservado bilateral, sin ruidos agregados relevantes.",
      "No tosedor productivo significativo, secreciones escasas y manejables."
    ],
    "description": "Respiracion y oxigenacion dentro de metas sin signos de distress"
  },

  "INF - Sin foco infeccioso aparente": {
    "prefix": "ist",
    "body": [
      "**Infeccioso:** Paciente afebril, temperatura ${1:36-37.5}°C.",
      "No se observan signos locales de infeccion en accesos venosos, cateteres ni heridas.",
      "No refiere escalofrios ni malestar general marcado. No hay cambios recientes en hemodinamia atribuibles a sepsis.",
      "Si se encuentra en tratamiento antibiotico, lo tolera sin reacciones adversas aparentes."
    ],
    "description": "Situacion infecciosa sin foco activo evidente"
  },

  "META - Metabolico y nutricional compensado": {
    "prefix": "mst",
    "body": [
      "**Metabolico/nutricional:** Glicemias dentro de rango meta ${1:(ej. 100-160 mg/dL)} sin hipoglicemias sintomaticas.",
      "Via de alimentacion ${2:oral/SNG/GTT} con buena tolerancia, sin nauseas ni vomitos.",
      "Balance hídrico cercano a la meta definida, sin signos de deshidratacion ni sobrecarga evidentes.",
      "Electrolitos y parametros metabolicos en seguimiento por equipo medico sin descompensaciones agudas conocidas."
    ],
    "description": "Estado metabolico y nutricional sin alteraciones agudas relevantes"
  },

  "ELIM - Eliminacion conservada": {
    "prefix": "elm",
    "body": [
      "**Eliminacion:** Diuresis adecuada para peso y horario, color y aspecto habituales.",
      "Deposiciones presentes segun pauta y habitualidad del paciente, sin diarrea ni sangrado evidente.",
      "No refiere disuria, dolor abdominal intenso ni dificultad para eliminar.",
      "En caso de cateter urinario o ostomias, orificios limpios, funcionando sin obstrucciones y sin signos de infeccion."
    ],
    "description": "Eliminacion urinaria e intestinal conservada"
  },

  "DOLOR - Dolor y confort adecuados": {
    "prefix": "dst",
    "body": [
      "**Dolor y confort:** Paciente refiere dolor ${1:0-3/10} en escala numerica, manejable con esquema analgésico vigente.",
      "Se mantiene posicion comoda, se realizan cambios posturales segun protocolo y se verifica correcta alineacion corporal.",
      "No evidencia signos de dolor intenso no verbal (gestos, sudoracion, taquicardia marcada) durante la evaluacion.",
      "Familia y/o paciente informados del plan de manejo del dolor."
    ],
    "description": "Dolor controlado y medidas de confort adecuadas"
  },

  "ONCO - Situacion oncológica sin eventos agudos": {
    "prefix": "ost",
    "body": [
      "**Oncologico:** Paciente en contexto de ${1:quimioterapia/radioterapia/postoperatorio/otro} sin eventos agudos en este turno.",
      "Signos vitales dentro de rangos esperados para su condicion, sin sangrado activo ni dolor oncológico descompensado.",
      "Dispositivos oncológicos (port-a-cath, drenajes, sondas) en buen estado, sin signos de infeccion ni disfuncion.",
      "Se mantiene plan terapeutico indicado, sin reacciones adversas significativas durante el turno."
    ],
    "description": "Situacion oncológica estable sin complicaciones agudas"
  }
}
```

**Notas técnicas**:
- Campos `${1:...}`: tabs para personalizar valores rápidamente
- Sin campos vacíos: describe situación "normal completa"
- Lenguaje: español chileno UPC (presión, no tensión; llene capilar, etc.)

---

## 🚀 Flujo de Uso Real

### Caso 1: Paciente Estable (Normalidad en Todos los Sistemas)

**Contexto**: Turno noche UPC, paciente postoperatorio día 3, evolución sin novedades.

```bash
# 1. Abrir archivo de turno
~/n4n-dev/n4n-mac.sh UPC-2025-11-24-Noche.md

# 2. Crear estructura de evolución
i
## Paciente 1 – Cama 5 – López, María
### Evolución 22:00 hrs

# 3. Sistema por sistema usando snippets de normalidad

# Neuro
nbo<Tab>

# Hemo
hst<Tab>

# Resp
rst<Tab>

# Inf
ist<Tab>

# Meta
mst<Tab>

# Elim
elm<Tab>

# Dolor
dst<Tab>

# Onco (si aplica)
ost<Tab>

# ¡Listo! Evolución completa en ~2 minutos
```

**Resultado**:

```markdown
## Paciente 1 – Cama 5 – López, María
### Evolución 22:00 hrs

**Neuro:** Paciente vigil, tranquilo y cooperador.
Orienta en persona, lugar y tiempo. Lenguaje claro, sin alteraciones evidentes.
No se pesquisa deficit motor ni sensitivo grosero, movimientos simetricos en las cuatro extremidades.
Pupilas isocoricas, reactivas a la luz. Sin signos de compromiso de pares craneales.
No refiere cefalea intensa, vision borrosa ni otros sintomas neurológicos agudos.

**Hemodinamia:** Presion arterial en rango objetivo (120/70 mmHg aprox.), PAM >65 mmHg.
Frecuencia cardiaca 70-90 lpm en ritmo sinusal.
Perfusion periférica conservada: piel tibia, llene capilar <3s, pulsos periféricos palpables bilateralmente.
Sin uso de drogas vasoactivas. Diuresis adecuada para peso y horario.

[... resto de sistemas ...]
```

---

### Caso 2: Patología en Un Sistema (Menú Telescope)

**Contexto**: Mismo paciente, pero con hipotensión por sedación.

```bash
# Sistemas normales: usar snippets directos
nbo<Tab>  # Neuro OK
rst<Tab>  # Resp OK

# Hemodinamia alterada: usar menú
<Esc>
<leader>hh  # Abre menú Telescope

# Aparece menú:
# ┌─ Sistema HEMO (N4N) ────────────────┐
# │ Hemodinamia normal estable [hst]    │
# │ > Shock séptico + DVA [shock-septico] │ ← (futuro)
# │ Hipotensión post-sedación [hipo-sed]  │ ← (futuro)
# └─────────────────────────────────────┘

# Por ahora solo hay "hst", pero se elige igual
# Presionas Enter → inserta "hst" → presionas Tab → expansión

# Luego ajustas manualmente el texto o usas plantilla futura
```

**Nota**: En esta fase inicial, el menú solo tiene la opción de normalidad. Más adelante agregarás plantillas patológicas y el menú será más útil.

---

### Caso 3: Situación Única Sin Plantilla

**Contexto**: Complicación rara sin plantilla existente.

```bash
# Usa texto libre directamente
i
**Hemodinamia:** Paciente presenta episodio de bradicardia sinusal
(FC 45 lpm) sostenida durante 10 minutos, asociada a tos intensa.
Se administra atropina 0.5mg IV según indicación médica con respuesta
favorable (FC 65 lpm). Se mantiene en observación estrecha.
<Esc>

# Sin snippet, sin menú. Texto libre cuando la situación lo requiere.
```

---

## 📚 Roadmap de Expansión

### Fase 1: Setup Inicial (actual)

**Objetivos**:
- [x] Instalar Telescope
- [x] Crear módulo `telescope_systems.lua`
- [x] Configurar keymaps por sistema
- [x] Crear 8 snippets de normalidad
- [ ] Validar con 2-3 evoluciones reales

**Duración**: 1-2 horas setup + 1-2 días validación

---

### Fase 2: Primeras Plantillas Patológicas (próximo)

**Sistema piloto**: Hemodinámico (es el más crítico en UPC)

**Plantillas a crear**:

```lua
hemo = {
  { label = "Hemodinamia normal estable", snippet_prefix = "hst" },
  { label = "Shock séptico + noradrenalina", snippet_prefix = "shock-septico" },
  { label = "Hipotensión post-sedación", snippet_prefix = "hipo-sed" },
  { label = "PA elevada + antihipertensivo", snippet_prefix = "hta-desa" },
  { label = "Hipovolemia + bolos EV", snippet_prefix = "hipo-vol" },
  { label = "Arritmia + antiarrítmico", snippet_prefix = "arritmia" },
},
```

**Trabajo**:
1. Escribir snippets para cada plantilla en `markdown.json`
2. Agregar entradas en `telescope_systems.lua`
3. Validar con casos reales

**Duración**: 2-3 horas por sistema

---

### Fase 3: Expansión a Todos los Sistemas

**Orden de prioridad** (según frecuencia en UPC):
1. Hemodinámico (Fase 2) ✅
2. Respiratorio (VM, destete, SDRA)
3. Infeccioso (sepsis, focos, cultivos)
4. Neurológico (Glasgow, pupilas, sedación)
5. Metabólico (glicemia, acidosis, electrolitos)
6. Eliminación (oliguria, IRA, HD)
7. Dolor (EVA alta, sedación profunda)
8. Oncológico (neutropenia, lisis tumoral)

**Trabajo**: 2-3 horas por sistema × 7 sistemas = 14-21 horas total

**Duración**: 2-3 semanas implementando 1-2 sistemas por semana

---

### Fase 4: Expansión Directa de LuaSnip (opcional, futuro)

**Problema actual**: Menú Telescope inserta prefijo → usuario presiona Tab

**Mejora futura**: Menú Telescope expande snippet directamente

**Implementación**:

```lua
-- En telescope_systems.lua, cambiar:
local insert_snippet_prefix = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  local prefix = selection.value.snippet_prefix

  -- Llamar a LuaSnip para expandir snippet directamente
  local ls = require("luasnip")
  vim.api.nvim_put({ prefix }, "c", true, true)
  ls.expand()  -- Expande automáticamente
end
```

**Ventaja**: Flujo más suave (elegir → expansión automática)

**Cuándo hacerlo**: Después de validar Fase 3, cuando ya estés cómodo con el flujo

---

### Fase 5: Plantillas Combinatorias (avanzado)

**Problema**: Algunas situaciones son combinaciones de múltiples sistemas

**Ejemplo**: Shock séptico de foco respiratorio con SDRA

**Solución**: Plantillas "multi-sistema" en menú especial

```lua
-- Nuevo keymap
vim.keymap.set("n", "<leader>cc", function()
  require("n4n.telescope_systems").open("combinatorias")
end, { desc = "[N4N] Plantillas combinatorias" })

-- Nueva entrada en systems
combinatorias = {
  { label = "Shock séptico respiratorio + VM", snippet_prefix = "shock-resp-vm" },
  { label = "IRA + shock + HD", snippet_prefix = "ira-shock-hd" },
  { label = "Síndrome compartimental abdominal", snippet_prefix = "sca" },
  -- ...
},
```

**Cuándo hacerlo**: Cuando domines completamente Fases 1-3 y detectes patrones recurrentes

---

## ✅ Checklist de Implementación

### Setup Inicial

- [ ] Telescope instalado y funcionando
  ```vim
  :Telescope  " Debe abrir sin errores
  ```

- [ ] Módulo `telescope_systems.lua` creado
  ```bash
  ls ~/n4n-dev/config/nvim/lua/n4n/telescope_systems.lua
  ```

- [ ] Keymaps configurados
  ```vim
  :nmap <leader>hh  " Debe mostrar binding N4N
  ```

- [ ] 8 snippets de normalidad funcionando
  ```markdown
  nbo<Tab>  " Expande neuro normal
  hst<Tab>  " Expande hemo normal
  rst<Tab>  " Expande resp normal
  ist<Tab>  " Expande inf normal
  mst<Tab>  " Expande meta normal
  elm<Tab>  " Expande elim normal
  dst<Tab>  " Expande dolor normal
  ost<Tab>  " Expande onco normal
  ```

---

### Validación con Casos Reales

**Objetivo**: Probar con 2-3 evoluciones reales (sin datos de pacientes)

**Caso 1: Paciente estable postoperatorio**
- [ ] Evolución completa con 8 snippets de normalidad
- [ ] Tiempo de escritura: ¿< 3 minutos?
- [ ] Texto clínicamente correcto y completo

**Caso 2: Paciente con alteración en 1 sistema**
- [ ] 7 sistemas con snippets de normalidad
- [ ] 1 sistema con menú Telescope (aunque sea para elegir normalidad)
- [ ] Ajuste manual para reflejar patología

**Caso 3: Paciente complejo con múltiples alteraciones**
- [ ] Mix de snippets, menú y texto libre
- [ ] Flujo de trabajo fluido entre métodos
- [ ] Documento final legible y completo

---

### Refinamiento de Snippets

**Después de 2-3 evoluciones reales**:

- [ ] ¿Algún snippet de normalidad es demasiado largo?
- [ ] ¿Falta información clínica importante?
- [ ] ¿El lenguaje calza con tu manera real de registrar?
- [ ] ¿Los campos `${1:...}` están en los lugares correctos?

**Ajustar según feedback real antes de expandir a plantillas patológicas**

---

## 📊 Comparación con Diseño Original

| Aspecto | Diseño Original | Nuevo Diseño (Telescope) |
|---------|----------------|--------------------------|
| **Normalidad** | evo3000 (71 campos) | 8 snippets cortos (nbo, hst, rst...) |
| **Patología simple** | Comandos de 3 letras (hcp, sno) | Snippet directo si se memoriza |
| **Patología compleja** | ¿200+ códigos de 3 letras? | Menú Telescope por sistema |
| **Memorización** | Alta (muchos códigos) | Baja (8 códigos + menús) |
| **Descubribilidad** | Baja (debes recordar códigos) | Alta (menú muestra opciones) |
| **Escalabilidad** | Difícil (explosión de códigos) | Fácil (agregar a menú) |
| **Texto libre** | Siempre opción | Siempre opción |

**Conclusión**: El nuevo diseño mantiene la velocidad para normalidad (snippets directos) y resuelve la escalabilidad para patología (menús visuales).

---

## 🎓 Principios de Diseño

### 1. Separación por Frecuencia

**Frecuente** → método rápido (snippet directo)
**Infrecuente** → método visual (menú)

### 2. Memorización Mínima

Solo 8 códigos básicos para normalidad. Todo lo demás es descubrible.

### 3. Escalabilidad Sin Fricción

Agregar plantillas no requiere memorizar nuevos códigos. Solo aparecen en menú.

### 4. Texto Libre Siempre Disponible

Ninguna plantilla reemplaza el juicio clínico. Si la situación es única, escribe libremente.

### 5. Validación Antes de Expansión

Prueba con casos reales antes de agregar más plantillas. No asumas qué necesitas.

---

**Última actualización**: 2025-11-24
**Mantenido por**: @fegome90-cmd
