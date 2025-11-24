# Plan de Desarrollo: Entorno Mac para Snippets Clínicos N4N

**Objetivo**: Montar un laboratorio de desarrollo en macOS para diseñar, probar y refinar snippets clínicos antes de implementarlos en el entorno de producción (Windows portátil en hospital).

**Filosofía**: Mac = laboratorio experimental. Windows portátil = producción (UPC real).

---

## 🎯 Objetivos del Entorno de Desarrollo

### Neovim funcionando limpio
- ✅ Instalación independiente que no interfiere con tu config personal
- ✅ Entorno aislado con variables XDG propias
- ✅ Fácil de resetear si algo sale mal

### Snippets clínicos avanzados
- ✅ **Evolución por sistemas + examen físico segmentado** (inspirada en PDF de referencia)
- ✅ **Comandos clínicos** tipo `hcp` (hemodinamia/cambio/presión) que se expanden con Tab
- ✅ **Comandos SNO** (sistema/núcleo/objetivo) para frases rápidas estructuradas
- ✅ Expansión rápida sin sacrificar estructura mental clara

---

## 📋 Plan de 3 Fases (Ejecutable Hoy)

### 📦 FASE 1: Dejar Neovim Listo en macOS

#### 1. Instalar Neovim y herramientas básicas

```bash
brew install neovim ripgrep fd
```

**Qué hace**:
- `neovim`: Editor principal
- `ripgrep`: Búsqueda ultra-rápida en archivos
- `fd`: Búsqueda de archivos (alternativa a `find`)

---

#### 2. Crear config exclusiva para N4N (sin mezclar con tu config personal)

**Estructura de carpetas**:

```bash
mkdir -p ~/n4n-dev/config
mkdir -p ~/n4n-dev/registros
mkdir -p ~/n4n-dev/data
mkdir -p ~/n4n-dev/state
mkdir -p ~/n4n-dev/cache
```

**Resultado**:
```
~/n4n-dev/
├── config/          # Configuración de Neovim (aislada)
├── registros/       # Carpeta de trabajo para pruebas
├── data/            # Datos de Neovim (plugins, etc)
├── state/           # Estado de sesiones
└── cache/           # Cache de Neovim
```

---

#### 3. Crear script launcher para N4N-dev

```bash
cat > ~/n4n-dev/n4n-mac.sh << 'EOF'
#!/usr/bin/env bash

# Variables XDG para aislar este entorno de tu config personal
export XDG_CONFIG_HOME="$HOME/n4n-dev/config"
export XDG_DATA_HOME="$HOME/n4n-dev/data"
export XDG_STATE_HOME="$HOME/n4n-dev/state"
export XDG_CACHE_HOME="$HOME/n4n-dev/cache"

# Perfil de desarrollo (puedes usar esto para lógica condicional después)
export N4N_PROFILE="mac_dev"

# Crear directorio de config si no existe
mkdir -p "$XDG_CONFIG_HOME/nvim"

# Posicionarse en carpeta de registros
cd "$HOME/n4n-dev/registros"

# Lanzar Neovim
nvim "$@"
EOF

# Hacer ejecutable
chmod +x ~/n4n-dev/n4n-mac.sh
```

**Uso**:

```bash
# Abrir N4N en modo desarrollo
~/n4n-dev/n4n-mac.sh

# Abrir archivo específico
~/n4n-dev/n4n-mac.sh test-evolucion.md
```

**Ventaja**: Esto NO toca tu config normal de Neovim (que probablemente tengas en `~/.config/nvim`).

---

### ⚙️ FASE 2: Config Mínima de Neovim para Snippets Clínicos

#### 4. Crear init.lua mínimo

**Archivo**: `~/n4n-dev/config/nvim/init.lua`

