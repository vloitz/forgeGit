param([string]$NewVersion)

$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

$configPath = '.forge\config.cmd'
$config = Get-Content -LiteralPath $configPath -Raw

if ($config -notmatch 'FG_VERSION=([\d\.]+)') {
    Write-Host '  [X] No se pudo leer FG_VERSION de .forge\config.cmd'
    exit 1
}
$oldVersion = $Matches[1]

if (-not $NewVersion) {
    $parts = $oldVersion -split '\.'
    $parts[2] = [int]$parts[2] + 1
    $NewVersion = $parts -join '.'
}

Write-Host ''
Write-Host '  ============================================'
Write-Host '   Bump Version - forgeGit'
Write-Host '  ============================================'
Write-Host ''
Write-Host "   Version actual: $oldVersion"
Write-Host "   Version nueva:  $NewVersion"
Write-Host ''

$utf8 = New-Object System.Text.UTF8Encoding($false)
$updated = 0
$skipped = 0
$missing = 0

$targets = @(
    @{ Path = $configPath; Pattern = 'FG_VERSION=[\d\.]+'; Repl = "FG_VERSION=$NewVersion" },
    @{ Path = 'README.md'; Pattern = 'Version: [\d\.]+'; Repl = "Version: $NewVersion" },
    @{ Path = 'tests\test.cmd'; Pattern = 'Tests v[\d\.]+'; Repl = "Tests v$NewVersion" },
    @{ Path = 'tools\pack.cmd'; Pattern = 'limpia \(v[\d\.]+\)'; Repl = "limpia (v$NewVersion)" },
    @{ Path = 'tools\release.cmd'; Pattern = 'comprimir \(v[\d\.]+\)'; Repl = "comprimir (v$NewVersion)" },
    @{ Path = 'WORKFLOW.md'; Pattern = 'commands/\s+7 helpers'; Repl = 'commands/          8 helpers' }
)

foreach ($t in $targets) {
    if (-not (Test-Path $t.Path)) {
        Write-Host "  [X] $($t.Path) - no existe"
        $missing++
        continue
    }
    $content = Get-Content -LiteralPath $t.Path -Raw
    $newContent = $content -replace $t.Pattern, $t.Repl
    if ($content -eq $newContent) {
        Write-Host "  [--] $($t.Path) - sin cambios"
        $skipped++
    }
    else {
        [System.IO.File]::WriteAllText((Resolve-Path $t.Path), $newContent, $utf8)
        Write-Host "  [OK] $($t.Path)"
        $updated++
    }
}

Write-Host ''
Write-Host '   Actualizando package.json...'
& npm version $NewVersion --no-git-tag-version --allow-same-version 2>$null | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host '  [OK] package.json actualizado'
}
else {
    Write-Host '  [!] npm version fallo, verifica manualmente'
}

Write-Host ''
Write-Host '  ============================================'
Write-Host "   Bump completado: $oldVersion -> $NewVersion"
Write-Host '  ============================================'
Write-Host ''
Write-Host "   Actualizados: $updated | Sin cambios: $skipped | Faltantes: $missing"
Write-Host ''
Write-Host '   Siguiente:'
Write-Host '     .\forge.cmd save'
Write-Host '     .\forge.cmd push'
Write-Host '     npm publish'
Write-Host ''