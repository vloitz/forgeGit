cd "E:\MASTER\Proyectos\2026\Toolkit\Sys\forgeGit"

$content = @'
============================================================
  forgeGit - MANUAL PERSONAL
============================================================

INSTALAR EN PC NUEVA (una sola vez)
------------------------------------------------------------
  npm install -g forgegit


USAR EN UN PROYECTO NUEVO
------------------------------------------------------------
  cd ruta\del\proyecto
  forge

  Listo. El proyecto queda con Git + 7 helpers.


COMANDOS DEL DIA A DIA
------------------------------------------------------------
  guardar.cmd     Commit cambios
  subir.cmd       Push a GitHub
  snapshots.cmd   Crear/restaurar copia de seguridad
  historial.cmd   Ver commits recientes
  auditar.cmd     Generar reporte diff
  abrir.cmd       Abrir en VS Code
  init.cmd        Re-bootstrap (raro, solo si rompes algo)


ACTUALIZAR EL KIT (cuando hay version nueva)
------------------------------------------------------------
  npm install -g forgegit@latest

  En cada proyecto existente:
  forge update


PUBLICAR NUEVA VERSION DEL KIT (yo, autor)
------------------------------------------------------------
  cd E:\MASTER\Proyectos\2026\Toolkit\Sys\forgeGit

  1. Editar config.cmd y subir version (ej: 1.2.0 -> 1.3.0)
  2. guardar.cmd      (mensaje: release 1.3.0)
  3. subir.cmd
  4. npm publish
  5. tools\pack.cmd   (regenera dist)
  6. git tag -a v1.3.0 -m "Version 1.3.0"
  7. git push origin --tags
  8. Subir ZIP a GitHub Releases


LINKS UTILES
------------------------------------------------------------
  Repo:      https://github.com/vloitz/forgeGit
  npm:       https://www.npmjs.com/package/forgegit
  Releases:  https://github.com/vloitz/forgeGit/releases

============================================================
'@

$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText("$PWD\MANUAL.txt", $content, $utf8)

Write-Host "  [OK] MANUAL.txt creado" -ForegroundColor Green
Write-Host ""
Get-Item "MANUAL.txt" | Select-Object Name, Length