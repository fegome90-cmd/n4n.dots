# 📦 Plantillas de Configuración N4N

Esta carpeta contiene las plantillas de configuración listas para usar en tu entorno N4N.

---

## 🎯 ¿Qué hay aquí?

Sistema completo de **snippets de normalidad basados en PDF 3000** + **menús Telescope por sistema**.

---

## 📁 Archivos

| Archivo | Descripción | Líneas |
|---------|-------------|--------|
| **`markdown.json`** | 11 snippets completos para evoluciones (evo, nbo, hst, rst, ist, mst, elm, dst, ost, efn, pen) | ~180 |
| **`telescope_systems.lua`** | Módulo Telescope con menús por sistema (hemo, neuro, resp, inf, meta, elim, dolor, onco, ef, plan) | ~150 |
| **`n4n-keymaps.lua`** | Keymaps para todos los menús (`<leader>hh`, `<leader>nn`, etc.) | ~80 |
| **`IMPLEMENTATION-GUIDE.md`** | Guía completa de instalación paso a paso | ~600 |

---

## 🚀 Instalación Rápida

```bash
# 1. Lee la guía completa
cat dev-docs/config-templates/IMPLEMENTATION-GUIDE.md

# 2. Copia snippets
cp dev-docs/config-templates/markdown.json \
   ~/n4n-dev/config/nvim/snippets/

# 3. Copia módulo Telescope
mkdir -p ~/n4n-dev/config/nvim/lua/n4n
cp dev-docs/config-templates/telescope_systems.lua \
   ~/n4n-dev/config/nvim/lua/n4n/

# 4. Agrega keymaps a tu init.lua
# (Ver IMPLEMENTATION-GUIDE.md para detalles)

# 5. Verifica
nvim test.md
# Escribe: nbo<Tab> → debe expandir snippet neuro normal
```

---

## 📖 Documentación Completa

**Lee primero**: [`IMPLEMENTATION-GUIDE.md`](./IMPLEMENTATION-GUIDE.md)

Contiene:
- ✅ Prerequisitos
- ✅ Instalación paso a paso (5 pasos)
- ✅ Verificación de cada componente
- ✅ Primer uso con ejemplo completo
- ✅ Troubleshooting de problemas comunes
- ✅ Resumen de comandos y próximos pasos

---

## 🎓 Filosofía del Diseño

### Separación Normalidad/Patología

**Normalidad** → Snippet directo (3 letras + Tab)
- `nbo<Tab>` → neuro basal OK
- `hst<Tab>` → hemo estable
- `rst<Tab>` → resp estable
- etc.

**Patología** → Menú Telescope (descubrible)
- `<leader>hh` → menú hemodinamia
- `<leader>nn` → menú neuro
- etc.

### Beneficios

- ✅ Memorización mínima: 8 códigos base
- ✅ Velocidad: snippets directos para lo común
- ✅ Descubribilidad: menú para lo infrecuente
- ✅ Escalabilidad: agregar plantillas sin nuevos códigos

---

## 🔍 Vista Previa de Snippets

### evo - Estructura completa

```markdown
# EVOLUCIÓN STANDARD - N4N

Recibo paciente conforme, se programan alarmas...

## NEUROLÓGICO

## HEMODINÁMICO

## RESPIRATORIO
...
```

### nbo - Neuro basal normal

```markdown
**Neuro:** Paciente vigil, tranquilo, cooperador, responde a estímulos simples, orientado en tiempo y espacio.
Apertura ocular normal, pupilas isocóricas e isoreactivas. Movilidad conservada en las cuatro extremidades, sin déficit motor grosero aparente.
```

### hst - Hemo estable

```markdown
**Hemodinamia:** Hemodinámicamente estable, PAM sobre 65 mmHg sin uso de DVA.
Ritmo sinusal y frecuencia cardiaca dentro de rango (ej. 70-90 lpm).
Al tacto se encuentra tibio y seco, bien perfundido, llene capilar <3 segundos, pulsos periféricos presentes y simétricos.
Piel y mucosas hidratadas y rosadas.
```

### efn - Examen físico normal

```markdown
**Cabeza y cuello:** Normocéfalo, apertura ocular espontánea. Mucosa oral hidratada, sin lesiones, dentadura completa.

**Tórax:** Tórax simétrico, murmullo pulmonar SRA, sin lesiones en piel visibles.

**Abdomen:** Abdomen blando, depresible, indoloro, sin signos de irritación peritoneal ni lesiones en piel.
...
```

---

## 🛠️ Configuración del Entorno

### Prerequisitos

- Neovim ≥ 0.9.0
- LuaSnip instalado
- Telescope instalado (o se instala siguiendo guía)
- lazy.nvim como gestor de plugins

### Estructura Esperada

```
~/n4n-dev/config/nvim/
├── init.lua                    # Configuración principal
├── snippets/
│   └── markdown.json          # ← Copiar aquí
└── lua/
    └── n4n/
        ├── telescope_systems.lua  # ← Copiar aquí
        └── keymaps.lua            # ← Copiar aquí (opcional)
```

---

## 📊 Flujo de Uso

### Evolución "Todo Normal" (2-3 minutos)

```vim
# 1. Abrir archivo
~/n4n-dev/n4n-mac.sh UPC-2025-11-24-Noche.md

# 2. Estructura
i
evo<Tab>

# 3. Sistemas (elegir método)
# Método A: Snippet directo
nbo<Tab>      # Neuro
hst<Tab>      # Hemo
rst<Tab>      # Resp
...

# Método B: Menú Telescope
<Esc>
<leader>nn    # Menú neuro → Enter → nbo → Tab
<leader>hh    # Menú hemo → Enter → hst → Tab
...

# 4. Examen físico
<leader>xf    # Menú EF → Enter → efn → Tab

# 5. Plan
<leader>xp    # Menú plan → Enter → pen → Tab

# 6. Guardar
:wq
```

---

## 🔗 Recursos Adicionales

- **Arquitectura Telescope**: [`planning/telescope-architecture.md`](../planning/telescope-architecture.md)
- **Alternativas de Setup**: [`planning/alternatives-existing-neovim.md`](../planning/alternatives-existing-neovim.md)
- **Workflow UPC**: [`workflows/upc-daily-workflow.md`](../workflows/upc-daily-workflow.md)

---

## 🆘 Ayuda

**Si tienes problemas**:
1. Lee [`IMPLEMENTATION-GUIDE.md`](./IMPLEMENTATION-GUIDE.md) sección Troubleshooting
2. Verifica prerequisitos
3. Revisa paths de archivos
4. Confirma que LuaSnip y Telescope están instalados

**Problemas comunes**:
- Snippets no expanden → Verifica path en `init.lua`
- Telescope no se abre → Instala con `:Lazy sync`
- Tab inserta tabulación → Configura keymap de Tab
- Leader no funciona → Configura `vim.g.mapleader = " "`

---

**Versión**: PDF 3000 normalidad + Telescope v1.0
**Última actualización**: 2025-11-24
**Mantenido por**: @fegome90-cmd
