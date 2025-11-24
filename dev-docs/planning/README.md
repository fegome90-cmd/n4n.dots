# 🧪 Planificación y Desarrollo N4N

Esta carpeta contiene la planificación completa para el desarrollo y validación de snippets clínicos antes de implementarlos en el entorno de producción hospitalario.

---

## 📖 Documentos Disponibles

### [`alternatives-existing-neovim.md`](./alternatives-existing-neovim.md) ⚡ LEER PRIMERO
**¿Ya tienes Neovim configurado? Elige tu camino**

**Para quién**:
- ✅ Si ya tienes GentlemanNvim (o cualquier config de Neovim) funcionando
- ✅ Si quieres empezar rápido sin reinstalar todo
- ✅ Si prefieres simplicidad sobre aislamiento total

**Tres alternativas**:
- **A. Agregar a config existente** (5 min) - Recomendado para empezar YA
- **B. Config paralela con NVIM_APPNAME** (30-45 min) - Aislamiento completo
- **C. Entorno aislado total** (2-3 horas) - Máximo control

**Cuándo leer**: Antes de decidir si seguir el plan completo o usar tu config actual.

---

### [`telescope-architecture.md`](./telescope-architecture.md) 🔭 NUEVA DIRECCIÓN
**Arquitectura Telescope + Snippets de Normalidad**

**Filosofía**: Separar normalidad (snippets cortos) de patología (menús Telescope)

**Contenido**:
- **Parte A**: Integración de Telescope como menú por sistema
  - Setup de Telescope vía lazy.nvim
  - Módulo `telescope_systems.lua` con base de datos de plantillas
  - Keymaps por sistema (`<leader>hh`, `<leader>nn`, etc.)
- **Parte B**: 8 snippets de normalidad (3 letras cada uno)
  - `nbo` - Neuro basal OK
  - `hst` - Hemo estable
  - `rst` - Resp estable
  - `ist` - Inf estable
  - `mst` - Meta estable
  - `elm` - Eliminación OK
  - `dst` - Dolor estable
  - `ost` - Onco estable
- Flujo de uso real con casos de ejemplo
- Roadmap de expansión (Fases 1-5)
- Checklist de implementación y validación

**Ventajas**:
- ✅ Memorización mínima (8 códigos vs. 200+)
- ✅ Escalable (agregar plantillas sin nuevos códigos)
- ✅ Descubrible (menú muestra opciones)
- ✅ Velocidad mantenida para normalidad

**Cuándo leer**: Después de elegir tu alternativa de setup. Este es el diseño actual de snippets y menús N4N.

---

### [`mac-dev-environment.md`](./mac-dev-environment.md) - Plan General (3 Fases) 📖 CONTEXTO
**Roadmap completo del entorno de desarrollo en macOS (desde cero)**

**Nota**: Este documento contiene el plan original con `evo3000` y comandos de 3 letras. La nueva dirección está en `telescope-architecture.md`.

- **FASE 1**: Setup de Neovim aislado
- **FASE 2**: Configuración mínima con LuaSnip
- **FASE 3**: Diseño de snippets clínicos (evo3000, hcp, sno)

**Incluye**:
- Flujo de trabajo completo de desarrollo
- Validación con casos de prueba
- Criterios de éxito
- Roadmap de próximos pasos

**Cuándo leer**: Para entender el plan completo y la filosofía del entorno.

---

### [`mac-implementation-tasklist.md`](./mac-implementation-tasklist.md) ⭐ EMPEZAR AQUÍ
**Tasklist atómico: 41 tareas desde cero hasta primera evolución**

**Organización**:
- **A. Preparar herramientas** (4 tareas)
- **B. Estructura base** (6 tareas)
- **C. Script lanzador** (7 tareas)
- **D. Config Neovim** (13 tareas)
- **E. Snippets clínicos** (5 tareas)
- **F. Primer uso real** (5 tareas)
- **G. Verificación final** (1 tarea)

