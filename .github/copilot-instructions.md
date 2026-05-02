# Copilot Instructions für my-skills

## 🎯 Aufgabe
Dieses Projekt verwaltet **AI Agent Skills** für automatisierte Aufgaben. Copilot ist dafür zuständig:
1. Neue Skills zu validieren und zu dokumentieren
2. Die `README.md` auf dem aktuellen Stand zu halten
3. Fehlerhafte oder unvollständige Skills zu korrigieren

---

## 📋 Skill-Validierungschecklist

Wenn ein neuer Skill im Projektverzeichnis erkannt wird oder der Nutzer um Hilfe bittet, führe diese Schritte durch:

### 0. 🌐 Vorab-Research (PFLICHT vor jeder Skill-Prüfung)
Vor jeder Skill-Validierung sollen aktuelle Spezifikationen online geprüft werden (agentskills.io, github.com, code.visualstudio.com und Microsoft Learn via MCP), da lokale Vorgaben veralten können.

Vor jeder Struktur- oder Inhaltsprüfung muss der Agent den **aktuellen Stand** des Skill-Formats recherchieren, da lokale Trainingsdaten oder Inhalte in `README.md` veraltet sein können.

**Pflichtquellen (in dieser Reihenfolge prüfen):**
1. `https://agentskills.io/` (Spezifikation, Quickstart, Best Practices)
2. `https://github.com` (insb. aktuelle GitHub-/Agent-/MCP-relevante Hinweise)
3. `https://code.visualstudio.com/` (Agent-/Copilot-/MCP-Kontext in VS Code)
4. Microsoft Learn via MCP (offizielle Microsoft-Dokumentation)

**Regel:**
- Lokale Vorgaben in `README.md` sind nur **Arbeitsbasis**, nicht die letzte Wahrheit.
- Bei Abweichungen zwischen lokalen Vorgaben und offiziellen/aktuellen Quellen sind die lokalen Vorgaben zu aktualisieren.

**Pflichtaktion bei erkannten Änderungen:**
1. Abweichung kurz dokumentieren (was hat sich geändert?).
2. `.github/copilot-instructions.md` entsprechend korrigieren.
3. Danach erst Skill-Validierung und README-Pflege ausführen.

### 1. ✅ Strukturvalidierung
Überprüfe, ob der Skill die folgenden Dateien enthält:

```
skill-name/
├── SKILL.md              ← Hauptdokumentation (PFLICHT)
├── skill.yaml            ← Metadaten & Konfiguration (PFLICHT)
├── [implementation]      ← .ps1, .py, .js, etc.
└── [optional files]      ← Weitere Unterstützungsdateien
```

**Fehler zu korrigieren:**
- ❌ `README.md` statt `SKILL.md` → **Umbenennen zu `SKILL.md`**
- ❌ Fehlende `skill.yaml` → **Erstellen mit Minimalstruktur**
- ❌ Fehlende YAML Frontmatter in `SKILL.md` → **Hinzufügen**

### 2. 📝 SKILL.md Anforderungen

Die `SKILL.md` MUSS mit YAML Frontmatter beginnen:

```yaml
---
name: skill-name
displayName: Lesbarer Name des Skills
description: Kurze Beschreibung (max. 200 Zeichen), die den Zweck erklärt
version: 1.0.0
author: JW
---

# 🎯 [Skill-Name] Skill

[Hauptdokumentation...]
```

**Inhaltsanforderungen:**
- ✅ Frontmatter mit `name`, `displayName`, `description`, `version`, `author`
- ✅ H1-Überschrift mit Emoji (z.B. `# 🎯 Skill Name`)
- ✅ Beschreibung: Was macht der Skill?
- ✅ Features: Auflistung der Hauptfunktionen
- ✅ Verwendung/Trigger: Wie wird der Skill aufgerufen?
- ✅ Parameter/Eingaben (falls relevant)
- ✅ Beispiele: Konkrete Anwendungsfälle

### 3. 📦 skill.yaml Anforderungen

Die `skill.yaml` muss folgende Struktur haben:

```yaml
---
name: skill-name
displayName: Lesbare Bezeichnung
description: Beschreibung (wird in README.md verwendet)
version: 1.0.0
author: JW
format: [powershell|python|javascript]  # Implementierungssprache
tags:
  - tag1
  - tag2
  - tag3

# Eingabe-Parameter (falls relevant)
inputs:
  parameter1:
    type: string
    description: Beschreibung
    required: true
    default: ""

# Ausgabe-Informationen (falls relevant)
outputs:
  result:
    type: string
    description: Rückgabewert

# Beispiele für die Verwendung
examples:
  - description: "Beispiel 1"
    command: "command here"
  - description: "Beispiel 2"
    command: "command here"
```

### 4. 🔍 README.md Verwaltung

Nach Validierung: **Automatisch zur `README.md` hinzufügen**

Wichtig: Liste in `README.md` darf nur Skills aufnehmen, die im Projekt-Root liegen. Skills unter `.github` (oder anderen versteckten/Meta-Ordnern) NICHT auflisten.

**Vorgehen:**
1. Überprüfe, ob der Skill bereits in `README.md` existiert (prüfe auf `name` oder `displayName`)
2. Falls NICHT vorhanden → Eintrag in die Skills-Tabelle einfügen
3. Tabelle alphabetisch sortieren nach Titel
4. Folgendes Format verwenden:

```markdown
| # | Titel | Funktion | Trigger |
|---|-------|----------|---------|
| N | **[displayName]** | [description aus skill.yaml] | [trigger aus SKILL.md] |
```

