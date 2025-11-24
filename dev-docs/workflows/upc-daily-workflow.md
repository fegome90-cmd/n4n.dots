# Flujo de Trabajo Diario: UPC con N4N

Este documento describe el flujo de trabajo completo para usar N4N (Neovim for Nurses) en una Unidad de Pacientes Críticos (UPC), desde el inicio del turno hasta el cierre.

---

## 📋 Contexto y Premisas

### Asumimos que ya tienes:

- ✅ N4N instalado en `C:\Users\TuUsuario\N4N\` (Windows) o `~/.config/nvim` (Linux/Mac)
- ✅ Perfil `clinical_lite` activado (sin IA, sin dependencias externas)
- ✅ Snippets de enfermería configurados
- ✅ Script launcher `n4n-portable.cmd` (Windows) o alias (Linux/Mac)

### Estructura de carpetas requerida:

```
C:\Users\TuUsuario\N4N\
├── windows\
│   └── n4n-portable.cmd          # Launcher
├── config\
│   └── nvim\                      # Configuración de Neovim
└── registros\                     # ← AQUÍ VAN TODOS LOS REGISTROS
    └── UPC\
        ├── 2024\
        └── 2025\
            ├── UPC-2025-01-15-Noche.md
            ├── UPC-2025-01-16-Mañana.md
            └── UPC-2025-11-24-Noche.md
```

### Convención de nombres de archivo:

```
UPC-AAAA-MM-DD-TURNO.md

Ejemplos:
- UPC-2025-11-24-Noche.md
- UPC-2025-11-25-Mañana.md
- UPC-2025-11-25-Tarde.md
```

**Importante**: 1 archivo = 1 turno completo. No fraccionamos por paciente.

---

## 🚀 1. Antes de Escribir: Preparar el Entorno

### Primera Vez (Crear la Carpeta de Registros)

**Windows**:
```cmd
REM Solo la primera vez
mkdir C:\Users\TuUsuario\N4N\registros\UPC\2025
```

**Linux/macOS**:
```bash
# Solo la primera vez
mkdir -p ~/N4N/registros/UPC/2025
```

### Modificar el Launcher para Apuntar a la Carpeta de Registros

**Windows** - Edita `n4n-portable.cmd`:

```batch
@echo off
REM ... (configuración de variables XDG) ...

REM Posicionarse en carpeta de registros del año
cd /d "%PORTABLE_ROOT%\registros\UPC\2025"

REM Lanzar Neovim
nvim
```

**Linux/macOS** - Crea un alias en `~/.bashrc` o `~/.zshrc`:

```bash
alias n4n='cd ~/N4N/registros/UPC/2025 && nvim'
```

Con esto, cada vez que abras N4N ya estás parado en la carpeta correcta.

---

## 🏥 2. Flujo Completo de un Turno

### Paso 1: Abrir N4N

**Windows**:
1. Doble click en `C:\Users\TuUsuario\N4N\windows\n4n-portable.cmd`
2. Se abre una ventana de terminal
3. El script:
   - Exporta variables XDG
   - Se posiciona en `C:\Users\TuUsuario\N4N\registros\UPC\2025`
   - Lanza Neovim

**Linux/macOS**:
```bash
n4n
```

**Resultado**: Neovim abierto, en modo NORMAL, en la carpeta de registros.

---

### Paso 2: Crear la Nota del Turno

Ya en Neovim, estás en modo NORMAL.

#### Opción A: Comando `:e` (Mínimo Viable)

```vim
:e UPC-2025-11-24-Noche.md
```

Presiona `Enter`. Se crea un archivo nuevo (aún vacío).

#### Opción B: Con Obsidian.nvim (si lo tienes configurado)

```vim
<leader>on
# Escribe: UPC-2025-11-24-Noche
# Enter
```

**Recomendación**: Para MVP, usa `:e` (más simple, sin dependencias).

---

### Paso 3: Insertar la Plantilla de Turno

Ya tienes el archivo `UPC-2025-11-24-Noche.md` abierto (vacío).

1. **Entra a modo INSERT**:
   ```
   i
   ```

2. **Escribe el prefijo del snippet**:
   ```
   turno-diario
   ```

3. **Acepta el snippet**:
   - Cuando aparezca el menú de autocompletado
   - Presiona `Tab`

4. **La plantilla se expande**:

```markdown
---
fecha: 2025-11-24
hora_inicio: 20:00
turno: Noche
---