```lua
-- init.lua mínimo para N4N-dev
-- Enfocado 100% en snippets clínicos, sin distracciones

-- ============================================================================
-- 1) OPCIONES BÁSICAS
-- ============================================================================

vim.opt.number = true              -- Números de línea
vim.opt.relativenumber = true      -- Números relativos (útil para movimientos)
vim.opt.shiftwidth = 2             -- Indentación de 2 espacios
vim.opt.tabstop = 2                -- Tab = 2 espacios
vim.opt.expandtab = true           -- Convertir tabs a espacios
vim.opt.spell = true               -- Corrección ortográfica activada
vim.opt.spelllang = { "es", "en" } -- Español e inglés

-- Diccionario médico personalizado (lo crearemos después)
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/medical.utf-8.add"

-- ============================================================================
-- 2) PLUGIN MANAGER: lazy.nvim
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- Si no existe, clonar lazy.nvim automáticamente
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

-- Plugins mínimos necesarios
require("lazy").setup({
  -- Engine de snippets (ligero y poderoso)
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp", -- Opcional, para regex avanzado
  },

  -- Snippets en formato VSCode (los que ya usamos)
  { "rafamadriz/friendly-snippets" },
})

-- ============================================================================
-- 3) CARGAR SNIPPETS CLÍNICOS
-- ============================================================================

-- Cargar snippets desde nuestra carpeta custom (formato VSCode JSON)
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})

-- Configurar LuaSnip para que Tab expanda snippets
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

-- ============================================================================
-- 4) ATAJOS ÚTILES
-- ============================================================================

-- Leader key = espacio
vim.g.mapleader = " "

-- Guardar rápido
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Guardar archivo" })

-- Salir rápido
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Salir" })

-- Buscar archivos (si instalaste ripgrep)
vim.keymap.set("n", "<leader>f", ":e ", { desc = "Abrir archivo" })

print("N4N-dev cargado correctamente ✓")
```

**Qué hace este init.lua**:
1. ✅ Configura Neovim básico (números, indentación, spelling)
2. ✅ Instala lazy.nvim automáticamente (primera vez)
3. ✅ Instala LuaSnip (engine de snippets)
4. ✅ Configura Tab/Shift+Tab para navegar snippets
5. ✅ Carga nuestros snippets custom desde `~/n4n-dev/config/nvim/snippets/`

---

#### 5. Crear carpeta de snippets clínicos

```bash
mkdir -p ~/n4n-dev/config/nvim/snippets
```

**Crear archivo de snippets base**:

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
```

**Crear archivo de snippets markdown** (lo llenaremos en FASE 3):

```bash
cat > ~/n4n-dev/config/nvim/snippets/markdown.json << 'EOF'
{
  "Test Snippet": {
    "prefix": "test",
    "body": [
      "# Test Snippet Funcionando",
      "Si ves esto, los snippets están cargados correctamente."
    ],
    "description": "Snippet de prueba"
  }
}
EOF
```

---

#### 6. Primera ejecución - Verificar que todo funciona

```bash
# 1. Abrir N4N-dev
~/n4n-dev/n4n-mac.sh

# 2. Esperar que lazy.nvim instale los plugins (primera vez, ~30 segundos)

# 3. Crear archivo de prueba
:e test.md

# 4. En modo INSERT, escribir:
test<Tab>

