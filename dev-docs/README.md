# 📚 Documentación para Desarrolladores (dev-docs)

Esta carpeta contiene documentación técnica y herramientas para el desarrollo y mantenimiento del proyecto **NursingNvim (N4N)**.

---

## 📖 Documentos Disponibles

### 🚀 Instalación y Configuración

#### [`nvim-installation-guide.md`](./nvim-installation-guide.md)
**Guía completa de instalación de Neovim para registros de enfermería**

- ✅ Instalación portátil para Windows (sin admin)
- ✅ Instalación optimizada para macOS
- ✅ Links directos de descarga de todas las dependencias
- ✅ Configuración de plugins para redacción médica
- ✅ Snippets personalizados para enfermería
- ✅ Flujo de trabajo recomendado
- ✅ Solución de problemas

**Cuándo usar**: Cuando necesites instalar este entorno desde cero en una nueva máquina.

---

### 🏥 Flujos de Trabajo Clínicos

#### [`workflows/upc-daily-workflow.md`](./workflows/upc-daily-workflow.md) ⭐ ESENCIAL
**Flujo de trabajo completo para UPC (Unidad de Pacientes Críticos)**

- ✅ Setup inicial de carpetas y estructura
- ✅ Flujo paso a paso desde inicio hasta cierre de turno
- ✅ Uso de snippets en contexto real
- ✅ Entradas rápidas durante el turno (signos vitales, medicamentos, eventos)
- ✅ Manejo de incidentes y eventos adversos
- ✅ Búsqueda de información durante el turno
- ✅ Procedimientos de cierre y relevo
- ✅ Ejemplo completo de archivo de turno
- ✅ Troubleshooting y buenas prácticas
- ✅ Checklist de dominio del flujo

**Cuándo usar**: Antes de tu primer turno con N4N y como referencia continua. Este es el documento que convierte la herramienta en un flujo de trabajo real.

---

### 🧪 Planificación y Desarrollo

#### [`planning/alternatives-existing-neovim.md`](./planning/alternatives-existing-neovim.md) ⚡ LEER PRIMERO
**¿Ya tienes Neovim configurado? Elige tu camino**

- ✅ Análisis de tres alternativas con diferentes niveles de complejidad
- ✅ **Alternativa A**: Agregar snippets a config existente (5 min) - Recomendado para empezar YA
- ✅ **Alternativa B**: Config paralela con NVIM_APPNAME (30-45 min) - Aislamiento completo
- ✅ **Alternativa C**: Entorno aislado total (2-3 horas) - Máximo control
- ✅ Comparación detallada: tiempo, complejidad, aislamiento, espacio en disco
- ✅ Setup paso a paso para cada alternativa
- ✅ Launchers y scripts de acceso rápido
- ✅ Recomendaciones por caso de uso

**Para quién**: Si ya tienes GentlemanNvim (o cualquier config de Neovim) funcionando en tu Mac.

**Cuándo usar**: ANTES de decidir si seguir el plan completo desde cero o aprovechar tu config actual. Este documento te ahorra tiempo si ya tienes Neovim.

---

#### [`planning/mac-implementation-tasklist.md`](./planning/mac-implementation-tasklist.md) ⭐ SETUP DESDE CERO
**Tasklist atómico: 41 tareas desde cero hasta primera evolución**

- ✅ **A. Preparar herramientas** (4 tareas): Homebrew, Neovim, ripgrep, fd
- ✅ **B. Estructura base** (6 tareas): Carpetas config, data, state, cache, registros
- ✅ **C. Script lanzador** (7 tareas): n4n-mac.sh con variables XDG aisladas
- ✅ **D. Config Neovim** (13 tareas): init.lua, lazy.nvim, LuaSnip, Tab navigation
- ✅ **E. Snippets clínicos** (5 tareas): evo3000, hcp, sno en markdown.json
- ✅ **F. Primer uso real** (5 tareas): Archivo de prueba con evolución completa
- ✅ **G. Verificación final** (1 tarea): Validación de output

**Cada tarea**: Una acción + verificación + commit sugerido. Listo para ejecutar.

**Cuándo usar**: Cuando vayas a implementar el entorno paso a paso. Sigue cada tarea en orden.