# Registro de Turno - 2025-11-24 Noche

## Pacientes Asignados
1. [ ] Paciente 1 - Cama X
2. [ ] Paciente 2 - Cama Y
3. [ ] Paciente 3 - Cama Z

## Pendientes del Turno
- [ ] Ronda inicial de signos vitales
- [ ] Administración de medicamentos 20:00
- [ ] Administración de medicamentos 00:00
- [ ] Administración de medicamentos 04:00
- [ ] Ronda de evaluación
- [ ] Documentación completada

## Observaciones Generales
[Cursor aquí]

---
*Turno iniciado*: 20:00
```

5. **Navega por los campos**:
   - `Tab`: Siguiente campo
   - `Shift+Tab`: Campo anterior

6. **Completa la información básica**:
   - Número de pacientes
   - Camas asignadas
   - Horarios específicos

7. **Sal de INSERT y guarda**:
   ```
   Esc              # Volver a modo NORMAL
   <leader>w        # O :w para guardar
   ```

---

### Paso 4: Crear Secciones por Paciente

Ahora vamos a estructurar el documento por paciente.

1. **Posiciónate** después de "Pacientes Asignados"
   ```
   j j j            # Bajar con j
   o                # Abrir línea nueva debajo y entrar a INSERT
   ```

2. **Escribe las secciones de pacientes**:

```markdown
## Pacientes Asignados
1. [x] Paciente 1 - Cama 5 - López, María (68a)
2. [x] Paciente 2 - Cama 8 - Ramírez, Juan (52a)
3. [x] Paciente 3 - Cama 12 - Silva, Ana (71a)

---

## Paciente 1 – Cama 5 – López, María

## Paciente 2 – Cama 8 – Ramírez, Juan

## Paciente 3 – Cama 12 – Silva, Ana

---
```

3. **Guarda**:
   ```
   Esc
   <leader>w
   ```

---

### Paso 5: Registro Inicial Completo por Paciente

Para la **primera evaluación completa** de cada paciente (inicio de turno):

1. **Posiciónate** bajo la sección del primer paciente:
   ```
   /Paciente 1      # Buscar "Paciente 1"
   Enter
   o                # Abrir línea nueva debajo
   ```

2. **Usa el snippet de registro completo**:
   ```
   regenferm
   Tab
   ```

3. **Se expande la plantilla**:

```markdown
## Paciente 1 – Cama 5 – López, María

### Registro de Enfermería - 2025-11-24 20:15

#### Datos del Paciente
- **Nombre**: López, María
- **Edad**: 68
- **Cama**: 5
- **Diagnóstico**: Shock séptico secundario a neumonía

#### Signos Vitales
- **Presión Arterial**: 95/60 mmHg
- **Frecuencia Cardíaca**: 118 lpm
- **Temperatura**: 38.2°C
- **Saturación O2**: 92% (VMI FiO2 60%)
- **Frecuencia Respiratoria**: 14 rpm (asistida)

#### Evaluación
- Paciente sedada, RASS -3
- Bajo VMI modo A/C
- NAD en infusión continua
- Diuresis horaria 40ml/h
- Lactato: 2.8 mmol/L (↓ desde 4.2)

#### Intervenciones
- Continuar ATB según esquema (día 3/7)
- Vigilar diuresis y balance hídrico
- Aseo bronquial c/4h
- Movilización en cama

