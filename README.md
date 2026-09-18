# forgeGit

Universal Git bootstrap kit for Windows.

> **¿Vas a trabajar con IA (ChatGPT, DeepSeek, Claude, Gemini, Cursor)?**
> Lee primero [WORKFLOW.md](WORKFLOW.md) para entender las reglas de
> trabajo, el formato quirúrgico de instrucciones, y los comandos de
> rescate.

## What it is

forgeGit is a small toolkit that eliminates the repetitive setup work
of starting a new Git project. Instead of manually copying `.gitignore`,
creating a README, making the first commit, and tagging a version,
you run one command and the project is ready.

Born from a real annoyance: copying the same 6 files into every new
project, over and over, for years.

## What it does

Running `forge` in an empty folder:

- Initializes a Git repository
- Sets `main` as default branch
- Creates a universal `.gitignore` (covers Node, Python, Rust, Go)
- Generates an adaptive `README.md`
- Creates initial commit + tag `v1.0.0`
- Generates 8 helper commands in `.forge/commands/`

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

## Install

### Option A - npm (recommended)

```cmd
npm install -g forgegit
```

### Option B - GitHub Release

Download the ZIP from:
https://github.com/vloitz/forgeGit/releases/latest

Extract anywhere. Run `tools\install.cmd` once.

## Usage

```cmd
cd any\project\folder
forge
```

The folder becomes a fully configured Git repository with helpers.

## Global commands

```cmd
forge           Bootstrap current directory
forge update    Sync .forge/ from kit
forge version   Show version
forge help      Show help
```

## Philosophy

- **Idempotent**: safe to run multiple times, never overwrites user files
- **Modular**: templates live in .tpl files, separated from logic
- **Portable**: works in any Windows folder, any project type
- **Configurable**: edit `config.cmd`, not the logic
- **Self-documenting**: generates colored terminal output
- **Batteries included**: snapshots, audit reports, tests

## Structure

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

## Requirements

- Windows 10 or 11
- Node.js 18+
- Git 2.30+
- VS Code CLI (optional, for `abrir.cmd`)

## Status

- Version: 1.5.8
- Published: npm + GitHub Release
- Tests: 16/16 passing
- Platform: Windows only (Linux/Mac planned as Node.js CLI)

## Roadmap

See [FUTURE.md](FUTURE.md) for the plan to convert this into a
cross-platform Node.js CLI (zero friction, no .cmd files in projects).

## Links

- Repository: https://github.com/vloitz/forgeGit
- npm: https://www.npmjs.com/package/forgegit
- Releases: https://github.com/vloitz/forgeGit/releases
- Manual: [MANUAL.md](MANUAL.md)

## License

MIT
```