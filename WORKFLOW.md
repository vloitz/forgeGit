# forgeGit - Workflow con IA

Documento para cualquier IA (ChatGPT, DeepSeek, Claude, Gemini, Cursor,
Cline) que vaya a trabajar con proyectos que usan forgeGit.

---

## Contexto del proyecto (para IA nuevas)

Este proyecto usa **forgeGit**, un kit de bootstrap Git para Windows.

- **Comandos principales**: forge (menu), forge save (commit), forge push (GitHub), forge serve (servidor), forge snap (snapshots)
- **Estructura**: forge.cmd en raiz, toda la infraestructura en .forge/
- **Stack tipico**: HTML + Canvas + JS Vanilla + Node.js
- **Servidor**: node server.js en puerto 8080
- **Segmentacion IA**: RMBG-2.0 en WebGPU via Web Worker

Si sos una IA leyendo esto por primera vez, mira tambien:
- README.md (que es forgeGit)
- MANUAL.md (comandos detallados)
- FUTURE.md (roadmap)

---

## Regla de oro: instrucciones quirurgicas

Toda instruccion para modificar codigo DEBE ser:

1. Bloque exacto de codigo (no referencias vagas)
2. Ubicacion exacta (busca / reemplaza / pega debajo)
3. Sin ambiguedad

### Formato obligatorio para REEMPLAZAR

    Busca exactamente este codigo:
    [codigo viejo exacto]

    Reemplazalo exactamente por este codigo:
    [codigo nuevo exacto]

### Formato obligatorio para INSERTAR

    Busca exactamente esta linea:
    [linea exacta]

    Pega inmediatamente debajo de esta linea:
    [bloque nuevo completo]

### PROHIBIDO

- "busca donde..."
- "anade cerca de..."
- "modifica la funcion que..."
- "cambia la linea que dice..."
- Cualquier instruccion que requiera interpretacion

---

## Reglas para la IA

Si sos una IA leyendo este documento:

### Herramienta correcta segun el caso

| Caso | Herramienta |
|------|-------------|
| Crear archivo NUEVO (.md, .txt, README) | Notepad (rapido) |
| Editar codigo existente (HTML, JS, CSS) | VS Code (forge open) |
| Aplicar cambio quirurgico de la IA | VS Code (Ctrl+H para reemplazar) |
| Ver diff de cambios | VS Code (Source Control) o git diff |
| Comparar 2 versiones | VS Code (Ctrl+Shift+P -> Compare) |

### PROHIBIDO usar Notepad para

- Editar archivos de codigo existentes (no tiene reemplazo confiable)
- Aplicar cambios quirurgicos de la IA
- Ver/editar archivos con mas de 50 lineas
- Editar archivos con encoding especial (UTF-8 con BOM, CRLF)

### Comando correcto para editar codigo

    forge open

Abre VS Code en el proyecto. Desde ahi:
- Ctrl+F para buscar
- Ctrl+H para reemplazar
- Ctrl+S para guardar
- Ctrl+Shift+F para buscar en todo el proyecto


1. Toda instruccion de codigo usa formato busca/reemplaza exacto.
2. No asumas ubicaciones. Siempre especifica linea exacta.
3. Un cambio a la vez. Si son 3 archivos, dalos por separado.
4. Recomenda "forge snap" antes de cambios grandes.
5. Si un cambio falla, deci exactamente que comando de git usar.
6. No mezcles cambios buenos con malos en el mismo bloque.
7. Preserva comentarios del usuario por defecto. Solo actualiza
   un comentario si describe codigo que cambio. No preguntes
   por comentarios triviales ni redundantes.

---

## Dos tipos de IA

### Tipo A: IA en chat (ChatGPT, DeepSeek web, Claude web)

- NO tiene acceso a los archivos
- El humano copia/pega el codigo afectado
- La IA responde con formato quirurgico
- El humano aplica manualmente en VS Code

### Tipo B: IA en editor (Cursor, Cline, Copilot, Roo)

- SI tiene acceso a los archivos
- Puede editar directamente
- Aun asi, debe usar formato quirurgico para trazabilidad
- El humano solo verifica y prueba

---

## Flujo de trabajo

### 1. Antes de cambios grandes

    forge snap

Nombre: "antes de [cambio]"

Crea un punto de restauracion completo.

### 2. IA da cambios en formato quirurgico

Cada cambio viene con bloque exacto de busca/reemplaza.

### 3. Aplicar en VS Code

    forge open

Buscar el bloque, reemplazar, Ctrl+S.

### 4. Probar en navegador

    forge serve

F5 para recargar tras cada cambio.

### 5. Decidir

| Resultado | Accion |
|-----------|--------|
| Todo funciona | forge save |
| 1 archivo falla | git checkout -- archivo.js + forge save |
| Todo falla | forge snap -> v -> SI |

---

## Como reportar resultados a la IA

### Si el cambio funciona

    Aplicado el cambio 1 (GLOW_MIN: 30). Funciona. El aura es mas intensa.

