@echo off
:: Stats Cueillette - Configuration du mode kiosque
:: Remplace le shell Windows par le script kiosk-loop.bat pour l'utilisateur actuel.
:: DOIT etre execute en tant qu'administrateur sur le compte kiosque.

echo ============================================
echo  Stats Cueillette - Configuration Kiosque
echo ============================================
echo.

:: Verifier les droits admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR : Ce script doit etre execute en tant qu'administrateur.
    echo Faites un clic droit ^> Executer en tant qu'administrateur.
    pause
    exit /b 1
)

:: Verifier que l'application est installee
set APP_EXE=%ProgramFiles%\Stats Cueillette\Stats Cueillette.exe
if not exist "%APP_EXE%" (
    echo ERREUR : Stats Cueillette n'est pas installe dans :
    echo   %APP_EXE%
    echo Installez l'application d'abord.
    pause
    exit /b 1
)

:: Determiner le chemin du script kiosk-loop.bat
:: On le copie a cote de l'exe pour qu'il soit toujours accessible
set LOOP_SRC=%~dp0kiosk-loop.bat
set LOOP_DST=%ProgramFiles%\Stats Cueillette\kiosk-loop.bat

echo Copie du script de boucle...
copy /y "%LOOP_SRC%" "%LOOP_DST%" >nul
if %errorlevel% neq 0 (
    echo ERREUR : Impossible de copier kiosk-loop.bat.
    pause
    exit /b 1
)

:: Remplacer le shell pour l'utilisateur actuel
echo Configuration du shell de remplacement...
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "\"%LOOP_DST%\"" /f >nul

echo.
echo Configuration terminee.
echo Le shell de l'utilisateur "%USERNAME%" a ete remplace par Stats Cueillette.
echo Au prochain login de ce compte, seule l'application se lancera.
echo.
echo Pour annuler : executez le script remove-kiosk.bat
echo.
pause