#### Observaciones
Hemodinámicamente con leve mejoría, requiere soporte vasopresor.
Familia informada por Dr. García.

---
```

4. **Navega con `Tab`** entre campos y llena la información
5. **Guarda**: `Esc` → `<leader>w`

6. **Repite** para los otros 2 pacientes

**Al final del inicio de turno tienes**:
- ✅ 1 archivo `.md` para el turno
- ✅ Secciones organizadas por paciente
- ✅ Un registro inicial completo por cada paciente

---

## ⚡ 3. Durante el Turno: Entradas Rápidas

Durante el turno **NO vas a reescribir todo**. Usas snippets cortos y entradas rápidas.

### Signos Vitales Rápidos

Cada 1-2 horas (o según protocolo):

1. **Posiciónate** bajo la sección del paciente
   ```
   /Paciente 2      # Buscar
   Enter
   G                # Ir al final de esa sección (o navega con j)
   o                # Nueva línea
   ```

2. **Snippet de signos vitales**:
   ```
   sv
   Tab
   ```

3. **Se expande**:
   ```markdown
   **Signos Vitales** (23:15)
   - PA: 120/70 mmHg | FC: 78 lpm | T: 36.8°C | SatO2: 96% | FR: 18 rpm
   ```

4. **Ajustas** hora y valores con `Tab`
5. **Guardas**: `Esc` → `<leader>w`

**Tiempo total**: 15-20 segundos

---

### Administración de Medicamentos

Cada vez que administras medicación:

1. **Posiciónate** bajo el paciente
   ```
   /Paciente 1
   o
   ```

2. **Snippet de medicamento**:
   ```
   med
   Tab
   ```

3. **Se expande**:
   ```markdown
   ### Medicamento Administrado
   - **Hora**: 22:00
   - **Medicamento**: Morfina
   - **Dosis**: 2 mg
   - **Vía**: EV
   - **Observaciones**: Sin eventos adversos
   ```

4. **Llenas** los campos con `Tab`
5. **Guardas**: `Esc` → `<leader>w`

---

### Eventos Relevantes (Texto Sencillo)

Para eventos que no requieren plantilla completa:

1. **Nueva línea** bajo el paciente:
   ```
   o
   ```

2. **Escribe directo** (no necesitas snippet):
   ```markdown
   **23:40** – Refiere dolor 7/10 en región torácica. Se administra morfina 2mg EV según indicación SOS. Reevaluación en 30min.
   ```

3. **Guarda**: `Esc` → `<leader>w`

**Formato recomendado**: `**HH:MM** – Descripción breve y clara.`

---

### Notas de Evolución (Formato SOAP)

Para evaluaciones más estructuradas:

1. **Posiciónate** bajo el paciente
   ```
   /Paciente 3
   o
   ```

2. **Snippet de evolución**:
   ```
   evol
   Tab
   ```

3. **Se expande**:
   ```markdown
   ## Nota de Evolución - 2025-11-24 02:30

   **Subjetivo**: Paciente sedada, no refiere molestias

   **Objetivo**:
   - PA: 110/65 mmHg, FC: 88 lpm, T: 37.1°C
   - Diuresis: 320ml en últimas 4h
   - Lactato: 1.8 mmol/L (↓)

   **Análisis**: Mejoría hemodinámica, disminución de soporte vasopresor

   **Plan**:
   - Continuar destete de NAD
   - Evaluar extubación en próximas 12-24h
   - Mantener vigilancia estrecha
   ```

4. **Completas** con `Tab`
5. **Guardas**: `Esc` → `<leader>w`

---

### Incidentes / Eventos Adversos

**Solo cuando ocurre algo crítico** (caída, reacción adversa, paro, etc.):

1. **Ve al final del archivo**:
   ```
   G                # Shift+G
   o
   ```

2. **Snippet de incidente**:
   ```
   incidente
   Tab
   ```

3. **Se expande**:
   ```markdown
   # ⚠️ REPORTE DE INCIDENTE

   **Fecha y Hora**: 2025-11-24 03:15
   **Paciente**: López, María - Cama 5
   **Tipo de Incidente**: Extubación no programada

   ## Descripción del Incidente
   Paciente con episodio de agitación psicomotora, se autoextuba a pesar de
   sedación. Desaturación inmediata a 78%.

   ## Acciones Inmediatas
   - Ventilación con Ambú y O2 100%
   - Llamado a médico de guardia (Dr. García)
   - Reintubación exitosa a los 8 minutos
   - Ajuste de sedación (Midazolam 5mg EV bolo)

   ## Notificaciones
   - Médico de guardia: Sí (Dr. García, presente)
   - Supervisor: Sí (Enf. Martínez notificada telefónicamente)
   - Familia: Sí (informada por Dr. García)

   ## Estado Actual del Paciente
   Reintubada, bajo VMI, sedación profunda (RASS -4), SatO2 98%,
   hemodinámicamente estable.

   **Reportado por**: Tu Nombre - Enfermero UPC
   ```

4. **Completas** todos los campos
5. **Guarda**: `Esc` → `<leader>w`

**Importante**: Este tipo de reportes se marcan con `⚠️` para fácil identificación.

---

## 🔍 4. Búsqueda Durante el Turno

### Buscar en el Archivo Actual

Estando en el archivo del turno:

```vim
/palabra         # Buscar "palabra"
Enter
n                # Siguiente coincidencia
N                # Coincidencia anterior
```

**Ejemplos**:
```vim
/dolor           # Buscar "dolor"
/Ramírez         # Buscar "Ramírez"
/Medicamento     # Buscar registros de medicamentos
```

---

### Buscar en Todos los Archivos del Año

Si necesitas revisar registros anteriores:

```vim
:vimgrep /Ramírez/ *.md
Enter

