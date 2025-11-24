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
└── setup-push-safety.ps1              # Script seguridad Windows
```

---

## 🎯 Flujos de Trabajo Comunes

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

### 2025-01-24
- ✅ Creada carpeta `dev-docs/`
- ✅ Agregada guía de instalación completa de Neovim
- ✅ Agregada guía de separación de fork (exhaustiva)
- ✅ Agregado inicio rápido de separación
- ✅ Agregados scripts automatizados (Linux/Mac y Windows)
- ✅ Agregado este README

---

## 📧 Contacto y Soporte

**Proyecto**: NursingNvim (N4N)
**Repositorio**: https://github.com/fegome90-cmd/n4n.dots (o tu nuevo repo)
**Propósito**: Herramienta de registros de enfermería basada en Neovim

Para preguntas específicas sobre el proyecto, abre un issue en el repositorio.

---

**Última actualización**: 2025-01-24
**Mantenido por**: @fegome90-cmd
