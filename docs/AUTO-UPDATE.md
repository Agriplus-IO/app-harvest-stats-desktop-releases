# Auto-Update via GitHub Releases (repo prive)

## Fonctionnement

1. Un tag `v1.x.x` est pousse sur le repo
2. GitHub Actions build le Nuxt + Electron pour Windows et macOS
3. Les artefacts (.exe, .dmg) + fichiers de metadata (latest.yml, latest-mac.yml)
   sont publies en GitHub Release
4. L'app verifier au demarrage si une nouvelle version est disponible
5. Si oui, elle telecharge en arriere-plan et installe au prochain redemarrage

## Secrets GitHub a configurer

Dans le repo GitHub → Settings → Secrets and variables → Actions :

| Secret | Description | Obligatoire |
|--------|-------------|-------------|
| `FONTAWESOME_TOKEN` | Token npm pour @fortawesome/fontawesome-pro | Oui |
| `MAC_CERT_P12` | Certificat Apple (base64 du .p12) pour signer le DMG | macOS uniquement |
| `MAC_CERT_PASSWORD` | Mot de passe du certificat .p12 | macOS uniquement |

Note : `GITHUB_TOKEN` est fourni automatiquement par GitHub Actions.

## Comment publier une release

```bash
# 1. Mettre a jour la version dans les 2 package.json
# code/package.json → version
# code/electron/package.json → version

# 2. Commit
git add package.json electron/package.json
git commit -m "chore: bump version 1.x.x"

# 3. Tag et push
git tag v1.x.x
git push origin main --tags
```

GitHub Actions se declenche automatiquement et publie la release.

## Token GitHub pour l'auto-updater (repo prive)

L'app a besoin d'un token pour acceder aux releases d'un repo prive.

### Option A : Variable d'environnement (recommande pour kiosque)
Definir `GH_TOKEN` sur la machine kiosque :
```
# Windows (variable systeme)
setx GH_TOKEN "ghp_votre_token_ici" /M

# macOS/Linux
export GH_TOKEN="ghp_votre_token_ici"
```

### Option B : Hardcode dans l'app (kiosque interne uniquement)
Dans `electron/main.cjs`, remplacer :
```javascript
const ghToken = process.env.GH_TOKEN || process.env.GITHUB_TOKEN || ''
```
par :
```javascript
const ghToken = process.env.GH_TOKEN || 'ghp_votre_token_ici'
```

### Creer le token
1. GitHub → Settings → Developer Settings → Personal Access Tokens → Fine-grained tokens
2. Scope : `contents: read` sur le repo `Agriplus-IO/app-harvest-stats-desktop`
3. Expiration : selon la politique de securite (1 an recommande pour un kiosque)

## Verifier que l'auto-update fonctionne

L'app log les evenements de mise a jour dans la console Electron.
Pour tester :
1. Builder et installer une version (ex: v1.0.0)
2. Publier une release v1.0.1
3. Lancer l'app v1.0.0 → elle detecte v1.0.1, telecharge, et propose le redemarrage
