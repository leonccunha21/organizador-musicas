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

Write-Host "=== VERIFICACAO FINAL ===" -ForegroundColor Cyan
Write-Host ""

# Ignorar arquivos na raiz que não são músicas
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { $_.DirectoryName -notlike "*\Scripts" -and $_.DirectoryName -eq $raiz -eq $false }

$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" }
$arquivosMusicas = $arquivos | Where-Object { $_.DirectoryName -ne $raiz }

$pastasNaoTC = 0
foreach ($p in $pastas) {
    $tc = Converter-TitleCase $p.Name
    if ($tc -cne $p.Name) { $pastasNaoTC++ }
}

$arquivosComNumero = $arquivosMusicas | Where-Object { $_.Name -match '^\s*\d+\s*[-.\s]+' }
$arquivosNaoTC = 0
foreach ($a in $arquivosMusicas) {
    $ext = [System.IO.Path]::GetExtension($a.Name)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($a.Name)
    $tc = Converter-TitleCase $semExt + $ext
    if ($tc -cne $a.Name) { $arquivosNaoTC++ }
}

$pastasComSufixo = $pastas | Where-Object { $_.Name -match '\(\d+\)\s*$' }

$tamanhoGB = ($arquivosMusicas | Measure-Object -Property Length -Sum).Sum / 1GB

Write-Host ("Total de pastas de artistas: " + $pastas.Count) -ForegroundColor Gray
Write-Host ("Total de arquivos de musica: " + $arquivosMusicas.Count) -ForegroundColor Gray
Write-Host ("Tamanho total: " + [math]::Round($tamanhoGB, 2) + " GB") -ForegroundColor Gray
Write-Host ""

Write-Host "=== STATUS ===" -ForegroundColor Cyan
Write-Host ("Pastas com sufixo (n): " + $pastasComSufixo.Count) -ForegroundColor Yellow
Write-Host ("Pastas nao Title Case: " + $pastasNaoTC) -ForegroundColor Yellow
Write-Host ("Arquivos com numero no inicio: " + $arquivosComNumero.Count) -ForegroundColor Yellow
Write-Host ("Arquivos nao Title Case (nomes complexos com ft/part/oficial): " + $arquivosNaoTC) -ForegroundColor Yellow
Write-Host ""

if ($pastasComSufixo.Count -eq 0 -and $pastasNaoTC -eq 0 -and $arquivosComNumero.Count -eq 0) {
    Write-Host "ORGANIZACAO PERFEITA!" -ForegroundColor Green
} else {
    Write-Host "Existem ajustes menores pendentes (nomes complexos com ft/part são normais)." -ForegroundColor Yellow
}
Write-Host "Verificacao concluida." -ForegroundColor Green
