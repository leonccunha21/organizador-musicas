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

Write-Host "=== PASTAS QUE PRECISAM DE AJUSTE ===" -ForegroundColor Cyan
$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" }
$contP = 0
foreach ($pasta in $pastas) {
    $novo = Converter-TitleCase $pasta.Name
    if ($novo -ne $pasta.Name) {
        Write-Host ("  " + $pasta.Name + " -> " + $novo) -ForegroundColor Yellow
        $contP++
    }
}
Write-Host ("Total pastas a ajustar: " + $contP) -ForegroundColor Cyan

Write-Host ""
Write-Host "=== ARQUIVOS QUE PRECISAM DE AJUSTE (primeiros 30) ===" -ForegroundColor Cyan
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { $_.DirectoryName -notlike "*\Scripts" }
$contA = 0
$mostrados = 0
foreach ($arquivo in $arquivos) {
    $ext = [System.IO.Path]::GetExtension($arquivo.Name)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($arquivo.Name)
    $novo = Converter-TitleCase $semExt + $ext
    if ($novo -ne $arquivo.Name) {
        if ($mostrados -lt 30) {
            Write-Host ("  " + $arquivo.Name + " -> " + $novo) -ForegroundColor Yellow
            $mostrados++
        }
        $contA++
    }
}
Write-Host ("Total arquivos a ajustar: " + $contA) -ForegroundColor Cyan
