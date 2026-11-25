# ============================================================================
# SCRIPT 13 - Corrigir pastas Title Case + remover duplicatas de arquivos
# - Pastas: Title Case com comparação case-sensitive (-ceq)
# - Arquivos: remove duplicatas (ex: "X.mp3" e "X (1).mp3" -> mantém 1)
# ============================================================================
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

# ---------- 1. PASTAS Title Case (case-sensitive) ----------
Write-Host "=== CORRIGINDO PASTAS ===" -ForegroundColor Cyan
$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" } | Sort-Object FullName -Descending

$renomeadasP = 0
$falharamP = 0

foreach ($pasta in $pastas) {
    $nomeAntigo = $pasta.Name
    $novo = Converter-TitleCase $nomeAntigo

    # Comparação case-sensitive (-ceq)
    if ($novo -ceq $nomeAntigo) { continue }

    $caminhoFinal = Join-Path $pasta.Parent.FullName $novo
    $suffix = 1

    while (Test-Path -LiteralPath $caminhoFinal) {
        $caminhoFinal = Join-Path $pasta.Parent.FullName ($novo + " (" + $suffix + ")")
        $suffix++
    }

    try {
        Rename-Item -Path $pasta.FullName -NewName (Split-Path $caminhoFinal -Leaf) -ErrorAction Stop -Force
        $renomeadasP++
        Write-Host ("PASTA OK: " + $nomeAntigo + " -> " + (Split-Path $caminhoFinal -Leaf)) -ForegroundColor Green
    } catch {
        $falharamP++
        Write-Host ("PASTA FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ("Pastas renomeadas: " + $renomeadasP) -ForegroundColor Cyan
Write-Host ("Pastas falharam: " + $falharamP) -ForegroundColor Red

# ---------- 2. REMOVER DUPLICATAS DE ARQUIVOS ----------
Write-Host ""
Write-Host "=== REMOVENDO DUPLICATAS DE ARQUIVOS ===" -ForegroundColor Cyan

function Obter-NomeBase {
    param($nomeComExt)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($nomeComExt)
    $ext = [System.IO.Path]::GetExtension($nomeComExt)
    # Remove sufixo " (número)" antes da extensão
    if ($semExt -match '\(\d+\)\s*$') {
        $semExt = $semExt -replace '\s*\(\d+\)\s*$', ''
    }
    return $semExt.ToLower() + $ext.ToLower()
}

$extensoesValidas = @('.mp3', '.wma', '.m4a', '.wav', '.flac', '.ogg', '.aac')
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { 
    $extensoesValidas -contains $_.Extension.ToLower() -and 
    $_.DirectoryName -notlike "*\Scripts" 
} | Sort-Object FullName

$grupos = @{}
foreach ($arquivo in $arquivos) {
    $chave = Join-Path $arquivo.DirectoryName (Obter-NomeBase $arquivo.Name)
    if (-not $grupos.ContainsKey($chave)) {
        $grupos[$chave] = @()
    }
    $grupos[$chave] += $arquivo
}

$duplicatas = @{}
foreach ($chave in $grupos.Keys) {
    if ($grupos[$chave].Count -gt 1) {
        $duplicatas[$chave] = $grupos[$chave]
    }
}

Write-Host ("Grupos duplicados encontrados: " + $duplicatas.Count) -ForegroundColor Cyan

$removidos = 0
$falharamA = 0

foreach ($chave in ($duplicatas.Keys | Sort-Object)) {
    $membros = $duplicatas[$chave]
    # Mantém o primeiro (sem sufixo ou menor caminho), remove os demais
    # Ordena para que o sem "(n)" venha primeiro
    $ordenados = $membros | Sort-Object { $_.Name -match '\(\d+\)\s*\.' }

    for ($i = 1; $i -lt $ordenados.Count; $i++) {
        try {
            Remove-Item -Path $ordenados[$i].FullName -Force -ErrorAction Stop
            $removidos++
            Write-Host ("REMOVIDO: " + $ordenados[$i].Name) -ForegroundColor Red
        } catch {
            $falharamA++
            Write-Host ("FALHOU: " + $ordenados[$i].Name) -ForegroundColor DarkRed
        }
    }
}

Write-Host ("Arquivos duplicados removidos: " + $removidos) -ForegroundColor Cyan
Write-Host ("Falhas: " + $falharamA) -ForegroundColor Red
Write-Host "Script 13 concluído." -ForegroundColor Green
