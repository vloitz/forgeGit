
**Eso son MIS instrucciones, no el contenido del manual.** El manual real está dentro del bloque ```markdown, pero envuelto con texto extra.

### Fix — Reemplazar MANUAL.md completo

**En VS Code, abrí `MANUAL.md`, `Ctrl+A` → Suprimir → Pegá esto:**

```markdown
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

- Idempotente: seguro de ejecutar multiples veces
- Modular: templates en archivos .tpl
- Portable: funciona en cualquier carpeta Windows
- Configurable: editar .forge/config.cmd
- Autodocumentado: salida de terminal con colores

## Links

- Repo: https://github.com/vloitz/forgeGit
- npm: https://www.npmjs.com/package/forgegit
- Releases: https://github.com/vloitz/forgeGit/releases
- Workflow IA: WORKFLOW.md
- Roadmap: FUTURE.md

## Licencia

MIT