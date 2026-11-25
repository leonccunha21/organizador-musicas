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

$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" }
foreach ($p in $pastas) {
    $tc = Converter-TitleCase $p.Name
    if ($tc -cne $p.Name) {
        Write-Host ("NAO TITLE CASE: " + $p.Name + " -> " + $tc) -ForegroundColor Yellow
    }
}

Write-Host "Verificacao concluida." -ForegroundColor Green
