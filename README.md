# 🎵 Organizador de Arquivos, Músicas e Jogos (PS2 / OPL)

Projeto de automação para organizar pastas e padronizar nomes de arquivos no Windows usando PowerShell e um Hub interativo em Batch (`.bat`).

## 📁 Estrutura do Projeto

```
organizador-musicas/
├── HUD_Musicas.bat               # Hub interativo no terminal (.bat)
├── README.md                     # Documentação
├── .gitignore                    # Ignora arquivos binários pesados de áudio
├── .gitattributes                # Garante quebras de linha CRLF no Windows
└── scripts/                      # Scripts PowerShell
    ├── padronizar_title_case.ps1 # Padronizador geral de Title Case (Jogos/Músicas)
    ├── executar_tudo.ps1         # Script mestre de música (executa 01 -> 15 em ordem)
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

## 🚀 Como Usar

### Opção 1: Hub Interativo (Recomendado)
Dê um duplo clique no arquivo `HUD_Musicas.bat`. O menu interativo exibirá:
* **[0] Alterar pasta de trabalho**: Alterne a qualquer momento entre pastas (ex: `D:\Jogos\PS2\OPL\DVD`, `D:\Musicas` ou qualquer outro diretório).
* **[1] Padronizar Nomes para Title Case**: Converte todos os arquivos para Title Case (primeira letra maiúscula, resto minúsculo, removendo espaços duplicados e mantendo IDs de OPL intactos).
* **[2] Simular Padronização (Preview)**: Visualiza o que seria renomeado sem alterar nada.
* **[3] Executar TODOS os scripts de música (01 -> 15)**: Executa a faxina completa da biblioteca musical.

### Opção 2: Via PowerShell

Para padronizar qualquer pasta (ex: jogos PS2 OPL):
```powershell
# Executa a padronização em Title Case
powershell -ExecutionPolicy Bypass -File "scripts\padronizar_title_case.ps1" -caminho "D:\Jogos\PS2\OPL\DVD"

# Modo simulação (Preview)
powershell -ExecutionPolicy Bypass -File "scripts\padronizar_title_case.ps1" -caminho "D:\Jogos\PS2\OPL\DVD" -Preview
```

Para a biblioteca musical:
```powershell
$env:MUSICA_RAIZ = "D:\Musicas"
powershell -ExecutionPolicy Bypass -File "scripts\executar_tudo.ps1"
```

## 📋 Resumo dos Scripts

| Script | Função |
|---|---|
| `padronizar_title_case.ps1` | Padroniza nomes para Title Case, preserva IDs do OPL/PS2 (`SLUS_xxx.xx.`), remove espaços extras e renomeia com segurança no Windows NTFS. |
| `01_limpar_pastas.ps1` | Remove números iniciais, anos finais e sufixos nas pastas de artistas. Mescla pastas repetidas. |
| `02_limpar_musicas.ps1` | Remove números e prefixos dos nomes das faixas, preservando a extensão original. |
| `03_remover_duplicatas.ps1` | Detecta e remove músicas duplicadas dentro de cada pasta de cantor. |
| `04` a `07` | Limpeza fina de números restantes em diversos formatos. |
| `08` a `11` | Padronização em Title Case para músicas. |
| `12` e `13` | Correção de pastas para Title Case e remoção de duplicatas finais. |
| `14` e `15` | Remoção de sufixos órfãos `(1)` quando não há conflito de arquivo. |

## ⚠️ Avisos

- Faça backup dos seus arquivos antes de executar operações em lote.
- O script `03` remove duplicatas permanentemente.
- Ao usar o Hub (`HUD_Musicas.bat`), confira sempre a pasta exibida no topo do menu ou use a opção `[0]` para alterá-la.

## 📄 Licença

MIT License