# Si se expande el snippet, ¡funciona!
```

**Si ves errores**:
- Verifica que brew install neovim funcionó: `nvim --version`
- Verifica que el init.lua no tiene errores de sintaxis
- Revisa `:Lazy` para ver estado de plugins

---

### 🩺 FASE 3: Diseñar Snippets Clínicos (Evolución 3000 + Comandos HCP/SNO)

**Objetivo**: Crear snippets que estructuren tu pensamiento clínico sin sacrificar velocidad.

#### 7. Snippet Base: Evolución por Sistemas + Examen Físico Segmentado

**Concepto**: Evolución estándar inspirada en el PDF de referencia, con:
- **Sistemas clave**: Neurológico, Hemodinámico, Respiratorio, Infeccioso, Dolor, Metabólico, Eliminación, Oncológico
- **Examen físico segmentado**: Cabeza, Cuello, Tórax, Abdomen, Dorsal, Genitales, Extremidades, LPP

**Edita** `~/n4n-dev/config/nvim/snippets/markdown.json` y reemplaza todo con:

```json
{
  "Evolución N4N 3000": {
    "prefix": "evo3000",
    "body": [
      "# Evolución de Enfermería - ${1:Fecha} ${2:Hora}",
      "",
      "## Recibo y contexto",
      "Recibo paciente ${3:conforme/no conforme}, se verifica monitorización, alarmas y accesos venosos. Se revisan indicaciones médicas, tratamiento vigente y pendientes relevantes del turno.",
      "",
      "## NEUROLÓGICO",
      "Paciente ${4:vigil/somnoliento}, ${5:tranquilo/agitado}, ${6:cooperador/no cooperador}. Responde a ${7:órdenes simples/dolor/no responde}. Orientado en ${8:tiempo/lugar/persona}. Pupilas ${9:isocóricas/aniso} con reflejo ${10:conservado/enlentecido/abolido}. Movilidad ${11:conservada/reducida} en extremidades.",
      "",
      "## HEMODINÁMICO",
      "TA ${12:120/80} mmHg, FC ${13:80} lpm, PAM ${14:>65} mmHg. Ritmo ${15:sinusal/FA/otro}. Perfusión periférica: piel ${16:tibia/fría}, llene capilar ${17:<3s/>3s}, pulsos periféricos ${18:presentes/débiles/ausentes}. Uso de DVA: ${19:no/sí - fármaco y dosis}.",
      "",
      "## RESPIRATORIO",
      "Ventila ${20:espontáneo/en VMNI/en VMI} con Fio2 ${21:21%} logrando SatO2 ${22:%} (meta ≥93%). FR ${23:16} rpm, uso de musculatura accesoria ${24:no/sí}. A la auscultación: MP ${25:conservados/disminuidos} con ${26:sin ruidos agregados/estertores/sibilancias/otros}.",
      "",
      "## INFECCIOSO",
      "Temperatura ${27:36.8}°C. Terapia antibiótica ${28:no/sí} según esquema ${29:detalle}. Cultivos ${30:pendientes/negativos/positivos para ...}. Aislamiento ${31:no requiere/contacto/gotitas/protector/respiratorio/mixto}. Próximo control IAAS ${32:fecha}.",
      "",
      "## DOLOR Y CONFORT",
      "Dolor referido ${33:0/10} en escala numérica. Manejo analgésico: ${34:paracetamol/opioides/otros} vía ${35:oral/EV/BIC} con respuesta ${36:buena/parcial/mala}. Se asegura confort (posición, higiene, apoyo emocional).",
      "",
      "## METABÓLICO / NUTRICIONAL",
      "Glicemia ${37:mg/dL} (meta ${38:rango}). Vía de alimentación: ${39:oral/SNG/GTT/NPT}. Tolerancia ${40:buena/regular/mala} (náuseas/vómitos ${41:no/sí}). Balance hídrico ${42:equilibrado/positivo/negativo}.",
      "",
      "## ELIMINACIÓN",
      "Diuresis ${43:ml/kg/h} (${44:normal/oliguria/poliuria/anuria}) vía ${45:espontánea/CUP/cistostomía}. Deposiciones ${46:presentes/ausentes} de características ${47:formadas/líquidas/hemáticas}. RHA ${48:presentes/hipoactivos/ausentes}.",
      "",
      "## ONCOLÓGICO / TERAPIAS ESPECIALES",
      "Paciente en día ${49:X} de ${50:quimioterapia/radioterapia/postoperatorio/otro}, esquema ${51:detalle}. Tolerancia ${52:buena/regular/mala}. Pendientes oncológicos: ${53:detallar estudios, ciclos, interconsultas}.",
      "",
      "## EXAMEN FÍSICO SEGMENTADO",
      "",
      "**Cabeza y cuello:** Normocéfalo, mucosa oral ${54:hidratada/seca}, sin lesiones evidentes. Dispositivos cefálicos y cervicales ${55:canalizados/sin signos de infección}.",
      "",
      "**Tórax:** Simétrico, sin deformidades. Piel ${56:intacta/con lesiones}. Dispositivos (CVC, drenajes) ${57:permeables/sin signos de infección}.",
      "",
      "**Abdomen:** ${58:blando/depresible/indoloro/sensible}, sin signos de irritación peritoneal. Presencia de drenajes/ostomías ${59:no/sí - describir funcionamiento y aspecto}.",
      "",
      "**Zona dorsal y sacra:** Piel ${60:intacta/con enrojecimiento/con úlceras}. Se realizan medidas de prevención de LPP (cambios de posición, superficies especiales).",
      "",
      "**Genitales y periné:** ${61:sanos/con lesiones}, catéter urinario ${62:no/sí - en buen estado/sospecha de infección}. Higiene perineal ${63:realizada/no corresponde}.",
      "",
      "**Extremidades:** Movilidad ${64:conservada/reducida}. Edemas ${65:no/sí - localización y grado}. Pulsos periféricos ${66:palpables/débiles}.",
      "",
      "## Plan de Cuidados / Pendientes",
      "- ${67:Revaluar dolor y ajuste analgésico.}",
      "- ${68:Control de laboratorio y cultivos.}",
      "- ${69:Educación al paciente/familia.}",
      "",
      "*Registrado por*: ${70:Nombre} | *Turno*: ${71:Mañana/Tarde/Noche}"
    ],
    "description": "Evolución estándar por sistemas + examen físico segmentado (N4N)"
  },

  "HCP - Hemodinamia Cambio Presión": {
    "prefix": "hcp",
    "body": [
      "**Hemo:** ${1:PAM} pasa de ${2:valor previo} a ${3:valor actual} mmHg en contexto de ${4:sedación/dolor/fiebre/hipovolemia/otro}.",
      "Se ${5:ajusta/mantiene/inicia/suspende} ${6:noradrenalina/dobutamina/otro} a ${7:dosis} con objetivo de PAM ≥ ${8:meta} mmHg.",
      "Se reevaluará en ${9:tiempo (min)} min y se informará a ${10:médico tratante/equipo} si persiste alteración."
    ],
    "description": "Comando hemodinámico HCP (Cambio de presión y ajuste)"
  },

  "SNO - Sistema Núcleo Objetivo": {
    "prefix": "sno",
    "body": [
      "**${1:Sistema}:** ${2:núcleo del problema/estado actual}. Objetivo: ${3:meta o criterio de éxito}."
    ],
    "description": "Plantilla corta sistema-núcleo-objetivo (SNO)"
  }
}
```

---

#### 8. Uso de los Snippets en la Práctica

##### Snippet: `evo3000`

**Cuándo usar**: Inicio de turno, primera evaluación completa del paciente.

```vim
# En Neovim, en un .md:
:e evolucion-lopez-maria.md
i                           # Modo INSERT
evo3000<Tab>                # Expande la plantilla
# Navega con Tab entre los 71 campos
# Completa solo lo que aplica, deja valores default en lo demás
Esc                         # Modo NORMAL
:w                          # Guardar
```

**Tiempo estimado**: 3-5 minutos para una evolución completa (vs 10-15 minutos escribiéndola desde cero).

---

##### Comando: `hcp`

**Cuándo usar**: Cambios hemodinámicos agudos que requieren ajuste de DVA.

**Ejemplo de contexto**:
- Estás en la sección HEMODINÁMICO
- PAM bajó de 75 a 58 mmHg
- Necesitas registrar el cambio y la intervención

```vim
# Dentro de la sección HEMODINÁMICO
o                           # Nueva línea debajo
hcp<Tab>                    # Expande el comando

