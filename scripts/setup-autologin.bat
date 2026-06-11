@echo off
:: Stats Cueillette - Configuration de l'auto-login Windows
:: Configure la connexion automatique au demarrage du PC.
:: DOIT etre execute en tant qu'administrateur.

echo ============================================
echo  Stats Cueillette - Auto-Login Windows
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

:: Recuperer le nom d'utilisateur actuel
set DEFAULT_USER=%USERNAME%
echo Utilisateur detecte : %DEFAULT_USER%
echo.

:: Verifier si le compte a un mot de passe
:: On tente un net user pour voir les infos du compte
echo Verification du compte...
net user %DEFAULT_USER% | findstr /i "Mot de passe requis" >nul 2>&1
if %errorlevel% equ 0 (
    echo Ce compte necessite un mot de passe pour l'auto-login.
    echo.
    set /p USER_PASSWORD="Entrez le mot de passe du compte %DEFAULT_USER% : "
) else (
    :: Tenter aussi en anglais
    net user %DEFAULT_USER% | findstr /i "Password required" >nul 2>&1
    if %errorlevel% equ 0 (
        echo Ce compte necessite un mot de passe pour l'auto-login.
        echo.
        set /p USER_PASSWORD="Entrez le mot de passe du compte %DEFAULT_USER% : "
    ) else (
        echo Aucun mot de passe detecte sur ce compte.
        set USER_PASSWORD=
    )
)

echo.
echo Configuration de l'auto-login pour : %DEFAULT_USER%

:: Configurer l'auto-login dans la registry
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "1" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "%DEFAULT_USER%" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "%USER_PASSWORD%" /f >nul

echo.
echo Auto-login configure.
echo Au prochain demarrage, Windows se connectera automatiquement
echo sur le compte "%DEFAULT_USER%".
echo.
echo Pour annuler : executez le script remove-autologin.bat
echo.
pause