:copen           # Abrir lista de resultados
Enter            # Ir a la coincidencia
```

**Ejemplo de búsqueda compleja**:
```vim
:vimgrep /shock séptico/ *.md      # Todos los casos de shock séptico
:vimgrep /extubación/ *.md         # Todos los eventos de extubación
```

---

## 🏁 5. Cierre de Turno

Al final del turno (típicamente últimos 15-30 minutos):

### A. Marcar Pendientes Completados

1. **Ve a la sección** "Pendientes del Turno":
   ```
   /Pendientes
   Enter
   ```

2. **Cambia** `[ ]` a `[x]` en las tareas completadas:

```markdown
## Pendientes del Turno
- [x] Ronda inicial de signos vitales
- [x] Administración de medicamentos 20:00
- [x] Administración de medicamentos 00:00
- [x] Administración de medicamentos 04:00
- [x] Ronda de evaluación
- [x] Documentación completada
```

Usa:
- `cw` → escribir `[x]` → `Esc`
- O reemplaza directo con `r` (sobre el espacio) → `x`

---

### B. Notas de Cierre por Paciente

Bajo cada paciente, agrega una **nota de cierre breve**:

```markdown
## Paciente 1 – Cama 5 – López, María

[... todos los registros del turno ...]

---
**Cierre de turno 07:00**
Hemodinámicamente estable con soporte vasopresor en descenso (NAD 0.15 mcg/kg/min).
Diuresis adecuada (balance -200ml). Sedación controlada. Sin eventos adversos.
Plan: Continuar destete de NAD y evaluar extubación en turno siguiente.
```

**Formato**: 2-4 líneas máximo por paciente.

---

### C. Observaciones Generales del Turno

1. **Ve a la sección** "Observaciones Generales":
   ```
   /Observaciones Generales
   Enter
   o
   ```

2. **Escribe un resumen global** (3-5 líneas):

```markdown
## Observaciones Generales

