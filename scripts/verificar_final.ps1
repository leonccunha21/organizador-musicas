# ============================================================================
# SCRIPT DE VERIFICAÇÃO FINAL
# ============================================================================
$raiz = "D:\Musicas"

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

Write-Host "=== VERIFICAÇÃO FINAL ===" -ForegroundColor Cyan
Write-Host ""

$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" }
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { $_.DirectoryName -notlike "*\Scripts" }

$pastasNaoTitleCase = @()
foreach ($p in $pastas) {
    $tc = Converter-TitleCase $p.Name
    if ($tc -cne $p.Name) { $pastasNaoTitleCase += $p.Name }
}

$arquivosComNumero = $arquivos | Where-Object { $_.Name -match '^\s*\d+\s*[-.\s]+' }
$arquivosNaoTitleCase = @()
foreach ($a in $arquivos) {
    $ext = [System.IO.Path]::GetExtension($a.Name)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($a.Name)
    $tc = Converter-TitleCase $semExt + $ext
    if ($tc -cne $a.Name) { $arquivosNaoTitleCase += $a.Name }
}

Write-Host ("Total de pastas: " + $pastas.Count) -ForegroundColor Gray
Write-Host ("Pastas não Title Case: " + $pastasNaoTitleCase.Count) -ForegroundColor Yellow
foreach ($p in $pastasNaoTitleCase) { Write-Host ("  - " + $p) -ForegroundColor Yellow }

Write-Host ""
Write-Host ("Total de arquivos: " + $arquivos.Count) -ForegroundColor Gray
Write-Host ("Arquivos com número no início: " + $arquivosComNumero.Count) -ForegroundColor Yellow
foreach ($a in $arquivosComNumero | Select-Object -First 20) {
    Write-Host ("  - " + $a.Name) -ForegroundColor Yellow
}
Write-Host ("Arquivos não Title Case: " + $arquivosNaoTitleCase.Count) -ForegroundColor Yellow
foreach ($a in $arquivosNaoTitleCase | Select-Object -First 20) {
    Write-Host ("  - " + $a) -ForegroundColor Yellow
}

$tamanhoGB = ($arquivos | Measure-Object -Property Length -Sum).Sum / 1GB
Write-Host ""
Write-Host ("Tamanho total: " + [math]::Round($tamanhoGB, 2) + " GB") -ForegroundColor Cyan
Write-Host "Verificação concluída." -ForegroundColor Green
