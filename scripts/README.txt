================================================================================
 ORGANIZAÇÃO DA PASTA DE MÚSICAS - D:\Musicas
================================================================================

PASTA ORIGEM: C:\Users\Leo\Desktop\Nova pasta
PASTA DESTINO: D:\Musicas

SCRIPTS (executar nesta ordem):

  01_limpar_pastas.ps1
    - Remove número no início das pastas (ex: "11-", "12 -")
    - Remove ano no final (ex: "-2024", " 2026", "2K25")
    - Remove tudo depois do primeiro hífen (fica só o nome do cantor)
    - Mescla pastas com mesmo nome em 1 só

  02_limpar_musicas.ps1
    - Remove número no início das músicas (ex: "01-", "02 -")
    - Remove tudo depois do primeiro hífen (fica só o nome da música)
    - Trata conflitos adicionando sufixo (1), (2)...

  03_remover_duplicatas.ps1
    - Normaliza nomes (minúsculo, sem acento, sem espaços)
    - Detecta músicas duplicadas (ex: "Alô Fala Comigo" = "Alõ Fala Comigo")
    - Mantém 1 cópia e remove as duplicatas para economizar espaço

  04_limpar_numeros_restantes.ps1
    - Remove número + hífen, ponto ou espaço no início

  05_limpar_final.ps1
    - Remove número + underline no início

  06_ultimos_numeros.ps1
    - Trata casos específicos restantes

  07_forcar_ultimos2.ps1
    - Força renomeação dos últimos 2 arquivos

  08_padronizar_maiusculas.ps1
    - Aplica Title Case (primeira letra maiúscula, resto minúsculo)

  09_verificar_padroes.ps1
    - Verifica o que ainda precisa de ajuste

  10_aplicar_title_case.ps1
    - Aplica Title Case nos arquivos restantes

  11_forcar_title_case.ps1
    - Força Title Case resolvendo conflitos

  12_corrigir_pastas_title_case.ps1
    - Corrige pastas para Title Case (comparação case-sensitive)

  13_corrigir_tudo.ps1
    - Corrige pastas Title Case + remove duplicatas restantes

  14_limpar_sufixos_orfaos.ps1
    - Remove sufixos órfãos "(n)" de arquivos quando não há conflito

  15_remover_sufixo_pastas.ps1
    - Remove sufixo "(n)" de pastas quando não há conflito

  executar_tudo.ps1
    - Executa todos os scripts na ordem correta

  verificar_final.ps1
    - Verifica o estado final da organização

================================================================================
 RESULTADO FINAL:

 Pastas:   Title Case, sem número, sem ano, sem sufixo "(n)"
           (ex: "Ze Neto E Cristiano", "Wesley Safadao")
 Músicas:  Title Case, sem número, sem nome do cantor
           (ex: "Me Caiu Tão Bem.mp3", "Pilantra E Meio.mp3")

================================================================================
