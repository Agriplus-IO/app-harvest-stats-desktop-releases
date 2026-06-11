@echo off
:: Stats Cueillette - Suppression du mode kiosque
:: Restaure le shell Windows par defaut (explorer.exe) pour l'utilisateur actuel.
:: DOIT etre execute en tant qu'administrateur.

echo ============================================
echo  Stats Cueillette - Suppression Kiosque
echo ============================================
echo.

:: Verifier les droits admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR : Ce script doit etre execute en tant qu'administrateur.
    pause
    exit /b 1
)

:: Supprimer la cle Shell (restaure explorer.exe par defaut)
reg delete "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /f >nul 2>&1

echo Shell Windows restaure (explorer.exe).
echo Le bureau normal sera affiche au prochain login.
echo.
pause