---

#### [`planning/mac-dev-environment.md`](./planning/mac-dev-environment.md) 📖 CONTEXTO
**Plan completo para montar laboratorio de desarrollo de snippets clínicos en macOS**

- ✅ FASE 1: Setup de Neovim aislado (no interfiere con tu config personal)
- ✅ FASE 2: Configuración mínima con LuaSnip para snippets VSCode-style
- ✅ FASE 3: Diseño de snippets clínicos avanzados
  - **evo3000**: Evolución por sistemas + examen físico segmentado
  - **hcp**: Comando hemodinámico (Hemodinamia/Cambio/Presión)
  - **sno**: Comando sistema/núcleo/objetivo para frases rápidas
- ✅ Flujo de trabajo completo de desarrollo
- ✅ Validación con casos de prueba (2-3 evoluciones reales)
- ✅ Criterios de éxito antes de ampliar
- ✅ Roadmap de próximos pasos (variantes de evolución, lenguaje de comandos)
- ✅ Troubleshooting del entorno de desarrollo

**Cuándo usar**: Para entender el plan completo y la filosofía antes de implementar. Lee esto primero, luego usa el tasklist.

**Filosofía**: Diseñar snippets que estructuren el pensamiento clínico sin sacrificar velocidad. Comandos cortos (3 letras) que se expanden en registro estructurado. Mac = laboratorio, Windows = producción.

---

### 🔓 Separación del Repositorio Original

#### [`QUICK-START-SEPARATION.md`](./QUICK-START-SEPARATION.md) ⭐ EMPIEZA AQUÍ
**Inicio rápido para separar tu fork del repo original**

- ✅ 3 métodos diferentes (automatizado, manual, via GitHub Support)
- ✅ Comandos listos para copiar y pegar
- ✅ Checklist de verificación
- ✅ Solución de problemas comunes

**Cuándo usar**: Si quieres una guía rápida y directa para separar el proyecto.

---

#### [`separate-fork-guide.md`](./separate-fork-guide.md)
**Guía exhaustiva para separar fork del repositorio original**

- ✅ Explicación detallada del proceso
- ✅ Verificaciones paso a paso
- ✅ Medidas de seguridad adicionales
- ✅ Recomendaciones de branding
- ✅ Actualización de licencia
- ✅ Guía completa con ejemplos

**Cuándo usar**: Si quieres entender a fondo cómo funciona la separación o necesitas más contexto.

---

### 🛡️ Seguridad de Push

#### [`PUSH-SAFETY-GUIDE.md`](./PUSH-SAFETY-GUIDE.md) ⭐ IMPORTANTE
**Guía de seguridad para asegurar que todos los push van a TU repositorio**

- ✅ Verificación de configuración actual
- ✅ Detección de relación de fork en GitHub
- ✅ Workflows de push seguro a main
- ✅ Pre-push hooks y git aliases
- ✅ Scripts de verificación visual
- ✅ Medidas de seguridad adicionales
- ✅ Quick reference card
- ✅ Señales de alerta y procedimientos de emergencia

**Cuándo usar**: Siempre, antes de hacer push importante. Esencial para tranquilidad mental.

---

### 🤖 Scripts de Automatización

#### [`migrate-to-new-repo.sh`](./migrate-to-new-repo.sh)
**Script automatizado para Linux/macOS**

```bash
# Uso
./dev-docs/migrate-to-new-repo.sh https://github.com/TU-USUARIO/NUEVO-REPO.git
```

**Características**:
- ✅ Validación de precondiciones
- ✅ Backup automático de configuración
- ✅ Limpieza de remotes antiguos
- ✅ Push automático al nuevo repo
- ✅ Verificación final
- ✅ Colores e indicadores de progreso

**Cuándo usar**: Para migrar rápidamente en sistemas Unix.

---

#### [`migrate-to-new-repo.ps1`](./migrate-to-new-repo.ps1)
**Script automatizado para Windows (PowerShell)**

```powershell
# Uso
.\dev-docs\migrate-to-new-repo.ps1 -NewRepoUrl "https://github.com/TU-USUARIO/NUEVO-REPO.git"
```

