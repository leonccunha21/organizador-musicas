# ============================================================================
# SCRIPT 10 - Aplicar Title Case nos arquivos restantes
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

$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { $_.DirectoryName -notlike "*\Scripts" } | Sort-Object FullName

$renomeados = 0
$semMudanca = 0
$falharam = 0

foreach ($arquivo in $arquivos) {
    $nomeAntigo = $arquivo.Name
    $diretorio = $arquivo.DirectoryName
    $ext = [System.IO.Path]::GetExtension($nomeAntigo)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($nomeAntigo)

    $novoNome = Converter-TitleCase $semExt
    $novo = $novoNome + $ext

    if ($novo -eq $nomeAntigo) {
        $semMudanca++
        continue
    }

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
        $renomeados++
        Write-Host ("OK: " + $nomeAntigo + " -> " + (Split-Path $caminhoFinal -Leaf)) -ForegroundColor Green
    } catch {
        $falharam++
        Write-Host ("FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Arquivos renomeados: " + $renomeados) -ForegroundColor Cyan
Write-Host ("Sem mudança: " + $semMudanca) -ForegroundColor Gray
Write-Host ("Falharam: " + $falharam) -ForegroundColor Red
Write-Host "Title Case concluído." -ForegroundColor Green
