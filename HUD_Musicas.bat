@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================================
:: HUB DE ORGANIZAÇÃO DE MÚSICAS
:: Projeto: Organizador de Biblioteca Musical
:: ============================================================================

:: Caminho da pasta de músicas (altere conforme necessário)
set "MUSICA_RAIZ=D:\Musicas"

:: Caminho da pasta de scripts (relativa a este arquivo)
set "SCRIPTS=%~dp0scripts"

title Hub de Organizacao de Musicas
color 1F

:MENU
cls
echo.
echo ============================================================================
echo   HUB DE ORGANIZACAO DE MUSICAS
echo   ============================================================================
echo   Pasta de musicas: %MUSICA_RAIZ%
echo   Pasta de scripts: %SCRIPTS%
echo.
echo   Data: %date%   Hora: %time%
echo.
echo ============================================================================
echo   MENU PRINCIPAL
echo ============================================================================
echo.
echo   [1]  Executar TODOS os scripts (ordem correta 01->15)
echo   [2]  01 - Limpar nomes de pastas
echo   [3]  02 - Limpar nomes de musicas
echo   [4]  03 - Remover musicas duplicadas
echo   [5]  04 - Limpar numeros restantes
echo   [6]  05 - Limpeza final de numeros
echo   [7]  06 - Ultimos numeros
echo   [8]  07 - Forcar últimos 2 arquivos
echo   [9]  08 - Padronizar maiusculas (Title Case)
echo   [10] 09 - Verificar padroes
echo   [11] 10 - Aplicar Title Case
echo   [12] 11 - Forcar Title Case
echo   [13] 12 - Corrigir pastas Title Case
echo   [14] 13 - Corrigir tudo (pastas + duplicatas)
echo   [15] 14 - Limpar sufixos orfaos de arquivos
echo   [16] 15 - Remover sufixo (n) de pastas
echo.
echo ============================================================================
echo   FERRAMENTAS
echo ============================================================================
echo   [17] Verificar estado final da organizacao
echo   [18] Abrir pasta de musicas no Explorador
echo   [19] Abrir pasta de scripts no Explorador
echo   [20] Abrir README.md
echo.
echo   [00] Sair
echo.
echo ============================================================================

set "OPCAO="
set /p OPCAO=Escolha uma opcao: 

if "%OPCAO%"=="1"   goto EXEC_TUDO
if "%OPCAO%"=="2"   goto EXEC_01
if "%OPCAO%"=="3"   goto EXEC_02
if "%OPCAO%"=="4"   goto EXEC_03
if "%OPCAO%"=="5"   goto EXEC_04
if "%OPCAO%"=="6"   goto EXEC_05
if "%OPCAO%"=="7"   goto EXEC_06
if "%OPCAO%"=="8"   goto EXEC_07
if "%OPCAO%"=="9"   goto EXEC_08
if "%OPCAO%"=="10"  goto EXEC_09
if "%OPCAO%"=="11"  goto EXEC_10
if "%OPCAO%"=="12"  goto EXEC_11
if "%OPCAO%"=="13"  goto EXEC_12
if "%OPCAO%"=="14"  goto EXEC_13
if "%OPCAO%"=="15"  goto EXEC_14
if "%OPCAO%"=="16"  goto EXEC_15
if "%OPCAO%"=="17"  goto VERIFICAR
if "%OPCAO%"=="18"  goto ABRIR_MUSICAS
if "%OPCAO%"=="19"  goto ABRIR_SCRIPTS
if "%OPCAO%"=="20"  goto ABRIR_README
if "%OPCAO%"=="0"   goto SAIR
if "%OPCAO%"=="00"  goto SAIR

echo.
echo Opcao invalida. Pressione qualquer tecla para voltar...
pause >nul
goto MENU

:: ============================================================================
:: EXECUCOES INDIVIDUAIS
:: ============================================================================

:EXEC_TUDO
cls
echo ============================================================================
echo   EXECUTANDO TODOS OS SCRIPTS (ORDEM 01->15)
echo ============================================================================
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
echo   SCRIPT 07 - Forçar últimos 2 arquivos
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
echo   SCRIPT 11 - Forçar Title Case
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
echo   VERIFICACAO DE ESTADO FINAL
echo ============================================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS%\verificar_final.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
goto MENU

:ABRIR_MUSICAS
if exist "%MUSICA_RAIZ%" (
    explorer "%MUSICA_RAIZ%"
) else (
    echo.
    echo Pasta de musicas nao encontrada: %MUSICA_RAIZ%
    echo Edite o arquivo HUD_Musicas.bat e ajuste MUSICA_RAIZ.
)
goto MENU

:ABRIR_SCRIPTS
if exist "%SCRIPTS%" (
    explorer "%SCRIPTS%"
) else (
    echo.
    echo Pasta de scripts nao encontrada: %SCRIPTS%
)
goto MENU

:ABRIR_README
if exist "%~dp0README.md" (
    notepad "%~dp0README.md"
) else (
    echo.
    echo README.md nao encontrado!
)
goto MENU

:SAIR
echo.
echo Obrigado por usar o Hub de Organizacao de Musicas!
echo.
endlocal
exit /b
