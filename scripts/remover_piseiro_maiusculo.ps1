$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

# Remover pasta em maiúsculas "PISEIRO PARED...O"
$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -like "PISEIRO*" }

foreach ($pasta in $pastas) {
    Write-Host ("Encontrada: [" + $pasta.Name + "]") -ForegroundColor Yellow
    if ($pasta.Name -ceq $pasta.Name.ToUpper()) {
        # Está toda em maiúsculas, remover
        Remove-Item -Path $pasta.FullName -Recurse -Force
        Write-Host ("REMOVIDA (maiusculas): " + $pasta.Name) -ForegroundColor Red
    } else {
        Write-Host ("MANTIDA (Title Case): " + $pasta.Name) -ForegroundColor Green
    }
}

Write-Host "Concluido." -ForegroundColor Green
