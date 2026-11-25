# ============================================================================
# SCRIPT 02 - Limpar nomes de músicas
# - Remove número no início (ex: "01-", "02 -", "14 -")
# - Remove tudo depois do primeiro hífen (fica só o nome da música)
# - Trata conflitos adicionando sufixo (1), (2)...
# ============================================================================
$raiz = "D:\Musicas"

$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Sort-Object FullName

$renomeados = 0
$semMudanca = 0
$falharam = 0

foreach ($arquivo in $arquivos) {
    $nomeAntigo = $arquivo.Name
    $diretorio = $arquivo.DirectoryName
    $novo = $nomeAntigo

    # 1. Remove número no início + hífen
    $novo = $novo -replace '^\s*\d+\s*[-]\s*', ''
    # 2. Remove número no início + espaço
    $novo = $novo -replace '^\s*\d+\s+', ''
    # 3. Remove tudo depois do primeiro hífen (fica só o nome da música)
    if ($novo -match '-') {
        $novo = ($novo -split '-', 2)[0]
    }
    # 4. Limpa bordas e espaços múltiplos
    $novo = $novo -replace '^[\s\-._]+|[\s\-._]+$', ''
    $novo = $novo -replace '\s+', ' '
    $novo = $novo.Trim()

    if ($novo -eq $nomeAntigo) {
        $semMudanca++
        continue
    }

    $caminhoFinal = Join-Path $diretorio $novo
    $suffix = 1

    while (Test-Path -LiteralPath $caminhoFinal) {
        $semExt = [System.IO.Path]::GetFileNameWithoutExtension($novo)
        $ext = [System.IO.Path]::GetExtension($novo)
        $caminhoFinal = Join-Path $diretorio ($semExt + " (" + $suffix + ")" + $ext)
        $suffix++
    }

    try {
        Rename-Item -Path $arquivo.FullName -NewName (Split-Path $caminhoFinal -Leaf) -ErrorAction Stop
        $renomeados++
        Write-Host ("OK: " + $nomeAntigo + " -> " + (Split-Path $caminhoFinal -Leaf)) -ForegroundColor Green
    } catch {
        $falharam++
        Write-Host ("FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Total renomeados: " + $renomeados) -ForegroundColor Cyan
Write-Host ("Sem mudança: " + $semMudanca) -ForegroundColor Gray
Write-Host ("Falharam: " + $falharam) -ForegroundColor Red
Write-Host "Músicas concluídas." -ForegroundColor Green