**Características**:
- ✅ Todas las funciones del script de Linux
- ✅ Sintaxis nativa de PowerShell
- ✅ Manejo de errores robusto
- ✅ Confirmaciones interactivas

**Cuándo usar**: Para migrar en Windows sin usar WSL.

---

#### [`setup-push-safety.sh`](./setup-push-safety.sh)
**Script de configuración de seguridad para Linux/macOS**

```bash
# Uso
./dev-docs/setup-push-safety.sh
```

**Características**:
- ✅ Instala pre-push hook bloqueando repos no deseados
- ✅ Configura git aliases (safe-push, verify-remote)
- ✅ Crea script safe-push.sh con verificación visual
- ✅ Valida configuración actual de remotes
- ✅ Elimina upstream si existe
- ✅ Wizard interactivo con confirmaciones

**Cuándo usar**: Una vez después de clonar el repo para proteger contra push accidentales.

---

#### [`setup-push-safety.ps1`](./setup-push-safety.ps1)
**Script de configuración de seguridad para Windows (PowerShell)**

```powershell
# Uso
.\dev-docs\setup-push-safety.ps1
```

**Características**:
- ✅ Mismas funciones que la versión de Linux/macOS
- ✅ Pre-push hook para Git Bash en Windows
- ✅ Scripts de PowerShell nativos
- ✅ Integración con Git for Windows

**Cuándo usar**: Una vez después de clonar el repo en Windows para proteger contra push accidentales.

---

## 🗂️ Estructura de Archivos

```
dev-docs/
├── README.md                          # Este archivo - índice de documentación
├── nvim-installation-guide.md         # Instalación completa de Neovim
├── QUICK-START-SEPARATION.md          # Inicio rápido: separar fork
├── separate-fork-guide.md             # Guía exhaustiva de separación
├── PUSH-SAFETY-GUIDE.md              # Guía de seguridad de push
├── migrate-to-new-repo.sh             # Script migración Linux/macOS
├── migrate-to-new-repo.ps1            # Script migración Windows
├── setup-push-safety.sh               # Script seguridad Linux/macOS
├── setup-push-safety.ps1              # Script seguridad Windows
├── workflows/                         # Flujos de trabajo clínicos
│   └── upc-daily-workflow.md          # Flujo diario UPC
└── planning/                          # Planificación y desarrollo
    ├── README.md                      # Índice de planificación
    ├── alternatives-existing-neovim.md # Alternativas si ya tienes Neovim
    ├── mac-implementation-tasklist.md # Tasklist atómico (41 tareas)
    └── mac-dev-environment.md         # Plan completo (3 fases)
```

---

## 🎯 Flujos de Trabajo Comunes

### Caso 0: Primer Turno con N4N en UPC ⭐

**Objetivo**: Usar N4N en tu primer turno en la Unidad de Pacientes Críticos.

```bash
# 1. Lee el flujo de trabajo completo
cat dev-docs/workflows/upc-daily-workflow.md

# O salta directo a la sección que necesitas:
# - Sección 1: Preparar el entorno (primera vez)
# - Sección 2: Flujo completo de un turno
# - Sección 3: Durante el turno (entradas rápidas)
# - Sección 4: Búsqueda durante el turno
# - Sección 5: Cierre de turno
# - Sección 8: Ejemplo completo de archivo de turno

# 2. Crea la carpeta de registros (primera vez)
mkdir -p C:\Users\TuUsuario\N4N\registros\UPC\2025

# 3. Al inicio del turno:
# - Abre N4N (doble click en n4n-portable.cmd)
# - :e UPC-2025-11-24-Noche.md
# - i → turno-diario<Tab>
# - Llena secciones por paciente
# - regenferm<Tab> para cada paciente

# 4. Durante el turno usa snippets:
# - sv<Tab> → signos vitales
# - med<Tab> → medicamentos
# - evol<Tab> → nota de evolución
# - incidente<Tab> → evento adverso

# 5. Al cierre:
# - Marca pendientes [x]
# - Resumen por paciente
# - Observaciones generales
# - :wq
```

**Recursos clave**:
- Flujo completo: `workflows/upc-daily-workflow.md`
- Snippets: `nvim-installation-guide.md` (sección snippets)
- Atajos de teclado: Sección 7 del workflow

