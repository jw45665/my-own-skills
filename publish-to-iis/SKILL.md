---
name: publish-to-iis
description: Veröffentlicht ein Vite/React-Projekt auf IIS mit Web Deploy, nutzt IIS_ADMIN aus ENV, verlangt Ziel-IP und Domain/Site, verifiziert Deployment per HTTP.
---

# Publish to IIS (Agent Skill)

## Zweck
Dieser Skill führt einen standardisierten, projektunabhängigen IIS-Release-Prozess aus.

## Umgang mit projektspezifischen Skripten
- Der Skill ist der primäre Mechanismus und darf ohne Projektskripte funktionieren.
- Das im Skill enthaltene `web-deploy.ps1` ist der generische Standardweg.
- Projektskripte sind optional und können als Komfortschicht genutzt werden.
- Wenn Projektskripte vorhanden sind, kann der Agent sie nutzen, muss aber nicht davon abhängig sein.

## Pflichtbedingungen
1. `IIS_ADMIN` muss als Umgebungsvariable gesetzt sein.
2. Ziel-IP oder Host muss explizit angegeben sein.
3. Ziel-Site/Domain (`DeployIisAppPath` bzw. `contentPath`) muss explizit angegeben sein.

Wenn eine Bedingung fehlt: Abbrechen und präzise fehlende Eingabe nennen.

## Standard-Eingaben
- `targetIp`: IPv4/Host des IIS-Servers
- `siteName`: IIS Site/Domain
- `username`: `Administrator`
- `passwordEnv`: `IIS_ADMIN`

## Ablauf

### 1. Vorprüfung
- Prüfen, ob `IIS_ADMIN` gesetzt ist.
- DNS prüfen, wenn Domain gegeben ist.
- Port 8172 testen (`Test-NetConnection <ip> -Port 8172`).
- Port 80 testen (`Test-NetConnection <domain-or-ip> -Port 80`).

### 2. Build und Publish-Artefakt
- In den Projektordner wechseln.
- Produktions-Build mit den projektüblichen Befehlen erzeugen (bei Node-Projekten typischerweise `npm install` und `npm run build`).
- Falls ein projektspezifisches Build/Publish-Skript vorhanden ist, kann es stattdessen verwendet werden.
- Build-Artefakte in ein Publish-Verzeichnis überführen (z. B. `bin\\publish`).
- Bei Fehlern abbrechen und Build-Output zusammenfassen.

### 3. Deploy-Strategie
Bevorzugte Reihenfolge:
1. **WMSVC** über `https://<ip>:8172/msdeploy.axd?site=<siteName>`
2. **Fallback Remote Agent** über `http://<ip>/msdeployagentservice`

#### 3a) WMSVC Versuch (wenn 8172 erreichbar)
- `msdeploy.exe` mit `-verb:sync`
- Quelle: `contentPath='...\\bin\\publish'`
- Ziel: `contentPath='<siteName>', computerName='https://<ip>:8172/msdeploy.axd?site=<siteName>', userName='<username>', password='$env:IIS_ADMIN', authType='Basic'`

#### 3b) Fallback Remote Agent
- `msdeploy.exe` mit `-verb:sync`
- Quelle: `contentPath='...\\bin\\publish'`
- Ziel: `contentPath='<siteName>', computerName='http://<ip>/msdeployagentservice', userName='<username>', password='$env:IIS_ADMIN', authType='NTLM'`

Empfohlene Regeln:
- `-enableRule:AppOffline`
- `-enableRule:DoNotDeleteRule`

## 4. Verifikation
Nach erfolgreichem Deploy immer prüfen:
- Root: `http://<domain-or-ip>`
- Deep Route: `http://<domain-or-ip>/dashboard`

Erwartung: HTTP `200` für beide Requests.

Wenn Root ok, Deep Route fehlschlägt:
- `public/web.config` auf Rewrite-Regel prüfen (`/index.html` für SPA).
- URL Rewrite Modul auf IIS verifizieren.
- Erneut deployen und testen.

## 5. Sicherheitsregeln
- Passwörter nie in Dateien schreiben.
- Passwörter nie im Chat ausschreiben.
- Secrets nur aus ENV lesen.

## 6. Abschlussformat für den Nutzer
Der Agent berichtet immer:
1. Verwendete Deploy-Methode (`WMSVC` oder `Remote Agent`)
2. Ziel (`IP` und `Site/Domain`)
3. Ergebnis der HTTP-Checks (Root + Deep Route)
4. Nächster konkreter Schritt bei Fehlern

## Referenzen im Repo
- `.github/skills/publish-to-iis/web-deploy.ps1`
- Optional: vorhandene projektspezifische Deploy-Skripte
- `public/web.config`
- `PUBLISH.md`

## Designentscheidung
Dieser Skill ist ein generisches Playbook mit eigenem Web-Deploy-Skript und funktioniert auch dann, wenn ein Projekt keinerlei Deploy-Skripte mitbringt.
