# ============================================================================
# SCRIPT 15 - Remover sufixo "(n)" de pastas quando não há conflito
# - "Abelvolks (1)" -> "Abelvolks" se "Abelvolks" não existir
# - Ignora pasta Scripts
# ============================================================================
$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" -and $_.Name -match '\(\d+\)\s*$' } | Sort-Object Name

$renomeadas = 0
$mantidas = 0
$falharam = 0

foreach ($pasta in $pastas) {
    $nomeAntigo = $pasta.Name
    
    # Remove sufixo " (número)" do final
    $novo = $nomeAntigo -replace '\s*\(\d+\)\s*$', ''
    
    $caminhoNovo = Join-Path $pasta.Parent.FullName $novo
    
    # Se o nome sem sufixo já existe, mantém o (1) (conflito legítimo)
    if (Test-Path -LiteralPath $caminhoNovo) {
        $mantidas++
        Write-Host ("MANTIDA (conflito): " + $nomeAntigo) -ForegroundColor Yellow
        continue
    }
    
    try {
        Rename-Item -Path $pasta.FullName -NewName $novo -ErrorAction Stop -Force
        $renomeadas++
        Write-Host ("OK: " + $nomeAntigo + " -> " + $novo) -ForegroundColor Green
    } catch {
        $falharam++
        Write-Host ("FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Pastas renomeadas: " + $renomeadas) -ForegroundColor Cyan
Write-Host ("Pastas mantidas (conflito): " + $mantidas) -ForegroundColor Yellow
Write-Host ("Falhas: " + $falharam) -ForegroundColor Red
Write-Host "Concluído." -ForegroundColor Green
