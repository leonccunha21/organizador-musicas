$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }
$pasta = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -like "PISEIRO*" } | Select-Object -First 1
if ($pasta) {
    Write-Host ("Encontrada: " + $pasta.Name) -ForegroundColor Yellow
    $novo = "Piseiro Paredão"
    $caminhoNovo = Join-Path $pasta.Parent.FullName $novo
    if (-not (Test-Path -LiteralPath $caminhoNovo)) {
        Rename-Item -Path $pasta.FullName -NewName $novo -Force
        Write-Host ("Renomeado: " + $pasta.Name + " -> " + $novo) -ForegroundColor Green
    } else {
        Write-Host ("Ja existe: " + $novo) -ForegroundColor Yellow
    }
} else {
    Write-Host "Pasta PISEIRO nao encontrada" -ForegroundColor Red
}
Write-Host "Concluido." -ForegroundColor Green
