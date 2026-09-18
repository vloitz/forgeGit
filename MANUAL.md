# forgeGit - Manual de uso

Guia completa de instalacion, uso y mantenimiento.

## Instalacion

    npm install -g forgegit

O descarga el ZIP desde:
https://github.com/vloitz/forgeGit/releases/latest

Requisitos: Windows 10/11, Node.js 18+, Git 2.30+

## Uso en un proyecto nuevo

    cd ruta\del\proyecto
    forge

El proyecto queda con Git, .gitignore, README.md, commit inicial,
tag v1.0.0 y 8 helpers en .forge/commands/.

## Uso en un proyecto existente

Si el proyecto ya tiene forgeGit instalado:

    cd ruta\del\proyecto
    forge <comando>

El comando global detecta el forge.cmd local y delega automaticamente.

## Comandos disponibles

| Comando | Descripcion |
|---------|-------------|
| forge | Instala forgeGit en la carpeta actual |
| forge update | Actualiza .forge/ desde el kit global |
| forge version | Muestra la version instalada |
| forge help | Ayuda completa |
| forge init | Re-bootstrap (idempotente) |
| forge init --force | Regenerar todo |
| forge save | Commit de cambios |
| forge push | Push a GitHub |
| forge log | Ver commits recientes |
| forge snap | Crear/restaurar snapshots |
| forge audit | Generar reporte diff |
| forge open | Abrir en VS Code |
| forge serve | Servidor de desarrollo (auto-detect) |

## Estructura del proyecto

    MiProyecto/
    |-- forge.cmd          Menu + CLI (unico .cmd visible)
    |-- .forge/
    |   |-- init.cmd       Bootstrap
    |   |-- config.cmd     Configuracion
    |   |-- commands/      8 helpers
    |   |-- lib/           Modulos internos
    |   |-- templates/     Fuentes .tpl
    |   +-- serve-static.js
    |-- versiones/         Snapshots
    |-- audits/            Reportes diff
    +-- (tus archivos)

## Los 8 helpers

| Helper | Descripcion |
|--------|-------------|
| save.cmd | Commit local de cambios |
| push.cmd | Push a GitHub |
| snapshots.cmd | Crear/restaurar snapshots |
| historial.cmd | Ver commits recientes |
| auditar.cmd | Generar reporte diff |
| abrir.cmd | Abrir en VS Code |
| serve.cmd | Servidor de desarrollo (auto-detect) |
| init.cmd | Re-bootstrap (idempotente) |

## Actualizar

    npm install -g forgegit@latest
    cd ruta\del\proyecto
    forge update

## Actualizar el kit y un proyecto

Actualizar el kit global:

    npm install -g forgegit@latest

Actualizar un proyecto especifico:

    cd ruta\del\proyecto
    forge update

Esto copia forge.cmd y .forge/ desde el kit global al proyecto,
sin tocar tus archivos ni los helpers pre-generados.

## Desinstalar

    npm uninstall -g forgegit

## Filosofia

- **Idempotente**: seguro de ejecutar multiples veces
- **Modular**: templates en archivos .tpl
- **Portable**: funciona en cualquier carpeta Windows
- **Configurable**: editar .forge/config.cmd
- **Autodocumentado**: salida de terminal con colores

## Links

- Repo: https://github.com/vloitz/forgeGit
- npm: https://www.npmjs.com/package/forgegit
- Releases: https://github.com/vloitz/forgeGit/releases
- Workflow IA: WORKFLOW.md
- Roadmap: FUTURE.md

## Licencia

MIT
```

**Guardá con `Ctrl+S`.**

---

## 🎬 Fix 5 — `README.md`

**En VS Code, abrí `README.md`.**

**`Ctrl+H`** para Buscar/Reemplazar.

### Reemplazo 1 — Versión

**Buscar:**
```
- Version: 1.2.2
```

**Reemplazar:**
```
- Version: 1.5.8
```

### Reemplazo 2 — Tests

**Buscar:**
```
- Tests: 14/14 passing
```

**Reemplazar:**
```
- Tests: 16/16 passing
```

### Reemplazo 3 — Estructura del proyecto

**Buscar exactamente:**
```
forgeGit/
├── init.cmd              Entry point (14 steps)
├── config.cmd            Configuration values
├── MANUAL.md             Full user manual
├── FUTURE.md             Roadmap / ideas
├── lib/                  Internal modules
│   ├── ui.cmd            Terminal UI helpers
│   ├── git-ops.cmd       Git operations
│   └── templates.cmd     Template renderer
├── templates/            Source templates (.tpl)
├── tools/                Author tools
│   ├── install.cmd       Install forge globally
│   ├── uninstall.cmd     Uninstall forge
│   ├── restore.cmd       Restore PATH from backup
│   ├── pack.cmd          Build clean distribution
│   ├── release.cmd       Build ZIP + open GitHub
│   └── bin/forge.cmd     Global command
└── tests/                Automated tests (14/14)
```

**Reemplazarlo exactamente por:**
```
forgeGit/
├── forge.cmd             Menu + CLI (unico .cmd visible)
├── .forge/               Infraestructura oculta
│   ├── init.cmd          Bootstrap (17 pasos)
│   ├── config.cmd        Configuration values
│   ├── lib/              Internal modules
│   ├── templates/        Source templates (.tpl)
│   ├── commands/         8 helpers generados
│   └── serve-static.js   Servidor Node
├── MANUAL.md             Full user manual
├── WORKFLOW.md           AI workflow rules
├── README.md             This file
├── tools/                Author tools
│   ├── install.cmd       Install forge globally
│   ├── uninstall.cmd     Uninstall forge
│   ├── restore.cmd       Restore PATH from backup
│   ├── pack.cmd          Build clean distribution
│   ├── release.cmd       Build ZIP + open GitHub
│   └── bin/forge.cmd     Global command
└── tests/                Automated tests (16/16)
```

### Reemplazo 4 — Los 7 helpers

**Buscar exactamente:**
```
## The 7 helpers

| File | Purpose |
|------|---------|
| `guardar.cmd` | Commit changes locally |
| `subir.cmd` | Push to GitHub |
| `snapshots.cmd` | Create/restore full project snapshots |
| `historial.cmd` | View recent commits |
| `auditar.cmd` | Generate diff reports (for AI review) |
| `abrir.cmd` | Open project in VS Code |
| `init.cmd` | Re-bootstrap (idempotent) |
```

**Reemplazarlo exactamente por:**
```
## The 8 helpers

| File | Purpose |
|------|---------|
| `save.cmd` | Commit changes locally |
| `push.cmd` | Push to GitHub |
| `snapshots.cmd` | Create/restore full project snapshots |
| `historial.cmd` | View recent commits |
| `auditar.cmd` | Generate diff reports (for AI review) |
| `abrir.cmd` | Open project in VS Code |
| `serve.cmd` | Dev server (auto-detect stack) |
| `init.cmd` | Re-bootstrap (idempotent) |
```

### Reemplazo 5 — What it does

**Buscar exactamente:**
```
- Generates 7 helper commands in the project
```

**Reemplazarlo exactamente por:**
```
- Generates 8 helper commands in `.forge/commands/`
```

### Reemplazo 6 — Global commands (sección)

**Buscar exactamente:**
```
## Global commands

```cmd
forge           Bootstrap current directory
forge update    Sync templates from kit
forge help      Show help
```
```

**Reemplazarlo exactamente por:**
```
## Global commands

```cmd
forge           Bootstrap current directory
forge update    Sync .forge/ from kit
forge version   Show version
forge help      Show help
```
```
