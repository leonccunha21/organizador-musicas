# ============================================================================
# SCRIPT 08 - Padronizar maiúsculas (Title Case)
# - Pastas: só o nome do cantor, primeira letra de cada palavra maiúscula
# - Músicas: só o nome da música, primeira letra de cada palavra maiúscula
# - Ignora a pasta Scripts
# - Trata conflitos com sufixo (1), (2)...
# ============================================================================
$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

function Converter-TitleCase {
    param($texto)
    # Divide por espaços, deixa primeira letra de cada palavra maiúscula, resto minúsculo
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

# ---------- 1. PASTAS ----------
$pastas = Get-ChildItem -Path $raiz -Directory | Where-Object { $_.Name -ne "Scripts" } | Sort-Object FullName -Descending

$renomeadasP = 0
$falharamP = 0

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
        Rename-Item -Path $pasta.FullName -NewName (Split-Path $caminhoFinal -Leaf) -ErrorAction Stop
        $renomeadasP++
        Write-Host ("PASTA OK: " + $nomeAntigo + " -> " + (Split-Path $caminhoFinal -Leaf)) -ForegroundColor Green
    } catch {
        $falharamP++
        Write-Host ("PASTA FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

# ---------- 2. MÚSICAS ----------
$extensoesValidas = @('.mp3', '.wma', '.m4a', '.wav', '.flac', '.ogg', '.aac')
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { 
    $extensoesValidas -contains $_.Extension.ToLower() -and 
    $_.DirectoryName -notlike "*\Scripts" 
} | Sort-Object FullName

$renomeadosA = 0
$falharamA = 0

foreach ($arquivo in $arquivos) {
    $nomeAntigo = $arquivo.Name
    $diretorio = $arquivo.DirectoryName
    $ext = [System.IO.Path]::GetExtension($nomeAntigo)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($nomeAntigo)

    $novo = Converter-TitleCase $semExt + $ext

    if ($novo -eq $nomeAntigo) { continue }

    $caminhoFinal = Join-Path $diretorio $novo
    $suffix = 1

    while (Test-Path -LiteralPath $caminhoFinal) {
        $semExtNovo = [System.IO.Path]::GetFileNameWithoutExtension($novo)
        $extNovo = [System.IO.Path]::GetExtension($novo)
        $caminhoFinal = Join-Path $diretorio ($semExtNovo + " (" + $suffix + ")" + $extNovo)
        $suffix++
    }

    try {
        Rename-Item -Path $arquivo.FullName -NewName (Split-Path $caminhoFinal -Leaf) -ErrorAction Stop
        $renomeadosA++
        Write-Host ("ARQUIVO OK: " + $nomeAntigo + " -> " + (Split-Path $caminhoFinal -Leaf)) -ForegroundColor Green
    } catch {
        $falharamA++
        Write-Host ("ARQUIVO FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Pastas renomeadas: " + $renomeadasP) -ForegroundColor Cyan
Write-Host ("Pastas falharam: " + $falharamP) -ForegroundColor Red
Write-Host ("Arquivos renomeados: " + $renomeadosA) -ForegroundColor Cyan
Write-Host ("Arquivos falharam: " + $falharamA) -ForegroundColor Red
Write-Host "Padronização concluída." -ForegroundColor Green