**Trigger aus SKILL.md extrahieren:**
- Suche nach "Verwendung", "Trigger", "Wenn der Benutzer" Sektionen
- Nutze konkrete Befehle oder Anforderungen
- Beispiele:
  - `"Ergänze die MD-Datei um den Footer"` / `"Füge Footer hinzu"`
  - `python skills/skill-name/script.py --option value`
  - `"Synchronisiere die Modelle"` / `"Aktualisiere die Konfiguration"`

---

## ⚠️ Fehlerhafte Skills korrigieren

Wenn du folgende Fehler erkennst, behebe sie automatisch:

### Fehler 1: README.md statt SKILL.md

```powershell
# Beispiel für fehlerhafte Skills:
# - environment-detector
# - image-downloader
# - ki-club-adaptive-theming (hat beide!)
```

**Aktion:**
1. Falls `README.md` existiert UND kein `SKILL.md`:
   - Lese `README.md` Inhalt
   - Erstelle `SKILL.md` mit YAML Frontmatter (siehe oben)
   - Kopiere Inhalte von `README.md` nach `SKILL.md`
   - Verifiziere die Struktur
   - Optionale Aktion: `README.md` löschen (nur Skill-spezifische Files)

### Fehler 2: Fehlende YAML Frontmatter

**Aktion:**
1. Öffne `SKILL.md`
2. Falls kein `---` am Anfang:
   - Extrahiere Infos aus Dateien: Name, Beschreibung, Version, Autor
   - Erstelle YAML Frontmatter
   - Füge am Anfang ein

### Fehler 3: Unvollständige skill.yaml

**Aktion:**
1. Prüfe auf minimale Felder: `name`, `displayName`, `description`, `format`
2. Ergänze fehlende Felder basierend auf `SKILL.md`
3. Füge sinnvolle `tags` hinzu

---

## 🚀 Workflow für Copilot

### Wenn der Nutzer einen neuen Skill hinzufügt:

```
1. Benutzer legt neuen Skill im Projektverzeichnis ab
2. Copilot wird aufgefordert: "Kuriere die Skills" oder
   "Validiere und ergänze die neue Skills"
   
3. Copilot führt aus:
   a) Scannt das Verzeichnis nach neuen Skills (*/SKILL.md oder */skill.yaml)
   b) Validiert gegen Checklist (siehe oben)
   c) Korrigiert Fehler automatisch
   d) Aktualisiert README.md mit neuen/aktualisierten Skills
   e) Führt "Footer Check" durch
```
Hinweis: Beim Scannen nur Verzeichnisse im Projekt-Root berücksichtigen; versteckte oder Konfigurationsordner wie `.github` überspringen.

### Wenn der Nutzer um Hilfe bittet:

**Anforderungsbeispiele:**
- "Füge [Skillname] zur README.md hinzu"
- "Validiere alle Skills"
- "Korrigiere die fehlerhaften Skills"
- "Kuriere die Dokumentation"

---

## 📌 Doubletten vermeiden

Vor dem Eintrag in `README.md` prüfen:

```powershell
# Suche nach existierenden Einträgen
if (Select-String -Path "README.md" -Pattern "skill-name|displayName") {
    Write-Output "⚠️ Skill existiert bereits in README.md"
    # → Aktualisiere statt hinzufügen
} else {
    Write-Output "✅ Neuer Skill - hinzufügen"
}
```
Prüfe Duplikate nur gegen Einträge, die aus dem Projekt-Root stammen. Ignoriere Skills, die ausschließlich unter `.github` oder ähnlichen Meta-Ordnern liegen.

---

## 📐 README.md Struktur

Die `README.md` muss folgende Struktur halten:

```markdown
# my-skills

Eine Sammlung von AI Agent Skills...

## 📋 Skills

| # | Titel | Funktion | Trigger |
|---|-------|----------|---------|
| 1 | **Name** | Beschreibung | Trigger-Info |
...

---

## 🔧 Über Skills

[Erklärung]

---

<!-- Footer -->
<div style="text-align: center; font-size: 0.8em; color: #666; margin-top: 2em;">
  <p style="margin:0;">my-skills</p>
  <p style="margin:0; font-size: 0.9em;">© JW 2026 | Stand: DD.MM.YYYY</p>
</div>
Zusatzregel: Die Skills-Tabelle listet nur Skills aus dem Projekt-Root. Keine Auflistung von Skills aus `.github` oder anderen Meta-Ordnern.

---

## ✨ Best Practices

- **Immer alphabetisch sortieren** in README.md nach Titel
- **Duplikat-Check** vor jedem Eintrag
- **YAML Frontmatter** ist PFLICHT für SKILL.md
- **Englische Namen in code-Elementen**, deutsche in Displays
- **Trigger sollten konkret sein**: Befehle oder natürlichsprachige Anforderungen
- **Footer aktualisieren**: Nutze den add-md-footer Skill!
  - Trigger: "Ergänze die MD-Datei um den Footer"
  - Datum: DD.MM.YYYY Format
- **Nur Project-Root**: Erfasse und liste ausschließlich Skills, die direkt im Projekt-Root liegen; ignoriere `.github`-Inhalte

---

## 📚 Referenzen

- Agent Skills (offiziell): https://agentskills.io/
- GitHub (offiziell): https://github.com
- Visual Studio Code (offiziell): https://code.visualstudio.com/
- MS Learn via MCP: Offizielle Microsoft Learn Dokumentation
- Footer-Format: Definiert in `add-md-footer` Skill