**Cada tarea**:
- ✅ Hace UNA sola cosa
- ✅ Puede ser un commit independiente
- ✅ Tiene comando exacto para ejecutar
- ✅ Tiene verificación de éxito
- ✅ Incluye mensaje de commit sugerido

**Cuándo usar**: Cuando vayas a implementar el entorno paso a paso.

---

## 🎯 Flujo de Uso Recomendado

### 0. Decisión Inicial (5 minutos) ⚡ NUEVO

```bash
# ¿Ya tienes Neovim configurado en tu Mac?
cat dev-docs/planning/alternatives-existing-neovim.md
```

**Decides**:
- ¿Tienes GentlemanNvim o alguna config de Neovim ya funcionando?
- ¿Prefieres simplicidad (5 min) o aislamiento total (2-3 horas)?
- ¿Te importa mezclar snippets clínicos con tu config personal?

**Resultado**: Eliges Alternativa A, B o C

---

### 1. Primera Lectura (30 minutos) - Solo si elegiste Alternativa C

```bash
# Lee el plan general para entender el contexto
cat dev-docs/planning/mac-dev-environment.md
```

**Entiendes**:
- Qué es el entorno mac-dev
- Por qué está aislado de tu config personal
- Qué snippets vas a crear (evo3000, hcp, sno)
- Cómo validar antes de ampliar

**Nota**: Si elegiste Alternativa A o B, puedes saltarte este documento y seguir las instrucciones del alternatives-existing-neovim.md

---

### 2. Implementación - Depende de tu alternativa

#### Si elegiste Alternativa A (5 minutos)
```bash
# Sigue los pasos en alternatives-existing-neovim.md
# Sección "Setup de Alternativa A"
mkdir -p ~/.config/nvim/snippets
# Agregar snippets a tu config existente
```

#### Si elegiste Alternativa B (30-45 minutos)
```bash
# Sigue los pasos en alternatives-existing-neovim.md
# Sección "Setup de Alternativa B"
mkdir -p ~/.config/nvim-n4n
# Crear config paralela con NVIM_APPNAME
```

#### Si elegiste Alternativa C (2-3 horas)
```bash
# Abre el tasklist atómico
cat dev-docs/planning/mac-implementation-tasklist.md

# Ve tarea por tarea, ejecutando comandos
# Marca cada una como completada
# Haz commit después de cada tarea (o agrupa si prefieres)
```

**Logras** (en cualquier alternativa):
- Entorno N4N funcional
- Neovim con snippets clínicos
- Primera evolución completa escrita

---

### 3. Validación (1-2 días)

Haz 2-3 evoluciones de prueba con casos reales (sin datos identificables):

**Caso 1**: Paciente hemodinámicamente inestable (shock séptico)
**Caso 2**: Paciente ventilado con destete
**Caso 3**: Paciente oncológico paliativo

**Documenta feedback**:
- ¿Qué sobra en evo3000?
- ¿Qué falta?
- ¿Qué comandos cortos necesitas?

---

### 4. Refinamiento (Siguiente Iteración)

Basado en el feedback real:
- Refinar evo3000 con variantes por tipo de paciente
- Diseñar lenguaje de comandos específico (vmp, dve, dpl, etc.)
- Crear snippets adicionales según necesidad real

---

## 📊 Progreso

### Hitos del Proyecto

- [ ] **Hito 1**: Entorno listo (T01-T17)
  - [ ] Herramientas instaladas
  - [ ] Estructura de carpetas creada
  - [ ] Script launcher funcionando

- [ ] **Hito 2**: Neovim configurado (T18-T30)
  - [ ] init.lua con opciones básicas
  - [ ] lazy.nvim instalado
  - [ ] LuaSnip funcionando

- [ ] **Hito 3**: Snippets instalados (T31-T35)
  - [ ] Carpeta snippets creada
  - [ ] evo3000 disponible
  - [ ] hcp y sno disponibles

- [ ] **Hito 4**: Primera evolución (T36-T41)
  - [ ] Archivo de prueba creado
  - [ ] Evolución completa con evo3000
  - [ ] Comandos hcp y sno usados
  - [ ] Validación de output

---