Turno tranquilo en general. Paciente 1 con mejoría hemodinámica sostenida.
Paciente 2 estable sin cambios. Paciente 3 presentó episodio de extubación
no programada a las 03:15, manejado exitosamente (ver reporte de incidente).
Todos los pacientes con balance hídrico controlado. Relevo completo entregado
a turno Mañana.

---
*Turno finalizado*: 07:00 | *Enfermero/a*: Tu Nombre
```

---

### D. Guardar y Salir

```vim
:w               # Guardar (o <leader>w)
:q               # Salir
```

O en un solo comando:
```vim
:wq              # Guardar y salir
```

---

### E. Verificar que se Guardó Correctamente

En Windows (Explorer):
```
C:\Users\TuUsuario\N4N\registros\UPC\2025\UPC-2025-11-24-Noche.md
```

El archivo debe tener:
- ✅ Fecha de modificación reciente
- ✅ Tamaño > 0 KB

---

## 📊 6. Resumen Ultra Corto del Flujo

Este es el flujo que debes memorizar:

### 1. Carpeta Única de Trabajo
```
N4N\registros\UPC\AAAA\
```
→ Ahí vive TODO

### 2. Cada Turno = 1 Archivo
```
UPC-AAAA-MM-DD-Turno.md
```

### 3. Al Inicio del Turno

```vim
# Abrir N4N
n4n-portable.cmd              # (Windows) o n4n (Linux/Mac)

# Crear archivo del turno
:e UPC-2025-11-24-Noche.md

# Insertar plantilla
i
turno-diario<Tab>

# Crear secciones por paciente
## Paciente 1 – Cama X – Apellido
## Paciente 2 – Cama Y – Apellido

# Primera evaluación completa
regenferm<Tab>
```

### 4. Durante el Turno

```vim
sv<Tab>          # Signos vitales rápidos
med<Tab>         # Medicamentos
evol<Tab>        # Nota de evolución
incidente<Tab>   # Solo si hay evento crítico

# Texto sencillo
o
**HH:MM** – Descripción del evento
```

### 5. Al Cierre

```vim
# Marcar pendientes
[ ] → [x]

# Nota de cierre por paciente
**Cierre de turno HH:MM** – Resumen breve

# Observaciones generales
3-5 líneas de resumen global

# Guardar y salir
:wq
```

---

## ⚡ 7. Atajos de Teclado Esenciales

### Navegación

| Atajo | Acción |
|-------|--------|
| `j` | Bajar una línea |
| `k` | Subir una línea |
| `h` | Izquierda |
| `l` | Derecha |
| `w` | Siguiente palabra |
| `b` | Palabra anterior |
| `0` | Inicio de línea |
| `$` | Final de línea |
| `gg` | Inicio del archivo |
| `G` | Final del archivo |

### Edición

| Atajo | Acción |
|-------|--------|
| `i` | INSERT antes del cursor |
| `a` | INSERT después del cursor |
| `o` | Nueva línea debajo + INSERT |
| `O` | Nueva línea arriba + INSERT |
| `Esc` | Volver a NORMAL |
| `dd` | Borrar línea |
| `yy` | Copiar línea |
| `p` | Pegar debajo |
| `u` | Deshacer |
| `Ctrl+r` | Rehacer |

### Búsqueda

| Atajo | Acción |
|-------|--------|
| `/palabra` | Buscar "palabra" |
| `n` | Siguiente resultado |
| `N` | Resultado anterior |

### Guardar/Salir

| Atajo | Acción |
|-------|--------|
| `:w` | Guardar |
| `:q` | Salir |
| `:wq` | Guardar y salir |
| `:q!` | Salir sin guardar |
| `<leader>w` | Guardar (atajo custom) |

---

## 📝 8. Ejemplo Completo de un Archivo de Turno

```markdown
---
fecha: 2025-11-24
hora_inicio: 20:00
turno: Noche
---