# Completa los campos:
# ${1:PAM} → PAM
# ${2:valor previo} → 75
# ${3:valor actual} → 58
# ${4:contexto} → sedación profunda por agitación
# ${5:acción} → ajusta
# ${6:fármaco} → noradrenalina
# ${7:dosis} → 0.15 a 0.25 mcg/kg/min
# ${8:meta} → 65
# ${9:tiempo} → 15
# ${10:informar a} → Dr. García

# Resultado:
# **Hemo:** PAM pasa de 75 a 58 mmHg en contexto de sedación profunda por agitación.
# Se ajusta noradrenalina a 0.15 a 0.25 mcg/kg/min con objetivo de PAM ≥ 65 mmHg.
# Se reevaluará en 15 min y se informará a Dr. García si persiste alteración.
```

**Ventaja**: No inventas la redacción cada vez. El formato te obliga a pensar en:
1. **¿Qué cambió?** (valor previo → valor actual)
2. **¿Por qué?** (contexto)
3. **¿Qué hiciste?** (acción + fármaco + dosis)
4. **¿Cuál es la meta?** (objetivo claro)
5. **¿Cuándo reevalúas?** (seguimiento)

---

##### Comando: `sno`

**Cuándo usar**: Frases ultra rápidas para sistemas estables o cuando necesitas resumen conciso.

**Ejemplo 1 - Sistema Metabólico**:

```vim
o                           # Nueva línea
sno<Tab>

# Completa:
# ${1:Sistema} → Metabólico
# ${2:núcleo} → euglicémico con insulina ajustada según escala móvil
# ${3:objetivo} → mantener HGT 100-160 mg/dL

# Resultado:
# **Metabólico:** euglicémico con insulina ajustada según escala móvil. Objetivo: mantener HGT 100-160 mg/dL.
```

**Ejemplo 2 - Sistema Respiratorio**:

```vim
sno<Tab>

