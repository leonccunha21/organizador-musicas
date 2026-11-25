# ============================================================================
# SCRIPT 03 - Remover músicas duplicadas
# - Normaliza nomes (minúsculo, sem acento, sem espaços extras)
# - Agrupa arquivos com mesmo nome normalizado
# - Mantém 1 cópia, remove as duplicatas para economizar espaço
# ============================================================================
$raiz = "D:\Musicas"
$modoPreview = $false  # $true = só mostra o que faria, $false = executa

function Normalizar-Nome {
    param($nome)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($nome)
    $ext = [System.IO.Path]::GetExtension($nome)

    # Minúsculo
    $s = $semExt.ToLower()
    # Remove acentos comuns
    $map = @{
        'á'='a'; 'à'='a'; 'â'='a'; 'ã'='a'; 'ä'='a'; 'å'='a';
        'é'='e'; 'ê'='e'; 'ë'='e';
        'í'='i'; 'î'='i'; 'ï'='i';
        'ó'='o'; 'ô'='o'; 'õ'='o'; 'ö'='o';
        'ú'='u'; 'û'='u'; 'ü'='u';
        'ç'='c';
        'ñ'='n';
        ' '=''; '-'=''; '_'=''; '('=''; ')'=''; '['=''; ']'=''; '.'=''; ','=''; "'"=''; '’'=''; '`'=''; '´'=''; '~'=''
    }
    foreach ($k in $map.Keys) {
        $s = $s -replace [regex]::Escape($k), $map[$k]
    }
    # Colapsa espaços e remove vazios
    $s = $s -replace '\s+', ''
    return $s + $ext
}

$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Sort-Object FullName

$grupos = @{}

foreach ($arquivo in $arquivos) {
    $chave = Normalizar-Nome $arquivo.Name
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

Write-Host "=== PR�-VISUALIZA��O DE DUPLICATAS ===" -ForegroundColor Cyan
Write-Host ""

$totalRemover = 0
$contador = 0

foreach ($chave in ($duplicatas.Keys | Sort-Object)) {
    $membros = $duplicatas[$chave]
    $totalRemover += ($membros.Count - 1)
    $contador++

    if ($contador -le 30) {
        Write-Host ("GRUPO: " + $chave) -ForegroundColor Yellow
        for ($i = 0; $i -lt $membros.Count; $i++) {
            $marcador = if ($i -eq 0) { "MANT�M" } else { "REMOVE" }
            $cor = if ($i -eq 0) { "Green" } else { "Red" }
            Write-Host ("    [" + $marcador + "] " + $membros[$i].Name) -ForegroundColor $cor
        }
        Write-Host ""
    }
}

if ($duplicatas.Count -gt 30) {
    Write-Host ("... e mais " + ($duplicatas.Count - 30) + " grupos n�o mostrados") -ForegroundColor Gray
    Write-Host ""
}

Write-Host ("Total de grupos duplicados: " + $duplicatas.Count) -ForegroundColor Cyan
Write-Host ("Total de arquivos a remover: " + $totalRemover) -ForegroundColor Cyan
Write-Host ("Modo preview: " + $modoPreview) -ForegroundColor Cyan

if (-not $modoPreview) {
    $removidos = 0
    foreach ($chave in ($duplicatas.Keys | Sort-Object)) {
        $membros = $duplicatas[$chave]
        for ($i = 1; $i -lt $membros.Count; $i++) {
            try {
                Remove-Item -Path $membros[$i].FullName -Force -ErrorAction Stop
                $removidos++
            } catch {
                Write-Host ("FALHOU: " + $membros[$i].Name) -ForegroundColor DarkRed
            }
        }
    }
    Write-Host ("Total removidos: " + $removidos) -ForegroundColor Cyan
    Write-Host "Duplicatas conclu�das." -ForegroundColor Green
} else {
    Write-Host "Para executar de verdade, defina \$modoPreview = $false" -ForegroundColor Gray
}
