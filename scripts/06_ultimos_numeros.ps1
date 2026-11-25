# ============================================================================
# SCRIPT 06 - Últimos números restantes
# - Trata os 2 casos específicos: "19-..." e "048 - ..."
# - Ignora pasta Scripts
# ============================================================================
$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { $_.DirectoryName -notlike "*\Scripts" } | Where-Object { $_.Name -match '^\s*(\d+)\s*[-]\s*' } | Sort-Object FullName

$renomeados = 0
$falharam = 0

foreach ($arquivo in $arquivos) {
    $nomeAntigo = $arquivo.Name
    $diretorio = $arquivo.DirectoryName
    $novo = $nomeAntigo

    # Remove número + hífen no início
    $novo = $novo -replace '^\s*\d+\s*[-]\s*', ''

    # Remove tudo depois do primeiro hífen (fica só o nome da música)
    if ($novo -match '-') {
        $novo = ($novo -split '-', 2)[0]
    }

    $novo = $novo -replace '^[\s\-._]+|[\s\-._]+$', ''
    $novo = $novo -replace '\s+', ' '
    $novo = $novo.Trim()

    if ($novo -eq $nomeAntigo -or $novo.Length -eq 0) { continue }

    $caminhoFinal = Join-Path $diretorio $novo
    $suffix = 1

    while (Test-Path -LiteralPath $caminhoFinal) {
        $semExt = [System.IO.Path]::GetFileNameWithoutExtension($novo)
        $ext = [System.IO.Path]::GetExtension($novo)
        $caminhoFinal = Join-Path $diretorio ($semExt + " (" + $suffix + ")" + $ext)
        $suffix++
    }

    try {
        Rename-Item -Path $arquivo.FullName -NewName (Split-Path $caminhoFinal -Leaf) -ErrorAction Stop
        $renomeados++
        Write-Host ("OK: " + $nomeAntigo + " -> " + (Split-Path $caminhoFinal -Leaf)) -ForegroundColor Green
    } catch {
        $falharam++
        Write-Host ("FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Total renomeados: " + $renomeados) -ForegroundColor Cyan
Write-Host ("Falharam: " + $falharam) -ForegroundColor Red
Write-Host "Concluído." -ForegroundColor Green
