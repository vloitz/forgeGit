# 📄 README esencial para `forgeGit`

Contenido para reemplazar `README.md`:

```markdown
# forgeGit

Bootstrap universal de Git para proyectos nuevos.

## Uso

1. Copiar esta carpeta al nuevo proyecto
2. Ejecutar:

   ```cmd
   init.cmd
   ```

## Qué hace

- Verifica Node.js y Git
- Inicializa el repositorio
- Establece rama `main`
- Crea `.gitignore` universal
- Crea `README.md` adaptativo
- Commit inicial + tag `v1.0.0`
- Genera `subir.cmd` para backups

Idempotente: se puede ejecutar varias veces sin romper nada.

## Estructura

```
forgeGit/
├── config.cmd          Configuración
├── init.cmd            Entry point
├── subir.cmd           Backup con nombre
└── lib/
    ├── ui.cmd
    ├── git-ops.cmd
    └── templates.cmd
```

## Comandos

| Comando | Acción |
|---------|--------|
| `init.cmd` | Bootstrap del proyecto |
| `subir.cmd` | Crear backup en `versiones/` |

## Personalización

Editar `config.cmd`:

```cmd
set "FG_VERSION=1.2.0"
set "TAG_INITIAL=v1.0.0"
set "BRANCH_MAIN=main"
```

## Requisitos

- Node.js 18+
- Git 2.30+
- Windows
```

---

## PowerShell para escribirlo

```powershell
cd "E:\MASTER\Proyectos\2026\Toolkit\Sys\forgeGit"

$readme = @'
# forgeGit

Bootstrap universal de Git para proyectos nuevos.

## Uso

1. Copiar esta carpeta al nuevo proyecto
2. Ejecutar:

   ```cmd
   init.cmd
   ```

## Qué hace

- Verifica Node.js y Git
- Inicializa el repositorio
- Establece rama `main`
- Crea `.gitignore` universal
- Crea `README.md` adaptativo
- Commit inicial + tag `v1.0.0`
- Genera `subir.cmd` para backups

Idempotente: se puede ejecutar varias veces sin romper nada.

## Estructura

```
forgeGit/
├── config.cmd          Configuración
├── init.cmd            Entry point
├── subir.cmd           Backup con nombre
└── lib/
    ├── ui.cmd
    ├── git-ops.cmd
    └── templates.cmd
```

## Comandos

| Comando | Acción |
|---------|--------|
| `init.cmd` | Bootstrap del proyecto |
| `subir.cmd` | Crear backup en `versiones/` |

## Personalización

Editar `config.cmd`:

```cmd
set "FG_VERSION=1.2.0"
set "TAG_INITIAL=v1.0.0"
set "BRANCH_MAIN=main"
```

## Requisitos

- Node.js 18+
- Git 2.30+
- Windows
'@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText("$PWD\README.md", $readme, $utf8NoBom)

Write-Host "  README.md actualizado" -ForegroundColor Green
```

---