### Si el cambio falla

    Aplicado el cambio 1. NO funciona. Al arrastrar imagen el aura
    desaparece. Consola muestra:
    TypeError: hueShift2 is not defined at renderAura (Static_Glish.html:412)

### Si el bloque no se encontro

    Busque "const glowMax = 75" en Static_Glish.html. NO EXISTE.
    El codigo actual tiene:
    const GLOW_MAX: 75,

### Si cambio otros archivos

    El cambio 1 en Static_Glish.html funciona.
    Pero worker.js tambien parece afectado. Revisar?

---

## Cuando la IA alucina

Si la IA da un bloque que NO EXISTE en tu codigo:

1. NO aplicar a ciegas
2. Reportar a la IA con el bloque actual
3. Pedirle que ajuste la instruccion
4. Nunca inventar el cambio

Formato de reporte:

    Bloque de la IA:
    const glowMax = 75;

    Bloque real en el archivo:
    const GLOW_MAX: 75,

    Ajusta la instruccion al codigo real.

---

## Multi-archivo coordinado

Si la IA va a modificar varios archivos, DEBE:

1. Listar TODOS los archivos afectados al inicio
2. Dar los cambios en orden logico (dependencias primero)
3. Indicar que archivos probar juntos

Formato:

    Archivos afectados:
      1. Static_Glish.html (cambio de GLOW_MAX)
      2. worker.js (cambio dependiente del anterior)
      3. server.js (independiente)

    Aplicar los 3 y probar juntos.

---

## Dependencias cruzadas

Si cambias una variable global, revisa quien la usa:

    grep "GLOW_MAX" Static_Glish.html

Si el cambio en un archivo afecta a otro, la IA DEBE avisarlo.

---

## Forge audit para IA

Cuando tenes commits recientes con cambios mezclados:

    forge audit

Elegir rango de commits. Genera un .txt en audits/ con:
- Commits del rango
- Diff completo
- Estado actual

Se lo podes pasar a otra IA para que audite los cambios.

---

## Cuando la IA es mala vs typo

Si un cambio no funciona, distinguir:

| Sintoma | Causa probable |
|---------|----------------|
| Error de sintaxis | Typo al aplicar |
| Bloque no encontrado | IA alucino |
| Variable no definida | Orden de cambios incorrecto |
| Funciona pero diferente | IA malinterpreto |

Antes de culpar a la IA, verificar:

    git diff

Si el diff NO coincide con lo que la IA dijo, fue typo tuyo.
Si el diff SI coincide, la IA fallo.

---

## Edge cases

### Caso 1: 3 archivos, 2 buenos, 1 malo

    git checkout -- archivo_roto.js
    forge save

Mensaje: "X e Y ok, Z descartado"

### Caso 2: 1 archivo con 5 cambios, 3 buenos, 2 malos

    git checkout -- archivo.html

Luego pedir a la IA 1 cambio a la vez y commitear cada uno.

### Caso 3: Ya commiteaste y despues viste el error

    git log --oneline -5
    git checkout abc1234 -- archivo.js
    forge save

Mensaje: "revertir archivo X a version anterior"

### Caso 4: No sabes que archivo tiene el error

    git checkout -- archivo1.js
    REM Probar. Si no funciona:
    git checkout -- archivo2.js
    REM El culpable era el ultimo revertido.

### Caso 5: Todo roto, volver al snapshot

    forge snap

Elegir v, escribir SI.

---

## Comandos de rescate

| Situacion | Comando |
|-----------|---------|
| Ver que cambio | git diff |
| Revertir 1 archivo | git checkout -- archivo.js |
| Revertir archivo a commit viejo | git checkout abc1234 -- archivo.js |
| Deshacer ultimo commit (mantener cambios) | git reset --soft HEAD~1 |
| Ver TODO lo que hiciste | git reflog |
| Volver a estado borrado | git reset --hard HEAD@{2} |
| Restaurar snapshot | forge snap -> v |

---

## Comandos del dia a dia

    forge              Menu interactivo
    forge init         Bootstrap (raro)
    forge save         Commit de cambios
    forge push         Push a GitHub
    forge log          Historial
    forge snap         Snapshots
    forge audit        Reporte diff
    forge open         VS Code
    forge serve        Servidor dev
    forge help         Ayuda

---

## Estructura del proyecto

    MiProyecto/
    |-- forge.cmd              Menu + CLI (unico .cmd visible)
    |-- .forge/
    |   |-- init.cmd           Bootstrap
    |   |-- config.cmd         Configuracion
    |   |-- commands/          7 helpers
    |   |-- lib/               Modulos internos
    |   |-- templates/         Fuentes .tpl
    |   +-- serve-static.js    Servidor Node.js
    |-- versiones/             Snapshots
    |-- audits/                Reportes diff
    +-- (tus archivos)

---

## Links

- Repo: https://github.com/vloitz/forgeGit
- npm: https://www.npmjs.com/package/forgegit
- Releases: https://github.com/vloitz/forgeGit/releases
- Manual: MANUAL.md
- Futuro: FUTURE.md