# 🚀 Inicio Rápido: Separar Fork del Repositorio Original

¿Quieres separar completamente tu proyecto del repositorio original? Aquí están tus opciones.

---

## 🎯 Elige tu Método

### ✅ Opción 1: Scripts Automatizados (Recomendado)

Usa los scripts incluidos para automatizar todo el proceso:

#### En Linux / macOS:
```bash
# 1. Crea tu nuevo repo en GitHub (debe estar vacío)
# 2. Ejecuta el script
cd /ruta/a/n4n.dots
./dev-docs/migrate-to-new-repo.sh https://github.com/TU-USUARIO/NUEVO-REPO.git
```

#### En Windows (PowerShell):
```powershell
# 1. Crea tu nuevo repo en GitHub (debe estar vacío)
# 2. Ejecuta el script
cd C:\ruta\a\n4n.dots
.\dev-docs\migrate-to-new-repo.ps1 -NewRepoUrl "https://github.com/TU-USUARIO/NUEVO-REPO.git"
```

**Listo en 2 minutos.** ✨

---

### 🔧 Opción 2: Manual (Si prefieres control total)

#### Paso 1: Crear Nuevo Repositorio
1. Ve a https://github.com/new
2. Nombre: `nvim-nursing` (o el que prefieras)
3. **NO** marques "Initialize with README"
4. Click "Create repository"

#### Paso 2: Migrar tu Código
```bash
# Navega a tu proyecto
cd /ruta/a/n4n.dots

# Verifica que no hay cambios pendientes
git status

# Elimina el remote actual
git remote remove origin

# Agrega tu nuevo repo
git remote add origin https://github.com/TU-USUARIO/nvim-nursing.git

# Push de todo
git push -u origin --all
git push -u origin --tags
```

**Tiempo estimado: 5 minutos.** ⏱️

---

### 📞 Opción 3: Pedir a GitHub que Desconecte el Fork

Si quieres mantener el mismo nombre de repo pero eliminar la etiqueta "forked from":

1. Ve a: https://support.github.com/contact
2. Selecciona: **"Repository"** → **"Detach Fork"**
3. Explica: *"I want to detach my fork from the original repository to make it standalone"*
4. Proporciona la URL de tu fork: `https://github.com/TU-USUARIO/n4n.dots`

**Tiempo de respuesta de GitHub: 1-2 días hábiles.** 📧

Una vez desconectado por GitHub:
```bash
# Solo elimina el upstream (si existe)
git remote remove upstream
```

---

## 🔍 ¿Cómo Saber si es un Fork?

Abre tu repositorio en GitHub: `https://github.com/fegome90-cmd/n4n.dots`

- **Si ves**: `forked from [usuario/repo-original]` → **ES UN FORK**
- **Si NO ves** ese mensaje → **YA ES INDEPENDIENTE**

---

## ⚡ Comando Ultra-Rápido (Para Expertos)

Si ya creaste el nuevo repo y quieres ir directo al grano:

```bash
git remote remove origin && \
git remote add origin https://github.com/TU-USUARIO/NUEVO-REPO.git && \
git push -u origin --all && \
git push -u origin --tags && \
echo "✓ Migración completa"
```

---

## 📚 Más Información

- **Guía completa**: Lee `dev-docs/separate-fork-guide.md`
- **Scripts automatizados**:
  - Linux/Mac: `dev-docs/migrate-to-new-repo.sh`
  - Windows: `dev-docs/migrate-to-new-repo.ps1`

---

## ✅ Checklist Post-Migración

Después de migrar, verifica:

- [ ] GitHub ya NO muestra "forked from [repo-original]"
- [ ] `git remote -v` solo muestra tu nuevo repositorio
- [ ] Todas las ramas están en el nuevo repo
- [ ] Todos los commits están presentes
- [ ] Puedes hacer push sin problemas
- [ ] Actualiza URLs en README.md y documentación

---

## 🆘 ¿Problemas?

### "Permission denied" al hacer push
```bash
# Usa SSH en lugar de HTTPS
git remote set-url origin git@github.com:TU-USUARIO/NUEVO-REPO.git
```

### "Repository not found"
```bash
# Verifica la URL correcta
git remote -v
git remote set-url origin https://github.com/TU-USUARIO/NOMBRE-CORRECTO.git
```

### "Updates were rejected"
```bash
# Primera vez con repo vacío, usa force (SOLO UNA VEZ)
git push -u origin main --force
```

---

## 💡 Tips Finales

1. **Backup primero**: El script automático guarda un backup, pero puedes hacer uno manual:
   ```bash
   git remote -v > git-remotes-backup.txt
   ```

2. **Renombra el proyecto**: Dale identidad propia
   - `GentlemanNvim` → `NursingNvim` o `ClinicalNvim`
   - Actualiza README.md y archivos de configuración

3. **Actualiza la licencia**: Si el repo original tenía licencia, mantén la atribución:
   ```
   Original work Copyright (c) [Año] [Autor Original]
   Modified work Copyright (c) 2025 [Tu Nombre]
   ```

4. **Elimina el fork viejo**: Una vez verificado que todo está en el nuevo repo:
   - GitHub → Settings → Danger Zone → Delete this repository

---

## 🎉 ¡Listo!

Tu proyecto ahora es **100% independiente**. No podrás accidentalmente afectar el repo original.

¿Dudas? Revisa la guía completa en `dev-docs/separate-fork-guide.md`
