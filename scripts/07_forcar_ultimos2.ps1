$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

# Busca os 2 arquivos específicos
$a1 = Get-ChildItem -Path $raiz -Recurse -File -Filter "19-Can't*" | Select-Object -First 1
$a2 = Get-ChildItem -Path $raiz -Recurse -File -Filter "048 - Kemuel*" | Select-Object -First 1

if ($a1) {
    $novo1 = $a1.Name -replace '^\s*\d+\s*[-]\s*', ''
    $dest1 = Join-Path $a1.DirectoryName $novo1
    if (Test-Path -LiteralPath $dest1) {
        $semExt = [System.IO.Path]::GetFileNameWithoutExtension($novo1)
        $ext = [System.IO.Path]::GetExtension($novo1)
        $dest1 = Join-Path $a1.DirectoryName ($semExt + " (1)" + $ext)
    }
    try { [System.IO.File]::Move($a1.FullName, $dest1); Write-Host ("OK 1: " + $a1.Name + " -> " + (Split-Path $dest1 -Leaf)) -ForegroundColor Green }
    catch { Write-Host ("FALHOU 1: " + $_.Exception.Message) -ForegroundColor Red }
} else { Write-Host "Arquivo 1 não encontrado" -ForegroundColor Red }

if ($a2) {
    $novo2 = $a2.Name -replace '^\s*\d+\s*[-]\s*', ''
    # Remove tudo depois do primeiro hífen
    if ($novo2 -match '-') { $novo2 = ($novo2 -split '-', 2)[0] }
    $novo2 = $novo2.Trim()
    $dest2 = Join-Path $a2.DirectoryName $novo2
    if (Test-Path -LiteralPath $dest2) {
        $semExt = [System.IO.Path]::GetFileNameWithoutExtension($novo2)
        $ext = [System.IO.Path]::GetExtension($novo2)
        $dest2 = Join-Path $a2.DirectoryName ($semExt + " (1)" + $ext)
    }
    try { [System.IO.File]::Move($a2.FullName, $dest2); Write-Host ("OK 2: " + $a2.Name + " -> " + (Split-Path $dest2 -Leaf)) -ForegroundColor Green }
    catch { Write-Host ("FALHOU 2: " + $_.Exception.Message) -ForegroundColor Red }
} else { Write-Host "Arquivo 2 não encontrado" -ForegroundColor Red }

Write-Host "Concluído." -ForegroundColor Green
