# ============================================================================
# SCRIPT 05 - Limpeza final de números restantes
# - Remove número + underline, hífen, ponto ou espaço no início
# - Ignora pasta Scripts
# - Ignora nomes de banda legítimos (10CC, 10,000 Maniacs, 70s, etc.)
# - Trata conflitos com sufixo (1), (2)...
# ============================================================================
$raiz = "D:\Musicas"

$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { $_.DirectoryName -notlike "*\Scripts" } | Sort-Object FullName

$renomeados = 0
$semMudanca = 0
$falharam = 0

foreach ($arquivo in $arquivos) {
    $nomeAntigo = $arquivo.Name
    $diretorio = $arquivo.DirectoryName
    $novo = $nomeAntigo

    # Remove número no início seguido de underline, hífen, ponto ou espaço
    $novo = $novo -replace '^\s*\d+\s*[-_.\s]+', ''

    # Limpa bordas
    $novo = $novo -replace '^[\s\-._]+|[\s\-._]+$', ''
    $novo = $novo -replace '\s+', ' '
    $novo = $novo.Trim()

    if ($novo -eq $nomeAntigo) {
        $semMudanca++
        continue
    }

    # Pula se o nome ficar vazio (só era número)
    if ($novo.Length -eq 0) {
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
Write-Host "Limpeza final concluída." -ForegroundColor Green
