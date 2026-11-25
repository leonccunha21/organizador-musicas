# ============================================================================
# SCRIPT 01 - Limpar nomes de pastas
# - Remove número no início (ex: "11-", "12 -")
# - Remove ano no final (ex: "-2024", " 2026", "2K25")
# - Remove tudo depois do primeiro hífen (fica só o nome do cantor)
# - Mescla pastas com mesmo nome em 1 só
# ============================================================================
$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }
$modoPreview = $false   # $true = só mostra o que faria, $false = executa

$itens = Get-ChildItem -Path $raiz -Directory | Sort-Object Name

$grupos = @{}

foreach ($item in $itens) {
    $nome = $item.Name

    # 1. Remove número no início + hífen/espaço
    $novo = $nome -replace '^\s*\d+\s*[-]\s*', ''
    # 2. Remove número no início + espaço
    $novo = $novo -replace '^\s*\d+\s+', ''
    # 3. Remove ano no final (19xx ou 20xx)
    $novo = $novo -replace '[\s\-._]*(?:19|20)\d{2}\s*$', ''
    # 4. Remove 2Kxx no final
    $novo = $novo -replace '[\s\-._]*2K\d{2}\s*$', ''
    # 5. Remove tudo depois do primeiro hífen (fica só o cantor)
    if ($novo -match '-') {
        $novo = ($novo -split '-', 2)[0]
    }
    # 6. Limpa bordas e espaços múltiplos
    $novo = $novo -replace '^[\s\-._]+|[\s\-._]+$', ''
    $novo = $novo -replace '\s+', ' '
    $novo = $novo.Trim()

    if (-not $grupos.ContainsKey($novo)) {
        $grupos[$novo] = @()
    }
    $grupos[$novo] += $item
}

Write-Host "=== PRÉ-VISUALIZAÇÃO DE PASTAS ===" -ForegroundColor Cyan
Write-Host ""

$totalRenomear = 0
$totalMesclar = 0

foreach ($base in ($grupos.Keys | Sort-Object)) {
    $membros = $grupos[$base]

    if ($membros.Count -gt 1) {
        $totalMesclar++
        Write-Host ("MESCLAR EM: '" + $base + "'") -ForegroundColor Yellow
        foreach ($m in $membros) {
            Write-Host ("    + " + $m.Name)
        }
        Write-Host ""
    }
    else {
        $unico = $membros[0]
        if ($unico.Name -ne $base) {
            $totalRenomear++
            Write-Host ("RENOMEAR: '" + $unico.Name + "' -> '" + $base + "'") -ForegroundColor Green
        }
    }
}

Write-Host ("Pastas a renomear: " + $totalRenomear) -ForegroundColor Cyan
Write-Host ("Grupos a mesclar: " + $totalMesclar) -ForegroundColor Cyan
Write-Host ("Modo preview: " + $modoPreview) -ForegroundColor Cyan

if (-not $modoPreview) {
    foreach ($base in ($grupos.Keys | Sort-Object)) {
        $membros = $grupos[$base]
        $membroPrincipal = $membros[0]
        $caminhoPrincipal = Join-Path $raiz $base

        # Renomeia a pasta principal se necessário
        if ($membroPrincipal.Name -ne $base) {
            Rename-Item -Path $membroPrincipal.FullName -NewName $base -ErrorAction Stop
            Write-Host ("RENOMEADO: '" + $membroPrincipal.Name + "' -> '" + $base + "'") -ForegroundColor Green
        }

        # Mescla as demais pastas na principal
        for ($i = 1; $i -lt $membros.Count; $i++) {
            $origem = $membros[$i]
            $caminhoOrigem = $origem.FullName

            # Move tudo dentro da origem para a principal
            Get-ChildItem -Path $caminhoOrigem -Recurse | ForEach-Object {
                if ($_.PSIsContainer) {
                    $relativo = $_.FullName.Substring($caminhoOrigem.Length)
                    $destino = Join-Path $caminhoPrincipal $relativo
                    if (-not (Test-Path $destino)) {
                        New-Item -ItemType Directory -Path $destino | Out-Null
                    }
                }
                else {
                    $relativo = $_.FullName.Substring($caminhoOrigem.Length)
                    $destino = Join-Path $caminhoPrincipal $relativo
                    $destinoDir = Split-Path $destino -Parent
                    if (-not (Test-Path $destinoDir)) {
                        New-Item -ItemType Directory -Path $destinoDir | Out-Null
                    }
                    if (Test-Path -LiteralPath $destino) {
                        $ext = [System.IO.Path]::GetExtension($_.Name)
                        $semExt = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
                        $destino = Join-Path $destinoDir ($semExt + "_dup" + $ext)
                    }
                    Move-Item -Path $_.FullName -Destination $destino -Force
                }
            }

            Remove-Item -Path $caminhoOrigem -Recurse -Force
            Write-Host ("MESCLADO: '" + $origem.Name + "' em '" + $base + "'") -ForegroundColor Green
        }
    }
    Write-Host "Pastas concluídas." -ForegroundColor Green
} else {
    Write-Host "Para executar de verdade, defina \$modoPreview = $false" -ForegroundColor Gray
}
