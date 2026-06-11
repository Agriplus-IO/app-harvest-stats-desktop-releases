@echo off
:: Stats Cueillette - Kiosk Loop
:: Ce script relance l'application en boucle si elle se ferme ou crash.
:: Utilise comme shell de remplacement pour le mode kiosque Windows.

title Stats Cueillette - Kiosk

set APP_PATH="%ProgramFiles%\Stats Cueillette\Stats Cueillette.exe"

:loop
echo [%date% %time%] Demarrage de Stats Cueillette...
start /wait "" %APP_PATH%
echo [%date% %time%] Application fermee. Redemarrage dans 2 secondes...
timeout /t 2 /nobreak >nul
goto loop