# ${1:Sistema} → Respiratorio
# ${2:núcleo} → vía aérea permeable, ventilando espontáneo
# ${3:objetivo} → mantener SatO2 ≥93% con FiO2 mínima

# Resultado:
# **Respiratorio:** vía aérea permeable, ventilando espontáneo. Objetivo: mantener SatO2 ≥93% con FiO2 mínima.
```

**Ventaja**: Formato S-N-O te obliga a pensar siempre en:
1. **Sistema** (qué estoy evaluando)
2. **Núcleo** (estado actual en 1 frase)
3. **Objetivo** (meta medible)

---

## 🔄 Flujo de Trabajo Completo en Mac (Hoy Mismo)

### Setup Inicial (Una Vez)

```bash
# 1. Instalar dependencias
brew install neovim ripgrep fd

# 2. Crear estructura de carpetas
mkdir -p ~/n4n-dev/{config,registros,data,state,cache}

# 3. Crear launcher
cat > ~/n4n-dev/n4n-mac.sh << 'EOF'
#!/usr/bin/env bash
export XDG_CONFIG_HOME="$HOME/n4n-dev/config"
export XDG_DATA_HOME="$HOME/n4n-dev/data"
export XDG_STATE_HOME="$HOME/n4n-dev/state"
export XDG_CACHE_HOME="$HOME/n4n-dev/cache"
export N4N_PROFILE="mac_dev"
mkdir -p "$XDG_CONFIG_HOME/nvim"
cd "$HOME/n4n-dev/registros"
nvim "$@"
EOF
chmod +x ~/n4n-dev/n4n-mac.sh

# 4. Crear init.lua
# (Copia el contenido completo del punto 4 de FASE 2)

# 5. Crear snippets
mkdir -p ~/n4n-dev/config/nvim/snippets
# (Copia package.json y markdown.json del punto 7 de FASE 3)
```

---

### Uso Diario (Desarrollo de Snippets)

```bash
# 1. Abrir N4N-dev
~/n4n-dev/n4n-mac.sh

# 2. Crear archivo de prueba
:e test-evolucion.md

# 3. Probar snippets
i                           # INSERT
evo3000<Tab>                # Evolución completa
# Navega con Tab/Shift+Tab entre campos
Esc

# 4. En medio de la evolución, probar comandos
/HEMODINÁMICO<Enter>        # Buscar sección
o                           # Nueva línea
hcp<Tab>                    # Comando hemodinámico
# Completa campos
Esc

# 5. Probar SNO en cualquier sistema
o
sno<Tab>
# Completa campos
Esc

# 6. Guardar y revisar
:w

