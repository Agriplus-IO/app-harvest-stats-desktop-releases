# Mode kiosque Windows 11

Guide de configuration pour deployer Stats Cueillette en mode kiosque sur un poste Windows 11.

---

## Principe

L'application Electron remplace l'explorateur Windows (`explorer.exe`) pour un compte utilisateur dedie.
Au demarrage du PC :
1. Connexion automatique au compte kiosque
2. L'application se lance en plein ecran (pas de bureau, pas de barre des taches)
3. Si l'application crash, elle est relancee automatiquement (script boucle)

---

## Prerequis

- Windows 11
- Stats Cueillette installe (ex: `C:\Program Files\Stats Cueillette\Stats Cueillette.exe`)
- Un compte administrateur pour la configuration

---

## Etapes

### 1. Creer un compte local "kiosque"

```powershell
# En tant qu'administrateur
net user kiosque /add
# Optionnel : definir un mot de passe
net user kiosque MonMotDePasse123
```

### 2. Configurer le remplacement du shell

Executer le script `scripts/setup-kiosk.bat` **en tant qu'administrateur** sur le compte kiosque,
ou manuellement :

**Registry** (pour le compte kiosque uniquement) :
```
HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
Shell = "C:\Program Files\Stats Cueillette\kiosk-loop.bat"
```

Le script `kiosk-loop.bat` relance l'application en boucle si elle se ferme ou crash.

### 3. Configurer l'auto-login (optionnel)

Executer le script `scripts/setup-autologin.bat` **en tant qu'administrateur**,
ou manuellement :

**Registry** :
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
AutoAdminLogon = 1
DefaultUserName = kiosque
DefaultPassword = MonMotDePasse123
```

Note : si le compte n'a pas de mot de passe, laisser `DefaultPassword` vide.

---

## Securite

| Action utilisateur | Resultat |
|---|---|
| Alt+F4 (1 fois) | Bloque (flash de la fenetre) |
| Alt+F4 (2 fois en 3s) | Ferme l'app (relancee par kiosk-loop.bat) |
| Alt+Tab | Pas de taskbar, rien a switcher |
| Ctrl+Alt+Del | Menu Windows minimal, pas d'explorateur |
| Ctrl+Alt+Del → Changer d'utilisateur | Acces au compte admin |

---

## Desinstallation du mode kiosque

1. Se connecter au compte administrateur (Ctrl+Alt+Del → Changer d'utilisateur)
2. Supprimer la cle registry `Shell` du compte kiosque :
   ```
   reg delete "HKEY_USERS\{SID_KIOSQUE}\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /f
   ```
3. Desactiver l'auto-login :
   ```
   reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /f
   reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f
   ```

---

## Mode plein ecran

Le mode plein ecran est configurable dans l'application :
- **Parametres** (icone engrenage) → **Mode plein ecran** → switch on/off
- La preference est persistee et appliquee au prochain demarrage
- Par defaut : active
