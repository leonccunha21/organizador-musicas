# ============================================================================
# SCRIPT 14 - Limpar sufixos órfãos "(n)" quando não há conflito
# - Arquivos: "X (1).mp3" -> "X.mp3" se "X.mp3" não existir
# - Pastas: "X (1)" -> "X" se "X" não existir
# - Ignora pasta Scripts
# ============================================================================
$raiz = if ($env:MUSICA_RAIZ) { $env:MUSICA_RAIZ } else { "D:\Musicas" }

function Remover-SufixoOrfao {
    param($nome)
    $semExt = [System.IO.Path]::GetFileNameWithoutExtension($nome)
    $ext = [System.IO.Path]::GetExtension($nome)
    
    # Verifica se termina com " (número)"
    if ($semExt -match '\(\d+\)\s*$') {
        $base = $semExt -replace '\s*\(\d+\)\s*$', ''
        $nomeSemSufixo = $base + $ext
        return $nomeSemSufixo
    }
    return $null
}

# ---------- ARQUIVOS ----------
$extensoesValidas = @('.mp3', '.wma', '.m4a', '.wav', '.flac', '.ogg', '.aac')
$arquivos = Get-ChildItem -Path $raiz -Recurse -File | Where-Object { 
    $extensoesValidas -contains $_.Extension.ToLower() -and 
    $_.DirectoryName -notlike "*\Scripts" 
} | Sort-Object FullName

$renomeados = 0
$falharam = 0

foreach ($arquivo in $arquivos) {
    $nomeAntigo = $arquivo.Name
    $novo = Remover-SufixoOrfao $nomeAntigo
    
    if (-not $novo) { continue }
    
    $diretorio = $arquivo.DirectoryName
    $caminhoFinal = Join-Path $diretorio $novo
    
    # Só renomeia se não houver conflito
    if (Test-Path -LiteralPath $caminhoFinal) { continue }
    
    try {
        Rename-Item -Path $arquivo.FullName -NewName (Split-Path $caminhoFinal -Leaf) -ErrorAction Stop -Force
        $renomeados++
        Write-Host ("OK: " + $nomeAntigo + " -> " + $novo) -ForegroundColor Green
    } catch {
        $falharam++
        Write-Host ("FALHOU: " + $nomeAntigo) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Arquivos renomeados: " + $renomeados) -ForegroundColor Cyan
Write-Host ("Falhas: " + $falharam) -ForegroundColor Red
Write-Host "Script 14 concluído." -ForegroundColor Green
