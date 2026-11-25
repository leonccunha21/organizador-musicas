# ============================================================================
# SCRIPT 02 - Limpar nomes de músicas
# - Remove número no início (ex: "01-", "02 -", "14 -")
# - Remove tudo depois do primeiro hífen (fica só o nome da música)
# - Trata conflitos adicionando sufixo (1), (2)...
# - Preserva a extensão original dos arquivos (.mp3, .flac, etc.)
# ============================================================================
$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

$extensoesValidas = @('.mp3', '.wma', '.m4a', '.wav', '.flac', '.ogg', '.aac')
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object {
    $extensoesValidas -contains $_.Extension.ToLower() -and
    $_.DirectoryName -notlike "*\Scripts"
} | Sort-Object FullName

$renomeados = 0
$semMudanca = 0
$falharam = 0

foreach ($arquivo in $arquivos) {
    $nomeAntigo = $arquivo.Name
    $diretorio = $arquivo.DirectoryName
    $ext = $arquivo.Extension
    $nomeBase = [System.IO.Path]::GetFileNameWithoutExtension($nomeAntigo)

    $novoBase = $nomeBase

    # 1. Remove número no início + hífen
    $novoBase = $novoBase -replace '^\s*\d+\s*[-]\s*', ''
    # 2. Remove número no início + espaço
    $novoBase = $novoBase -replace '^\s*\d+\s+', ''
    # 3. Remove tudo depois do primeiro hífen (fica só o nome da música)
    if ($novoBase -match '-') {
        $novoBase = ($novoBase -split '-', 2)[0]
    }
    # 4. Limpa bordas e espaços múltiplos
    $novoBase = $novoBase -replace '^[\s\-._]+|[\s\-._]+$', ''
    $novoBase = $novoBase -replace '\s+', ' '
    $novoBase = $novoBase.Trim()

    $novo = "$novoBase$ext"

    if ($novo -eq $nomeAntigo) {
        $semMudanca++
        continue
    }

    $caminhoFinal = Join-Path $diretorio $novo
    $suffix = 1

    while (Test-Path -LiteralPath $caminhoFinal) {
        $caminhoFinal = Join-Path $diretorio ($novoBase + " (" + $suffix + ")" + $ext)
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