# Registro de Turno - 2025-11-24 Noche

## Pacientes Asignados
1. [x] Paciente 1 - Cama 5 - López, María (68a)
2. [x] Paciente 2 - Cama 8 - Ramírez, Juan (52a)
3. [x] Paciente 3 - Cama 12 - Silva, Ana (71a)

## Pendientes del Turno
- [x] Ronda inicial de signos vitales
- [x] Administración de medicamentos 20:00
- [x] Administración de medicamentos 00:00
- [x] Administración de medicamentos 04:00
- [x] Ronda de evaluación
- [x] Documentación completada

---

## Paciente 1 – Cama 5 – López, María

### Registro de Enfermería - 2025-11-24 20:15

#### Datos del Paciente
- **Nombre**: López, María
- **Edad**: 68
- **Cama**: 5
- **Diagnóstico**: Shock séptico secundario a neumonía

#### Signos Vitales
- **Presión Arterial**: 95/60 mmHg
- **Frecuencia Cardíaca**: 118 lpm
- **Temperatura**: 38.2°C
- **Saturación O2**: 92% (VMI FiO2 60%)
- **Frecuencia Respiratoria**: 14 rpm (asistida)

#### Evaluación
- Paciente sedada, RASS -3
- Bajo VMI modo A/C
- NAD en infusión continua (0.25 mcg/kg/min)
- Diuresis horaria 40ml/h
- Lactato: 2.8 mmol/L (↓ desde 4.2)

#### Intervenciones
- Continuar ATB según esquema (día 3/7): Meropenem + Vancomicina
- Vigilar diuresis y balance hídrico
- Aseo bronquial c/4h
- Movilización en cama

#### Observaciones
Hemodinámicamente con leve mejoría, requiere soporte vasopresor.
Familia informada por Dr. García.

---

**Signos Vitales** (23:00)
- PA: 102/65 mmHg | FC: 110 lpm | T: 37.9°C | SatO2: 94% | FR: 14 rpm

**Signos Vitales** (02:00)
- PA: 108/68 mmHg | FC: 102 lpm | T: 37.5°C | SatO2: 95% | FR: 14 rpm

### Medicamento Administrado
- **Hora**: 00:00
- **Medicamento**: Meropenem
- **Dosis**: 1g
- **Vía**: EV
- **Observaciones**: Sin eventos adversos

**02:30** – Ajuste de sedación. Midazolam aumentado a 4mg/h por agitación leve.

**Signos Vitales** (05:00)
- PA: 112/70 mmHg | FC: 95 lpm | T: 37.2°C | SatO2: 96% | FR: 14 rpm

---
**Cierre de turno 07:00**
Hemodinámicamente estable con soporte vasopresor en descenso (NAD 0.18 mcg/kg/min).
Diuresis adecuada (balance -180ml). Sedación controlada. Sin eventos adversos.
Plan: Continuar destete de NAD y evaluar extubación en turno siguiente.

---

## Paciente 2 – Cama 8 – Ramírez, Juan

[... registros similares ...]

---

## Paciente 3 – Cama 12 – Silva, Ana

[... registros similares ...]

---

# ⚠️ REPORTE DE INCIDENTE

**Fecha y Hora**: 2025-11-24 03:15
**Paciente**: Silva, Ana - Cama 12
**Tipo de Incidente**: Extubación no programada

## Descripción del Incidente
Paciente con episodio de agitación psicomotora súbita, se autoextuba a pesar de
sedación. Desaturación inmediata a 78%.

## Acciones Inmediatas
- Ventilación con Ambú y O2 100%
- Llamado a médico de guardia (Dr. García)
- Reintubación exitosa a los 8 minutos del evento
- Ajuste de sedación (Midazolam 5mg EV bolo + aumento de infusión a 6mg/h)

