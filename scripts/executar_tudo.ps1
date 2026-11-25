# ============================================================================
# SCRIPT MESTRE - Executar toda a organização
# Ordem correta: 01 -> 15
# ============================================================================
$raiz = $PSScriptRoot
$pastaMusicas = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

$scripts = @(
    "01_limpar_pastas.ps1",
    "02_limpar_musicas.ps1",
    "03_remover_duplicatas.ps1",
    "04_limpar_numeros_restantes.ps1",
    "05_limpar_final.ps1",
    "06_ultimos_numeros.ps1",
    "07_forcar_ultimos2.ps1",
    "08_padronizar_maiusculas.ps1",
    "09_verificar_padroes.ps1",
    "10_aplicar_title_case.ps1",
    "11_forcar_title_case.ps1",
    "12_corrigir_pastas_title_case.ps1",
    "13_corrigir_tudo.ps1",
    "14_limpar_sufixos_orfaos.ps1",
    "15_remover_sufixo_pastas.ps1"
)

Write-Host "=== SCRIPT MESTRE DE ORGANIZAÇÃO ===" -ForegroundColor Cyan
Write-Host "Pasta: $pastaMusicas"
Write-Host ""

foreach ($s in $scripts) {
    $caminho = Join-Path $raiz $s
    if (Test-Path -LiteralPath $caminho) {
        Write-Host ("Executando: " + $s) -ForegroundColor Cyan
        & $caminho
        Write-Host ""
    } else {
        Write-Host ("NÃO ENCONTRADO: " + $s) -ForegroundColor Red
    }
}

Write-Host "Todos os scripts foram executados." -ForegroundColor Green
