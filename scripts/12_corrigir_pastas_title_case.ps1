# ============================================================================
# SCRIPT 12 - Corrigir pastas para Title Case
# - Primeira letra de cada palavra maiúscula, resto minúsculo
# - Ignora pasta Scripts
# - Trata conflitos com sufixo (1), (2)...
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

# Coletar todas as pastas primeiro (para não quebrar enumeração ao renomear)
$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" } | Sort-Object FullName -Descending

$renomeadas = 0
$falharam = 0

foreach ($pasta in $pastas) {
    $nomeAntigo = $pasta.Name
    $novo = Converter-TitleCase $nomeAntigo

    if ($novo -eq $nomeAntigo) { continue }

    $caminhoFinal = Join-Path $pasta.Parent.FullName $novo
    $suffix = 1

    while (Test-Path -LiteralPath $caminhoFinal) {
        $caminhoFinal = Join-Path $pasta.Parent.FullName ($novo + " (" + $suffix + ")")
        $suffix++
    }

    try {
        Rename-Item -Path $pasta.FullName -NewName (Split-Path $caminhoFinal -Leaf) -ErrorAction Stop -Force
        $renomeadas++
        Write-Host ("PASTA OK: " + $nomeAntigo + " -> " + (Split-Path $caminhoFinal -Leaf)) -ForegroundColor Green
    } catch {
        $falharam++
        Write-Host ("PASTA FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Pastas renomeadas: " + $renomeadas) -ForegroundColor Cyan
Write-Host ("Pastas falharam: " + $falharam) -ForegroundColor Red
Write-Host "Pastas Title Case concluído." -ForegroundColor Green
