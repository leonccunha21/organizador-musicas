@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================================
:: HUB DE ORGANIZAÇÃO E PADRONIZAÇÃO DE ARQUIVOS
:: ============================================================================

:: Pasta padrão inicial (pode ser alterada a qualquer momento no menu pela opção 0)
if exist "D:\Jogos\PS2\OPL\DVD" (
    set "PASTA_TRABALHO=D:\Jogos\PS2\OPL\DVD"
) else if exist "D:\Musicas" (
    set "PASTA_TRABALHO=D:\Musicas"
) else (
    set "PASTA_TRABALHO=%~dp0"
)

:: Caminho da pasta de scripts (relativa a este arquivo)
set "SCRIPTS=%~dp0scripts"

title Hub de Organizacao e Padronizacao de Arquivos
color 1F

:MENU
cls
set "MUSICA_RAIZ=%PASTA_TRABALHO%"
echo.
echo ============================================================================
echo   HUB DE ORGANIZACAO E PADRONIZACAO DE ARQUIVOS
echo ============================================================================
echo   Pasta de trabalho atual: %PASTA_TRABALHO%
echo   Pasta de scripts:        %SCRIPTS%
echo.
echo   Data: %date%   Hora: %time%
echo ============================================================================
echo   CONFIGURACAO DE PASTA
echo ============================================================================
echo.
echo   [0]  Alterar pasta de trabalho (digitar caminho)
echo.
echo ============================================================================
echo   PADRONIZACAO GERAL (JOGOS / MUSICAS / QUALQUER PASTA)
echo ============================================================================
echo.
echo   [1]  Padronizar Nomes para Title Case (Primeira Letra Maiuscula)
echo   [2]  Simular Padronizacao (Preview - nao altera nenhum arquivo)
echo.
echo ============================================================================
echo   ORGANIZACAO DE BIBLIOTECA MUSICAL
echo ============================================================================
echo.
echo   [3]  Executar TODOS os scripts de musica (ordem correta 01->15)
echo   [4]  01 - Limpar nomes de pastas
echo   [5]  02 - Limpar nomes de musicas
echo   [6]  03 - Remover musicas duplicadas
echo   [7]  04 - Limpar numeros restantes
echo   [8]  05 - Limpeza final de numeros
echo   [9]  06 - Ultimos numeros
echo   [10] 07 - Forcar ultimos 2 arquivos
echo   [11] 08 - Padronizar maiusculas (Title Case)
echo   [12] 09 - Verificar padroes
echo   [13] 10 - Aplicar Title Case
echo   [14] 11 - Forcar Title Case
echo   [15] 12 - Corrigir pastas Title Case
echo   [16] 13 - Corrigir tudo (pastas + duplicatas)
echo   [17] 14 - Limpar sufixos orfaos de arquivos
echo   [18] 15 - Remover sufixo (n) de pastas
echo.
echo ============================================================================
echo   FERRAMENTAS
echo ============================================================================
echo   [19] Verificar estado final da organizacao
echo   [20] Abrir pasta de trabalho no Explorador
echo   [21] Abrir pasta de scripts no Explorador
echo   [22] Abrir README.md
echo.
echo   [00] Sair (ou digite S)
echo.
echo ============================================================================

set "OPCAO="
set /p OPCAO=Escolha uma opcao: 

if "%OPCAO%"=="0"   goto ALTERAR_PASTA
if "%OPCAO%"=="1"   goto EXEC_TITLE_CASE
if "%OPCAO%"=="2"   goto EXEC_TITLE_CASE_PREVIEW
if "%OPCAO%"=="3"   goto EXEC_TUDO
if "%OPCAO%"=="4"   goto EXEC_01
if "%OPCAO%"=="5"   goto EXEC_02
if "%OPCAO%"=="6"   goto EXEC_03
if "%OPCAO%"=="7"   goto EXEC_04
if "%OPCAO%"=="8"   goto EXEC_05
if "%OPCAO%"=="9"   goto EXEC_06
if "%OPCAO%"=="10"  goto EXEC_07
if "%OPCAO%"=="11"  goto EXEC_08
if "%OPCAO%"=="12"  goto EXEC_09
if "%OPCAO%"=="13"  goto EXEC_10
if "%OPCAO%"=="14"  goto EXEC_11
if "%OPCAO%"=="15"  goto EXEC_12
if "%OPCAO%"=="16"  goto EXEC_13
if "%OPCAO%"=="17"  goto EXEC_14
if "%OPCAO%"=="18"  goto EXEC_15
if "%OPCAO%"=="19"  goto VERIFICAR
if "%OPCAO%"=="20"  goto ABRIR_PASTA
if "%OPCAO%"=="21"  goto ABRIR_SCRIPTS
if "%OPCAO%"=="22"  goto ABRIR_README
if /i "%OPCAO%"=="s" goto SAIR
if "%OPCAO%"=="00"  goto SAIR

echo.
echo Opcao invalida. Pressione qualquer tecla para voltar...
pause >nul
goto MENU

:: ============================================================================
:: CONFIGURACAO
:: ============================================================================

