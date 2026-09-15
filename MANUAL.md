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
tag v1.0.0 y 7 helpers en .forge/commands/.

## Comandos disponibles

| Comando | Descripcion |
|---------|-------------|
| forge save | Commit de cambios |
| forge push | Push a GitHub |
| forge log | Ver commits recientes |
| forge snap | Crear/restaurar snapshots |
| forge audit | Generar reporte diff |
| forge open | Abrir en VS Code |
| forge serve | Servidor de desarrollo (auto-detect) |
| forge help | Ayuda completa |

## Estructura del proyecto

    MiProyecto/
    |-- forge.cmd          Menu + CLI (unico .cmd visible)
    |-- .forge/
    |   |-- init.cmd       Bootstrap
    |   |-- config.cmd     Configuracion
    |   |-- commands/      7 helpers
    |   |-- lib/           Modulos internos
    |   |-- templates/     Fuentes .tpl
    |   +-- serve-static.js
    |-- versiones/         Snapshots
    |-- audits/            Reportes diff
    +-- (tus archivos)

## Actualizar

    npm install -g forgegit@latest
    forge update

## Links

- Repo: https://github.com/vloitz/forgeGit
- npm: https://www.npmjs.com/package/forgegit
- Releases: https://github.com/vloitz/forgeGit/releases

## Licencia

MIT