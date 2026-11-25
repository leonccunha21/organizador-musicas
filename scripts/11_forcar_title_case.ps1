# ============================================================================
# SCRIPT 11 - Forçar Title Case (resolver conflitos)
# - Aplica Title Case mesmo se já existir, adicionando (1), (2)...
# - Ignora pasta Scripts
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

$extensoesValidas = @('.mp3', '.wma', '.m4a', '.wav', '.flac', '.ogg', '.aac')
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { 
    $extensoesValidas -contains $_.Extension.ToLower() -and 
    $_.DirectoryName -notlike "*\Scripts" 
} | Sort-Object FullName

$renomeados = 0
$falharam = 0

foreach ($arquivo in $arquivos) {
    $nomeAntigo = $arquivo.Name
    $diretorio = $arquivo.DirectoryName
    $ext = [System.IO.Path]::GetExtension($nomeAntigo)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($nomeAntigo)

    $novoNome = Converter-TitleCase $semExt
    $novo = $novoNome + $ext

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
        Rename-Item -Path $arquivo.FullName -NewName (Split-Path $caminhoFinal -Leaf) -ErrorAction Stop -Force
        $renomeados++
        Write-Host ("OK: " + $nomeAntigo + " -> " + (Split-Path $caminhoFinal -Leaf)) -ForegroundColor Green
    } catch {
        $falharam++
        Write-Host ("FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Arquivos renomeados: " + $renomeados) -ForegroundColor Cyan
Write-Host ("Falharam: " + $falharam) -ForegroundColor Red
Write-Host "Title Case forçado concluído." -ForegroundColor Green
