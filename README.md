# 🎵 Organizador de Biblioteca Musical

Projeto de automação para organizar pastas e arquivos de música no Windows usando PowerShell.

## 📁 Estrutura do Projeto

```
organizador-musicas/
├── HUD_Musicas.bat          # Hub interativo (.bat)
├── README.md                # Documentação
├── .gitignore               # Ignora arquivos de áudio no Git
└── scripts/                 # Scripts PowerShell
    ├── executar_tudo.ps1    # Script mestre (executa todos em ordem)
    ├── 01_limpar_pastas.ps1
    ├── 02_limpar_musicas.ps1
    ├── 03_remover_duplicatas.ps1
    ├── 04_limpar_numeros_restantes.ps1
    ├── 05_limpar_final.ps1
    ├── 06_ultimos_numeros.ps1
    ├── 07_forcar_ultimos2.ps1
    ├── 08_padronizar_maiusculas.ps1
    ├── 09_verificar_padroes.ps1
    ├── 10_aplicar_title_case.ps1
    ├── 11_forcar_title_case.ps1
    ├── 12_corrigir_pastas_title_case.ps1
    ├── 13_corrigir_tudo.ps1
    ├── 14_limpar_sufixos_orfaos.ps1
    ├── 15_remover_sufixo_pastas.ps1
    ├── relatorio_final.ps1
    ├── verificar_final.ps1
    ├── verificar_final_v2.ps1
    ├── verificar_pastas_nao_tc.ps1
    ├── corrigir_piseiro.ps1
    ├── remover_piseiro_maiusculo.ps1
    └── verificar_ultima_pasta.ps1
```

## 🚀 Como usar

### Opção 1: Hub interativo (recomendado)
Dê duplo clique em `HUD_Musicas.bat` para acessar um menu interativo.

### Opção 2: Via PowerShell
```powershell
# Defina o caminho da sua pasta de música antes de executar
$env:MUSICA_RAIZ = "D:\Musicas"

powershell -ExecutionPolicy Bypass -File "scripts\executar_tudo.ps1"
```

## 📋 O que os scripts fazem

| Script | Função |
|--------|--------|
| 01 | Remove números iniciais, anos finais e tudo após hífen nas pastas. Mescla pastas duplicadas. |
| 02 | Remove números iniciais e tudo após hífen nos nomes de músicas. |
| 03 | Detecta e remove músicas duplicadas (mesmo nome com acentos diferentes). |
| 04-07 | Limpeza de números restantes em diversos padrões. |
| 08-11 | Aplica Title Case (primeira letra maiúscula, resto minúsculo). |
| 12-13 | Corrige pastas Title Case e remove duplicatas restantes. |
| 14-15 | Remove sufixos órfãos "(n)" quando não há conflito. |

## 📊 Resultado esperado

- **Pastas**: Apenas o nome do artista, em Title Case (ex: `Ze Neto E Cristiano`)
- **Músicas**: Apenas o nome da música, em Title Case (ex: `Me Caiu Tão Bem.mp3`)
- **Sem**: Números iniciais, anos finais, sufixos duplicados, nomes em maiúsculas totais

## ⚠️ Avisos

- Os scripts renomeiam e excluem arquivos. Faça backup antes de executar.
- O script 03 remove duplicatas permanentemente.
- Execute em ordem: 01 → 15.
- Antes de executar, edite o `HUD_Musicas.bat` ou defina a variável `MUSICA_RAIZ` com o caminho da sua pasta de músicas.

## 📄 Licença

MIT License