## Notificaciones
- Médico de guardia: Sí (Dr. García, presente durante reintubación)
- Supervisor: Sí (Enf. Martínez notificada telefónicamente a las 03:20)
- Familia: Sí (informada por Dr. García a las 04:00)

## Estado Actual del Paciente
Reintubada, bajo VMI modo A/C, sedación profunda (RASS -4), SatO2 98%,
hemodinámicamente estable con soporte vasopresor sin cambios.

**Reportado por**: Tu Nombre - Enfermero/a UPC

---

## Observaciones Generales

Turno con carga de trabajo moderada. Paciente 1 (López) con mejoría hemodinámica
sostenida, responde bien a tratamiento. Paciente 2 (Ramírez) estable sin cambios
significativos. Paciente 3 (Silva) presentó episodio de extubación no programada
a las 03:15, manejado exitosamente (ver reporte de incidente detallado arriba).

Todos los pacientes con balance hídrico controlado y dentro de parámetros aceptables.
Comunicación fluida con médicos de guardia durante todo el turno.

Relevo completo entregado a turno Mañana (Enf. González) con énfasis especial en
vigilancia de Paciente 3 post-reintubación.

---
*Turno finalizado*: 07:00 | *Enfermero/a*: Tu Nombre
```

---

## 🎯 9. Tips y Buenas Prácticas

### ✅ DO (Hacer)

1. **Sé consistente** con el formato de nombres de archivo
2. **Guarda frecuentemente** (`<leader>w` cada 2-3 entradas)
3. **Usa marcas de tiempo** en eventos importantes (`**HH:MM** – ...`)
4. **Sé conciso pero completo** en las observaciones
5. **Marca pendientes** como `[x]` al completarlos
6. **Usa snippets** para agilizar entradas repetitivas
7. **Separa visualmente** secciones con `---`
8. **Reporta incidentes** con plantilla completa

### ❌ DON'T (No Hacer)

1. **No uses abreviaturas no estándar** (pueden ser confusas)
2. **No omitas marcas de tiempo** en eventos críticos
3. **No mezcles pacientes** en la misma sección
4. **No uses jerga** que no sea universalmente entendida
5. **No dejes campos vacíos** en plantillas de incidentes
6. **No olvides cerrar** el turno con observaciones generales
7. **No guardes sin revisar** (usa `:w` consciente)
8. **No uses colores/formato** (texto plano, siempre portable)

---

## 🔧 10. Solución de Problemas Comunes

### "No se expande el snippet"

**Problema**: Escribes `regenferm` y presionas Tab pero no pasa nada.

**Soluciones**:
1. Verifica que estás en modo INSERT (debe decir `-- INSERT --` abajo)
2. Espera 1-2 segundos después de escribir el prefijo
3. Verifica que el archivo tiene extensión `.md`
4. Revisa que los snippets están en `~/.config/nvim/snippets/markdown.json`

---

### "El archivo no se guardó"

**Problema**: Sales de Neovim y el archivo está vacío o sin cambios.

**Soluciones**:
1. Siempre usa `:w` o `<leader>w` para guardar
2. Verifica que no haya errores en la línea de comandos (abajo)
3. Asegúrate de tener permisos de escritura en la carpeta
4. Si dice `[readonly]`, es porque el archivo está protegido

---

### "No encuentro el archivo después de cerrar"

**Problema**: Guardaste pero no ves el archivo en la carpeta.

**Soluciones**:
1. Verifica que estás en la carpeta correcta: `:pwd` muestra la ruta actual
2. Lista archivos desde Neovim: `:!ls` (Linux/Mac) o `:!dir` (Windows)
3. Verifica el nombre del archivo: `:file` muestra el nombre actual
4. Si usaste `:e` sin ruta, el archivo está donde iniciaste Neovim

---

### "Perdí cambios sin querer"

**Problema**: Cerraste sin guardar o borraste algo importante.

**Soluciones**:
1. **Deshacer**: En modo NORMAL, presiona `u` (varias veces si es necesario)
2. **Rehacer**: `Ctrl+r`
3. **Recuperar swap**: Si cerró inesperadamente, al reabrir te pregunta si quieres recuperar
4. **Backups**: Si configuraste backups automáticos, revisa `.backup/`

---

## 📚 11. Recursos Adicionales

### Documentación Relacionada

- **Instalación completa**: `dev-docs/nvim-installation-guide.md`
- **Snippets personalizados**: Ver sección de snippets en guía de instalación
- **Atajos de teclado**: `dev-docs/nvim-installation-guide.md` (sección "Atajos")

### Cheat Sheet de Neovim

```vim
# Modos
i           → INSERT (escribir)
Esc         → NORMAL (navegar/comandos)
v           → VISUAL (seleccionar)
:           → COMMAND (ejecutar comandos)