---

### Caso 1: Nueva Instalación Completa

**Objetivo**: Instalar Neovim desde cero en una máquina nueva.

```bash
# 1. Lee la guía
cat dev-docs/nvim-installation-guide.md

# 2. Sigue los pasos según tu sistema operativo
# - Windows: Sección "Instalación para Windows (Modo Portátil)"
# - macOS: Sección "Instalación para macOS"
```

---

### Caso 2: Separar Fork Rápidamente

**Objetivo**: Hacer tu repo independiente en menos de 5 minutos.

```bash
# 1. Inicio rápido
cat dev-docs/QUICK-START-SEPARATION.md

# 2. Crear nuevo repo en GitHub (debe estar vacío)

# 3. Ejecutar script según tu OS:

# Linux/macOS:
./dev-docs/migrate-to-new-repo.sh https://github.com/TU-USUARIO/NUEVO-REPO.git

# Windows (PowerShell):
.\dev-docs\migrate-to-new-repo.ps1 -NewRepoUrl "https://github.com/TU-USUARIO/NUEVO-REPO.git"
```

---

### Caso 3: Separar Fork Manualmente (Aprender el Proceso)

**Objetivo**: Entender cada paso y hacerlo manualmente.

```bash
# 1. Lee la guía completa
cat dev-docs/separate-fork-guide.md

# 2. Sigue el "Método 2: Si ES un Fork (Separación Completa)"

# 3. Pasos principales:
git remote remove origin
git remote add origin https://github.com/TU-USUARIO/NUEVO-REPO.git
git push -u origin --all
git push -u origin --tags
```

---

### Caso 4: Configurar Seguridad de Push

**Objetivo**: Protegerse contra push accidentales al repo original.

```bash
# 1. Lee la guía de seguridad
cat dev-docs/PUSH-SAFETY-GUIDE.md

# 2. Ejecuta el script de configuración según tu OS:

# Linux/macOS:
./dev-docs/setup-push-safety.sh

# Windows (PowerShell):
.\dev-docs\setup-push-safety.ps1

# 3. Verifica la configuración
git verify-remote

# 4. Usa push seguro cuando sea necesario
git safe-push origin main
```

---

### Caso 5: Contactar a GitHub Support

**Objetivo**: Mantener el mismo nombre de repo pero eliminar "forked from".

```bash
# 1. Lee la opción en la guía rápida
cat dev-docs/QUICK-START-SEPARATION.md

# 2. Ve a: https://support.github.com/contact
# 3. Selecciona: "Repository" → "Detach Fork"
# 4. Espera respuesta (1-2 días hábiles)

# 5. Una vez desconectado:
git remote remove upstream  # Si existe
```

---

### Caso 6: Ya Tengo Neovim - Setup Rápido ⚡

**Objetivo**: Aprovechar tu config existente de Neovim (GentlemanNvim u otra) sin empezar desde cero.

```bash
# 1. Lee el análisis de alternativas
cat dev-docs/planning/alternatives-existing-neovim.md

# 2. Elige tu camino:

# Opción A - SÚPER RÁPIDO (5 minutos):
# Agregar snippets a tu config actual
mkdir -p ~/.config/nvim/snippets
# Copiar snippets clínicos
# Crear launcher ~/n4n-start.sh
# ¡Listo!

# Opción B - AISLAMIENTO (30-45 minutos):
# Config paralela independiente
mkdir -p ~/.config/nvim-n4n
# init.lua mínimo con LuaSnip
# Launcher con NVIM_APPNAME
alias n4n="NVIM_APPNAME=nvim-n4n nvim"

# Opción C - DESDE CERO (2-3 horas):
# Sigue el tasklist atómico completo
cat dev-docs/planning/mac-implementation-tasklist.md
```

**Recursos clave**:
- Alternativas: `planning/alternatives-existing-neovim.md`
- Comparación: Tabla con tiempo/complejidad/aislamiento
- Setup detallado: Cada alternativa con comandos exactos

---

## 🔍 FAQ (Preguntas Frecuentes)

### ¿Cuál es la diferencia entre los archivos de separación?