# 7. Ver resultado
# Puedes abrir el archivo en cualquier editor Markdown
# o seguir editando en Neovim
```

---

### Validación de Snippets (2-3 Evoluciones de Prueba)

**Objetivo**: Hacer 2-3 evoluciones basadas en pacientes reales (SIN datos identificables) para detectar:
- ✅ Qué te sobra en `evo3000`
- ✅ Qué te falta
- ✅ Qué comandos cortos usarías todo el tiempo (además de hcp/sno)

#### Caso de Prueba 1: Paciente Hemodinámicamente Inestable

```bash
~/n4n-dev/n4n-mac.sh
:e caso1-shock-septico.md
i
evo3000<Tab>
# Completa como si fuera un paciente con shock séptico
# Usa hcp<Tab> cada vez que ajustes DVA
# Usa sno<Tab> para sistemas estables
```

**Observa**:
- ¿Los campos de evo3000 tienen sentido para shock séptico?
- ¿Falta algo crítico? (ej: lactato, balance hídrico detallado, ajustes frecuentes de DVA)
- ¿hcp es suficiente o necesitas más comandos hemodinámicos?

---

#### Caso de Prueba 2: Paciente Ventilado con Destete

```bash
:e caso2-vm-destete.md
i
evo3000<Tab>
# Enfócate en la sección RESPIRATORIO
# ¿Necesitas un comando tipo vmp (ventilación mecánica parámetros)?
```

**Observa**:
- ¿La sección RESPIRATORIO es suficiente para VM?
- ¿Necesitas campos para: modo ventilatorio, PEEP, PIP, VC, compliance, gasometría?
- ¿Un comando `vmp` sería útil?

---

#### Caso de Prueba 3: Paciente Oncológico Paliativo

```bash
:e caso3-onco-paliativo.md
i
evo3000<Tab>
# Completa sección ONCOLÓGICO
# Usa sno<Tab> para dolor, confort, soporte familiar
```

**Observa**:
- ¿La sección ONCOLÓGICO es suficiente o muy genérica?
- ¿Necesitas campos específicos para: escalas de dolor complejas, sedación paliativa, comunicación con familia?

---

## 📊 Criterios de Éxito (Antes de Seguir Ampliando)

### ✅ Checklist de Validación

Marca cuando puedas hacer esto sin consultar la guía:

- [ ] Abrir N4N-dev sin tocar tu config personal de Neovim
- [ ] Crear un archivo .md y usar `evo3000<Tab>` exitosamente
- [ ] Navegar entre campos con Tab/Shift+Tab fluidamente
- [ ] Usar `hcp<Tab>` para registrar cambios hemodinámicos
- [ ] Usar `sno<Tab>` para resúmenes rápidos por sistema
- [ ] Completar 2-3 evoluciones de prueba basadas en casos reales
- [ ] Identificar qué te sobra en evo3000
- [ ] Identificar qué te falta en evo3000
- [ ] Listar 3-5 comandos cortos que usarías todo el tiempo

---

### 📝 Feedback Esperado (Para Siguiente Iteración)

Después de las 2-3 evoluciones de prueba, documenta:

#### 1. ¿Qué te sobra en evo3000?

Ejemplo:
- "La sección ONCOLÓGICO es muy larga, 80% de mis pacientes no son onco"
- "El examen físico segmentado tiene demasiados campos, solo uso 4-5"

#### 2. ¿Qué te falta en evo3000?

Ejemplo:
- "Necesito campos para: catéteres centrales (tipo, días de uso, signos de infección)"
- "Falta una sección de DISPOSITIVOS (VM, DVA, drenajes, bomba de infusión)"
- "La sección HEMODINÁMICO necesita más detalle para inestabilidad severa"

#### 3. ¿Qué comandos cortos usarías todo el tiempo?

Ejemplo:
- `vmp` (ventilación mecánica parámetros): Modo, FiO2, PEEP, VC, FR
- `dve` (derivación ventricular externa): Nivel, débito, características LCR
- `dpl` (drenaje pleural): Tipo, débito, características, burbujeo
- `inf` (infusiones): Fármaco, dosis, bomba, vía
- `gli` (glicemia): Valor, insulina administrada según escala
- `bal` (balance): Ingresos vs egresos últimas X horas

---

## 🚀 Próximos Pasos (Después de Validación)

Una vez que tengas el feedback de las 2-3 evoluciones de prueba:

### Nivel 2: Refinar evo3000

Crear **variantes** del snippet base según contexto:

1. **`evo-estable`**: Versión reducida para pacientes estables (menos campos)
2. **`evo-inestable`**: Versión expandida para shock/inestabilidad hemodinámica
3. **`evo-septico`**: Campos específicos para sepsis (lactato, PCT, cultivos, antibióticos)
4. **`evo-vm`**: Enfocado en pacientes ventilados (parámetros detallados)
5. **`evo-paliativo`**: Enfocado en confort, dolor, sedación, soporte familiar

### Nivel 3: Lenguaje de Comandos N4N

Diseñar un "lenguaje" de comandos cortos (3 letras) para operaciones frecuentes:

```
Categoría Hemodinámica:
- hcp: Hemodinamia Cambio Presión (ya existe)
- hcf: Hemodinamia Cambio FC
- hdv: Hemodinamia Dosis DVA

Categoría Ventilación:
- vmp: Ventilación Mecánica Parámetros
- vmg: Ventilación Mecánica Gasometría
- vmd: Ventilación Mecánica Destete

Categoría Dispositivos:
- dve: Derivación Ventricular Externa
- dpl: Drenaje Pleural
- dpe: Drenaje Peritoneal
- cvc: Catéter Venoso Central

Categoría Infusiones:
- inf: Infusión (genérica)
- sed: Sedación
- ana: Analgesia
- ant: Antibióticos