## 🔑 Conceptos Clave

### Mac = Laboratorio 🧪
- Desarrollo iterativo de snippets
- Prueba con casos reales
- Refinamiento basado en feedback
- Sin riesgo en entorno hospitalario

### Windows Portátil = Producción 🏥
- Snippets validados
- Uso en turnos reales
- Performance optimizado
- Sin dependencias externas

### Snippets Estructurados 🩺
Cada snippet te obliga a pensar en:
1. **Contexto** (qué está pasando)
2. **Cambio** (qué modificaste)
3. **Objetivo** (meta clara)
4. **Seguimiento** (cuándo reevalúas)

### Lenguaje de Comandos 💬
Comandos de 3 letras:
- **hcp**: Hemodinamia/Cambio/Presión
- **sno**: Sistema/Núcleo/Objetivo
- **vmp**: Ventilación Mecánica Parámetros (futuro)
- **dve**: Derivación Ventricular Externa (futuro)

---

## 🛠️ Herramientas Necesarias

### Software
```bash
# Verificar que están instalados:
brew --version      # Homebrew (gestor de paquetes)
git --version       # Git (control de versiones)
nvim --version      # Neovim (editor)
rg --version        # ripgrep (búsqueda)
fd --version        # fd (navegación)
```

### Espacio en Disco
- ~500 MB para entorno completo
- ~50 MB para plugins
- ~10 MB para registros de prueba

### Tiempo
- **Setup inicial**: 2-3 horas (tareas T01-T41)
- **Primera evolución**: 15-30 minutos
- **Validación completa**: 1-2 días (2-3 casos)

---

## 📚 Recursos Adicionales

### Documentación de Neovim
- [Neovim Docs](https://neovim.io/doc/)
- [LazyVim Docs](https://www.lazyvim.org/)
- [LuaSnip Docs](https://github.com/L3MON4D3/LuaSnip)

### Formato de Snippets
- [VSCode Snippets Guide](https://code.visualstudio.com/docs/editor/userdefinedsnippets)

### Markdown
- [Markdown Guide](https://www.markdownguide.org/)

---

## 🆘 Soporte

### Troubleshooting
Cada documento tiene su propia sección de troubleshooting:
- `mac-dev-environment.md` → Sección "Troubleshooting"
- `mac-implementation-tasklist.md` → Sección "Troubleshooting por Tarea"

### Preguntas Frecuentes

**P: ¿Puedo usar este entorno en Linux?**
R: Sí, pero necesitas adaptar los comandos (usar `apt` en lugar de `brew`, rutas diferentes).

**P: ¿Interfiere con mi Neovim actual?**
R: No, usa variables XDG para aislar completamente la configuración.

**P: ¿Puedo usar snippets en otros editores?**
R: Sí, el formato JSON de VSCode es compatible con VS Code, Sublime, etc.

**P: ¿Qué pasa si rompo algo?**
R: Simplemente elimina `~/n4n-dev` y empieza de nuevo. No afecta nada más.

---

## ✅ Checklist de Preparación

Antes de empezar, asegúrate de tener:

- [ ] macOS (Big Sur o superior)
- [ ] Homebrew instalado
- [ ] 2-3 horas disponibles
- [ ] Casos clínicos en mente para validar (sin datos reales de pacientes)
- [ ] Ganas de aprender Neovim básico

---

## 🎓 Filosofía de Desarrollo

### Principios

1. **Validar antes de ampliar**
   - No crear snippets sin probarlos
   - No diseñar comandos sin usarlos
   - Feedback real > suposiciones

2. **Atomicidad**
   - Una tarea = una acción
   - Commits pequeños y claros
   - Fácil de revertir si algo falla

3. **Pensamiento estructurado**
   - Los snippets no solo aceleran el tipeo
   - Fuerzan estructura mental clara
   - Sistema → Estado → Meta

4. **Iteración basada en uso**
   - Primera versión = MVP
   - Refinamiento según práctica real
   - Evolución continua

---

*Última actualización: 2025-11-24*
*Mantenido por: @fegome90-cmd*
