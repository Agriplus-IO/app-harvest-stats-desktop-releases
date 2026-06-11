@echo off
:: Stats Cueillette - Suppression de l'auto-login
:: Desactive la connexion automatique au demarrage.
:: DOIT etre execute en tant qu'administrateur.

echo ============================================
echo  Stats Cueillette - Suppression Auto-Login
echo ============================================
echo.

:: Verifier les droits admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR : Ce script doit etre execute en tant qu'administrateur.
    pause
    exit /b 1
)

reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f >nul 2>&1

echo Auto-login desactive.
echo Le prochain demarrage affichera l'ecran de connexion Windows.
echo.
pause