# Navegación
h j k l     → ← ↓ ↑ →
w           → Siguiente palabra
b           → Palabra anterior
0           → Inicio de línea
$           → Final de línea
gg          → Inicio del archivo
G           → Final del archivo

# Edición
o           → Nueva línea debajo
dd          → Borrar línea
yy          → Copiar línea
p           → Pegar
u           → Deshacer
Ctrl+r      → Rehacer

# Búsqueda
/texto      → Buscar "texto"
n           → Siguiente
N           → Anterior

# Guardar/Salir
:w          → Guardar
:q          → Salir
:wq         → Guardar y salir
:q!         → Salir sin guardar
```

---

## 🚀 12. Próximos Pasos

Una vez que domines este flujo básico (1-2 semanas de uso):

### Nivel 2: Refinamiento

1. **Crear snippets específicos por patología**:
   - `shock-septico` → Plantilla pre-llenada para shock séptico
   - `iam` → Plantilla para infarto agudo de miocardio
   - `vm` → Plantilla para pacientes con ventilación mecánica

2. **Agregar atajos personalizados**:
   - `<leader>p1` → Ir a Paciente 1
   - `<leader>p2` → Ir a Paciente 2
   - `<leader>sv` → Insertar snippet de signos vitales

3. **Automatizar fechas y horas**:
   - Snippets con `{{date}}` y `{{time}}` dinámicos

### Nivel 3: Análisis

1. **Scripts de búsqueda**:
   - Todos los episodios de hipotensión del mes
   - Pacientes con lactato > 4 mmol/L
   - Frecuencia de uso de vasopresores

2. **Reportes estadísticos**:
   - Promedio de pacientes por turno
   - Eventos adversos por mes
   - Balance hídrico agregado

---

## ✅ Checklist de Dominio del Flujo

Marca cuando puedas hacer esto sin consultar la guía:

- [ ] Abrir N4N en la carpeta correcta
- [ ] Crear archivo del turno con nombre correcto
- [ ] Insertar plantilla de turno con snippet
- [ ] Crear secciones por paciente
- [ ] Usar snippet `regenferm` para evaluación inicial
- [ ] Usar snippet `sv` para signos vitales rápidos
- [ ] Usar snippet `med` para medicamentos
- [ ] Escribir eventos con formato de hora
- [ ] Buscar información con `/`
- [ ] Marcar pendientes como completados `[x]`
- [ ] Escribir nota de cierre por paciente
- [ ] Escribir observaciones generales del turno
- [ ] Guardar y salir correctamente

**Cuando marques todos**: Estás listo para Nivel 2.

---

## 📞 Soporte

Si tienes dudas sobre este flujo:

1. Revisa la sección de **Solución de Problemas** (arriba)
2. Consulta la **Guía de Instalación**: `dev-docs/nvim-installation-guide.md`
3. Usa `:help` dentro de Neovim para ayuda de comandos específicos

---

**Documentación creada para el proyecto N4N (Neovim for Nurses)**
*Flujo de trabajo validado en entorno UPC*
*Última actualización: 2025-11-24*
