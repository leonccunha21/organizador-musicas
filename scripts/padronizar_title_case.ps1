# ============================================================================
# SCRIPT DE PADRONIZAÇÃO DE NOMES (TITLE CASE)
# - Converte nomes de arquivos para Title Case (primeira letra maiúscula, resto minúsculo)
# - Preserva IDs de disco do OPL / PS2 (ex: SLUS_xxx.xx., SLES_xxx.xx.)
# - Converte extensão para minúsculo (.iso, .bin, etc.)
# - Remove espaços duplos ou extras
# - Ignora pastas de capas (ART) e de scripts
# - Trata conflitos adicionando sufixo (1), (2)...
# - Modo Preview disponível (-Preview)
# ============================================================================
param(
    [string]$caminho,
    [switch]$Preview
)

if (-not $caminho) {
    if ($env:PASTA_TRABALHO) { $caminho = $env:PASTA_TRABALHO }
    elseif ($env:MUSICA_RAIZ) { $caminho = $env:MUSICA_RAIZ }
    elseif (Test-Path "D:\Jogos\PS2\OPL\DVD") { $caminho = "D:\Jogos\PS2\OPL\DVD" }
    elseif (Test-Path "D:\Musicas") { $caminho = "D:\Musicas" }
    else { $caminho = $PSScriptRoot }
}

if (-not (Test-Path -LiteralPath $caminho)) {
    Write-Host "Pasta nao encontrada: $caminho" -ForegroundColor Red
    return
}

function Convert-TitleCaseString {
    param([string]$text)
    
    # Divide por espaços e pontuações mantendo delimitadores
    $tokens = [regex]::Split($text, '(\s+|[-_()\[\].,&!+])')
    $result = foreach ($t in $tokens) {
        if ($t -match '^[a-zA-Z0-9áàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ]+$') {
            if ($t -match '^[a-zA-ZáàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ]') {
                $t.Substring(0, 1).ToUpper() + $t.Substring(1).ToLower()
            } else {
                $t
            }
        } else {
            $t
        }
    }
    
    $out = $result -join ''
    $out = $out -replace '\s+', ' '
    return $out.Trim()
}

function Get-StandardizedFileName {
    param([string]$fileName)
    $ext = [System.IO.Path]::GetExtension($fileName).ToLower()
    $base = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    
    # Preserva prefixos OPL (ex: SLUS_123.45. ou SLES_000.00.)
    $prefix = ""
    $title = $base
    if ($base -match '^([A-Za-z]{4}_\d{3}\.\d{2}\.)(.*)$') {
        $prefix = $matches[1].ToUpper()
        $title = $matches[2]
    }
    
    $newTitle = Convert-TitleCaseString $title
    return "$prefix$newTitle$ext"
}

Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "  PADRONIZACAO DE NOMES (TITLE CASE)" -ForegroundColor Cyan
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "Pasta: $caminho" -ForegroundColor Yellow
if ($Preview) {
    Write-Host "MODO SIMULACAO (Nenhum arquivo sera alterado)" -ForegroundColor Magenta
}
Write-Host ""

# Busca arquivos ignorando pastas ART e Scripts
$arquivos = Get-ChildItem -LiteralPath $caminho -Recurse -File | Where-Object {
    $_.DirectoryName -notlike "*\ART*" -and
    $_.DirectoryName -notlike "*\Scripts*"
} | Sort-Object FullName

$renomeados = 0
$semMudanca = 0
$falharam = 0

foreach ($arq in $arquivos) {
    $nomeAntigo = $arq.Name
    $nomeNovo = Get-StandardizedFileName $nomeAntigo
    
    if ($nomeNovo -ceq $nomeAntigo) {
        $semMudanca++
        continue
    }
    
    $dir = $arq.DirectoryName
    $caminhoFinal = Join-Path $dir $nomeNovo
    
    # Se ja existe outro arquivo fisico diferente com esse nome
    if ((Test-Path -LiteralPath $caminhoFinal) -and ((Get-Item -LiteralPath $caminhoFinal).FullName.ToLower() -ne $arq.FullName.ToLower())) {
        $baseNovo = [System.IO.Path]::GetFileNameWithoutExtension($nomeNovo)
        $extNovo = [System.IO.Path]::GetExtension($nomeNovo)
        $suffix = 1
        while (Test-Path -LiteralPath $caminhoFinal) {
            $caminhoFinal = Join-Path $dir ($baseNovo + " (" + $suffix + ")" + $extNovo)
            $suffix++
        }
        $nomeNovo = Split-Path $caminhoFinal -Leaf
    }
    
    if ($Preview) {
        Write-Host "SIMULAÇÃO: $nomeAntigo -> $nomeNovo" -ForegroundColor Yellow
        $renomeados++
        continue
    }
    
    # Renomeação segura em dois passos para garantir que o NTFS aceite a mudança de maiúsculas/minúsculas
    $tempPath = $arq.FullName + ".tmp_rename_" + [guid]::NewGuid().ToString().Substring(0, 8)
    try {
        [System.IO.File]::Move($arq.FullName, $tempPath)
        [System.IO.File]::Move($tempPath, $caminhoFinal)
        $renomeados++
        Write-Host "OK: $nomeAntigo -> $nomeNovo" -ForegroundColor Green
    } catch {
        $falharam++
        Write-Host "FALHOU: $nomeAntigo -> $($_.Exception.Message)" -ForegroundColor Red
        if (Test-Path -LiteralPath $tempPath) {
            try { [System.IO.File]::Move($tempPath, $arq.FullName) } catch {}
        }
    }
}

Write-Host ""
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "Resumo:"
Write-Host "  Arquivos renomeados: $renomeados" -ForegroundColor Green
Write-Host "  Sem mudanca:         $semMudanca" -ForegroundColor Gray
if ($falharam -gt 0) {
    Write-Host "  Falharam:            $falharam" -ForegroundColor Red
}
Write-Host "============================================================================" -ForegroundColor Cyan
