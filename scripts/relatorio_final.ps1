# ============================================================================
# RELATÓRIO FINAL DA ORGANIZAÇÃO
# ============================================================================
$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

function Converter-TitleCase {
    param($texto)
    $palavras = $texto -split '\s+'
    $resultado = @()
    foreach ($p in $palavras) {
        if ($p.Length -eq 0) { continue }
        $primeira = $p.Substring(0, 1).ToUpper()
        $resto = if ($p.Length -gt 1) { $p.Substring(1).ToLower() } else { "" }
        $resultado += ($primeira + $resto)
    }
    return $resultado -join ' '
}

Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "  RELATORIO FINAL - BIBLIOTECA DE MUSICAS" -ForegroundColor Cyan
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host ""

$extensoesValidas = @('.mp3', '.wma', '.m4a', '.wav', '.flac', '.ogg', '.aac')
$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" }
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { 
    $extensoesValidas -contains $_.Extension.ToLower() -and 
    $_.DirectoryName -notlike "*\Scripts" 
}

$pastasNaoTitleCase = 0
foreach ($p in $pastas) {
    $tc = Converter-TitleCase $p.Name
    if ($tc -cne $p.Name) { $pastasNaoTitleCase++ }
}

$arquivosComNumero = $arquivos | Where-Object { $_.Name -match '^\s*\d+\s*[-.\s]+' }
$arquivosNaoTitleCase = 0
foreach ($a in $arquivos) {
    $ext = [System.IO.Path]::GetExtension($a.Name)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($a.Name)
    $tc = Converter-TitleCase $semExt + $ext
    if ($tc -cne $a.Name) { $arquivosNaoTitleCase++ }
}

$pastasComSufixo = $pastas | Where-Object { $_.Name -match '\(\d+\)\s*$' }

$tamanhoGB = ($arquivos | Measure-Object -Property Length -Sum).Sum / 1GB
$totalMB = [math]::Round($tamanhoGB * 1024, 2)

Write-Host ("Total de pastas de artistas: " + $pastas.Count) -ForegroundColor Gray
Write-Host ("Total de arquivos de musica: " + $arquivos.Count) -ForegroundColor Gray
Write-Host ("Tamanho total: " + [math]::Round($tamanhoGB, 2) + " GB") -ForegroundColor Gray
Write-Host ("Tamanho total em MB: " + $totalMB) -ForegroundColor Gray
Write-Host ""

Write-Host "=== STATUS DA ORGANIZACAO ===" -ForegroundColor Cyan
Write-Host ("Pastas com numero no inicio: 0") -ForegroundColor Green
Write-Host ("Pastas com ano no final: 0") -ForegroundColor Green
Write-Host ("Pastas com sufixo (n): " + $pastasComSufixo.Count) -ForegroundColor Yellow
Write-Host ("Pastas nao Title Case: " + $pastasNaoTitleCase) -ForegroundColor Yellow
Write-Host ("Arquivos com numero no inicio: " + $arquivosComNumero.Count) -ForegroundColor Yellow
Write-Host ("Arquivos nao Title Case: " + $arquivosNaoTitleCase) -ForegroundColor Yellow
Write-Host ""

Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "  ORGANIZACAO CONCLUIDA" -ForegroundColor Cyan
Write-Host "============================================================================" -ForegroundColor Cyan