| Archivo | Propósito | Cuándo Usar |
|---------|-----------|-------------|
| `QUICK-START-SEPARATION.md` | Referencia rápida | Quiero ir directo al grano |
| `separate-fork-guide.md` | Guía exhaustiva | Quiero entender todo el proceso |
| `migrate-to-new-repo.sh` | Automatización Linux/Mac | Prefiero que un script lo haga |
| `migrate-to-new-repo.ps1` | Automatización Windows | Estoy en Windows y quiero automatizar |

### ¿Los scripts son seguros?

✅ **Sí, completamente seguros**. Los scripts:
- Hacen backup de tu configuración antes de cualquier cambio
- Piden confirmación antes de acciones críticas
- NO borran archivos de código
- Solo modifican la configuración de git remotes

### ¿Puedo revertir la separación?

Técnicamente sí, pero no tiene sentido. Si separaste el proyecto es porque quieres que sea independiente. Si cambias de opinión:

1. Tienes un backup en `.git-remotes-backup-XXXXXX.txt`
2. Puedes volver a agregar el remote original:
   ```bash
   git remote add upstream https://github.com/autor-original/repo-original.git
   ```

### ¿Necesito eliminar el repo viejo después de migrar?

**No es obligatorio**, pero es recomendado para evitar confusión:
1. Verifica que todo está en el nuevo repo
2. Agrega un README al viejo diciendo: "Este proyecto se mudó a [nuevo-repo]"
3. Archiva o elimina el repo viejo en GitHub

---

## 🛠️ Recursos Adicionales

### Git y GitHub
- [Pro Git Book](https://git-scm.com/book/en/v2) - Libro oficial de Git
- [GitHub Docs: About Forks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks)
- [GitHub Docs: Renaming a Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository)

### Neovim
- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [LazyVim](https://www.lazyvim.org/) - Base distribution

### Markdown y Documentación
- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Flavored Markdown](https://github.github.com/gfm/)
- [Obsidian Help](https://help.obsidian.md/)

---

## 🤝 Contribuir a la Documentación

Si encuentras errores o quieres mejorar la documentación:

1. **Reporta un issue** con detalles específicos
2. **Sugiere mejoras** con casos de uso reales
3. **Envía un PR** con correcciones o adiciones

### Estilo de Documentación

- ✅ Usa encabezados claros y jerárquicos
- ✅ Incluye ejemplos de código cuando sea relevante
- ✅ Agrega emojis para mejorar la legibilidad (pero no en exceso)
- ✅ Proporciona comandos listos para copiar y pegar
- ✅ Incluye capturas de pantalla para procesos visuales (opcional)
- ✅ Mantén un tono profesional pero accesible

---

## 📝 Registro de Cambios

### 2025-11-24
- ✅ Agregado análisis de alternativas para usuarios con Neovim existente
- ✅ Documentadas 3 alternativas: agregar a config actual, NVIM_APPNAME, o desde cero
- ✅ Actualizado README con flujo de decisión para usuarios con GentlemanNvim
- ✅ Agregado workflow "Caso 6: Ya Tengo Neovim - Setup Rápido"

### 2025-01-24
- ✅ Creada carpeta `dev-docs/`
- ✅ Agregada guía de instalación completa de Neovim
- ✅ Agregado flujo de trabajo diario para UPC
- ✅ Agregado plan de desarrollo macOS (3 fases)
- ✅ Agregado tasklist atómico (41 tareas)
- ✅ Agregada guía de separación de fork (exhaustiva)
- ✅ Agregado inicio rápido de separación
- ✅ Agregada guía de seguridad de push
- ✅ Agregados scripts automatizados (Linux/Mac y Windows)
- ✅ Agregado este README

---

## 📧 Contacto y Soporte

**Proyecto**: NursingNvim (N4N)
**Repositorio**: https://github.com/fegome90-cmd/n4n.dots (o tu nuevo repo)
**Propósito**: Herramienta de registros de enfermería basada en Neovim

Para preguntas específicas sobre el proyecto, abre un issue en el repositorio.

---

**Última actualización**: 2025-11-24
**Mantenido por**: @fegome90-cmd