Categoría Metabólico:
- gli: Glicemia + Insulina
- bal: Balance Hídrico
- ele: Electrolitos
```

Cada comando se expande en un snippet estructurado de 3-5 líneas que captura:
- **Estado actual**
- **Cambio/intervención**
- **Objetivo/meta**
- **Seguimiento**

---

## 🎯 Requisito Crítico: NO Seguir Ampliando Aún

**Primero**:
1. ✅ Monta FASE 1-3 exactamente como está documentado
2. ✅ Haz 2-3 evoluciones de prueba
3. ✅ Detecta qué sobra, qué falta, qué comandos necesitas

**Después**:
- Refinamos `evo3000` con el feedback real
- Diseñamos el lenguaje de comandos específico para tu forma de pensar
- Creamos variantes de evolución por tipo de paciente

**Por qué este orden**:
- Evita sobre-ingeniería prematura
- Los snippets que diseñes después estarán basados en uso real
- No perdemos tiempo creando comandos que nunca usarás

---

## 📁 Estructura Final del Entorno

```
~/n4n-dev/
├── n4n-mac.sh                       # Launcher principal
├── config/
│   └── nvim/
│       ├── init.lua                 # Configuración mínima
│       ├── snippets/
│       │   ├── package.json         # Metadata de snippets
│       │   └── markdown.json        # Snippets clínicos
│       └── spell/
│           └── medical.utf-8.add    # Diccionario médico (futuro)
├── registros/                       # Carpeta de trabajo
│   ├── test-evolucion.md
│   ├── caso1-shock-septico.md
│   ├── caso2-vm-destete.md
│   └── caso3-onco-paliativo.md
├── data/                            # Plugins de Neovim
│   └── lazy/
├── state/                           # Estado de sesiones
└── cache/                           # Cache de Neovim
```

---

## 🔍 Troubleshooting

### Problema: "No se instalan los plugins"

**Solución**:
```bash
# Abrir Neovim
~/n4n-dev/n4n-mac.sh

# En Neovim:
:Lazy sync

# Espera 30-60 segundos
# Cierra y vuelve a abrir
```

---

### Problema: "Los snippets no se expanden"

**Verificación**:
```vim
# En Neovim:
:lua print(vim.fn.stdpath("config"))
# Debe mostrar: /Users/TuUsuario/n4n-dev/config/nvim

# Verificar que existen los snippets:
:lua print(vim.fn.glob(vim.fn.stdpath("config") .. "/snippets/*.json"))
# Debe mostrar: /Users/TuUsuario/n4n-dev/config/nvim/snippets/markdown.json
```

**Si no se expanden**:
1. Verifica que estás en un archivo `.md`
2. Estás en modo INSERT (`i`)
3. Escribiste el prefijo completo (`evo3000`) y luego Tab
4. LuaSnip está instalado: `:Lazy` y busca "LuaSnip"

---

### Problema: "Tab no hace nada"

**Solución**: Verifica que el mapeo de Tab está configurado en `init.lua`:

```lua
vim.keymap.set({"i", "s"}, "<Tab>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    return "<Tab>"
  end
end, {silent = true, expr = true})
```

---

## 📚 Recursos Adicionales

### Documentación de LuaSnip
- [LuaSnip GitHub](https://github.com/L3MON4D3/LuaSnip)
- [VSCode Snippets Format](https://code.visualstudio.com/docs/editor/userdefinedsnippets)

### Atajos de Neovim Útiles
```vim
# Navegación en snippets
Tab         → Siguiente campo
Shift+Tab   → Campo anterior

# Edición rápida
i           → INSERT antes del cursor
a           → INSERT después del cursor
o           → Nueva línea debajo + INSERT

# Guardar/Salir
:w          → Guardar
:q          → Salir
:wq         → Guardar y salir

# Búsqueda
/texto      → Buscar "texto"
n           → Siguiente coincidencia
```

---

## ✅ Resumen Ejecutivo

**En 30 minutos puedes tener**:
- ✅ Neovim funcionando aislado en Mac
- ✅ LuaSnip configurado con Tab/Shift+Tab
- ✅ 3 snippets clínicos: `evo3000`, `hcp`, `sno`
- ✅ Listo para probar en 2-3 evoluciones reales

**Después de validar**:
- ✅ Refinar evo3000 según feedback
- ✅ Diseñar lenguaje de comandos específico
- ✅ Crear variantes de evolución por tipo de paciente

**Lo que NO hagas aún**:
- ❌ Crear comandos sin haberlos probado
- ❌ Sobre-optimizar prematuramente
- ❌ Diseñar snippets complejos sin feedback real

---

**El laboratorio está listo. Ahora toca validar en la práctica.** 🧪🩺

---

*Última actualización: 2025-11-24*
*Estado: Plan completo, listo para ejecutar*