:ALTERAR_PASTA
cls
echo ============================================================================
echo   ALTERAR PASTA DE TRABALHO
echo ============================================================================
echo.
echo   Pasta atual: %PASTA_TRABALHO%
echo.
set "NOVA_PASTA="
set /p "NOVA_PASTA=Digite o caminho da pasta (ou Enter para manter): "
if not "!NOVA_PASTA!"=="" (
    set "NOVA_PASTA=!NOVA_PASTA:"=!"
    if exist "!NOVA_PASTA!" (
        set "PASTA_TRABALHO=!NOVA_PASTA!"
        set "MUSICA_RAIZ=!NOVA_PASTA!"
        echo.
        echo [OK] Pasta alterada para: !PASTA_TRABALHO!
    ) else (
        echo.
        echo [ERRO] Caminho nao encontrado: !NOVA_PASTA!
    )
    echo.
    echo Pressione qualquer tecla para continuar...
    pause >nul
)
goto MENU

:: ============================================================================
:: PADRONIZACAO TITLE CASE (JOGOS / QUALQUER PASTA)
:: ============================================================================

:EXEC_TITLE_CASE
cls
echo ============================================================================
echo   PADRONIZANDO NOMES PARA TITLE CASE (EXECUTANDO)
echo ============================================================================
echo   Pasta: %PASTA_TRABALHO%
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\padronizar_title_case.ps1" -caminho "%PASTA_TRABALHO%"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_TITLE_CASE_PREVIEW
cls
echo ============================================================================
echo   SIMULACAO DE PADRONIZACAO TITLE CASE (PREVIEW)
echo ============================================================================
echo   Pasta: %PASTA_TRABALHO%
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\padronizar_title_case.ps1" -caminho "%PASTA_TRABALHO%" -Preview
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:: ============================================================================
:: SCRIPTS DE MUSICA
:: ============================================================================

:EXEC_TUDO
cls
echo ============================================================================
echo   EXECUTANDO TODOS OS SCRIPTS DE MUSICA (ORDEM 01->15)
echo ============================================================================
echo   Pasta: %PASTA_TRABALHO%
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\executar_tudo.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_01
cls
echo ============================================================================
echo   SCRIPT 01 - Limpar nomes de pastas
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\01_limpar_pastas.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_02
cls
echo ============================================================================
echo   SCRIPT 02 - Limpar nomes de musicas
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\02_limpar_musicas.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_03
cls
echo ============================================================================
echo   SCRIPT 03 - Remover musicas duplicadas
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\03_remover_duplicatas.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_04
cls
echo ============================================================================
echo   SCRIPT 04 - Limpar numeros restantes
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\04_limpar_numeros_restantes.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_05
cls
echo ============================================================================
echo   SCRIPT 05 - Limpeza final de numeros
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\05_limpar_final.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_06
cls
echo ============================================================================
echo   SCRIPT 06 - Ultimos numeros
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\06_ultimos_numeros.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_07
cls
echo ============================================================================
echo   SCRIPT 07 - Forcar ultimos 2 arquivos
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\07_forcar_ultimos2.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_08
cls
echo ============================================================================
echo   SCRIPT 08 - Padronizar maiusculas (Title Case)
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\08_padronizar_maiusculas.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_09
cls
echo ============================================================================
echo   SCRIPT 09 - Verificar padroes
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\09_verificar_padroes.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_10
cls
echo ============================================================================
echo   SCRIPT 10 - Aplicar Title Case
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\10_aplicar_title_case.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_11
cls
echo ============================================================================
echo   SCRIPT 11 - Forcar Title Case
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\11_forcar_title_case.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_12
cls
echo ============================================================================
echo   SCRIPT 12 - Corrigir pastas Title Case
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\12_corrigir_pastas_title_case.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_13
cls
echo ============================================================================
echo   SCRIPT 13 - Corrigir tudo (pastas + duplicatas)
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\13_corrigir_tudo.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_14
cls
echo ============================================================================
echo   SCRIPT 14 - Limpar sufixos orfaos de arquivos
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\14_limpar_sufixos_orfaos.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:EXEC_15
cls
echo ============================================================================
echo   SCRIPT 15 - Remover sufixo (n) de pastas
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\15_remover_sufixo_pastas.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:: ============================================================================
:: FERRAMENTAS
:: ============================================================================

:VERIFICAR
cls
echo ============================================================================
echo   VERIFICACAO DE ESTADO
echo ============================================================================
echo   Pasta: %PASTA_TRABALHO%
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\verificar_final.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:ABRIR_PASTA
if exist "%PASTA_TRABALHO%" (
    explorer "%PASTA_TRABALHO%"
) else (
    echo.
    echo Pasta nao encontrada: %PASTA_TRABALHO%
    echo Use a opcao [0] para definir o caminho correto.
    pause
)
goto MENU

:ABRIR_SCRIPTS
if exist "%SCRIPTS%" (
    explorer "%SCRIPTS%"
) else (
    echo.
    echo Pasta de scripts nao encontrada: %SCRIPTS%
    pause
)
goto MENU

:ABRIR_README
if exist "%~dp0README.md" (
    notepad "%~dp0README.md"
) else (
    echo.
    echo README.md nao encontrado!
    pause
)
goto MENU

:SAIR
echo.
echo Obrigado por usar o Hub de Organizacao e Padronizacao!
echo.
endlocal
exit /b
