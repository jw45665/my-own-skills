---
name: environment-detector
displayName: Environment Detector
description: Automatische Erkennung von Umgebungsinformationen (OS, Python, Node.js, VS Code, Extensions, MCP Server) für das environment-Objekt in Metadaten-Konfigurationen
version: 1.0.0
author: JW
---

# 🔍 Environment Detector Skill

Dieser Skill automatisiert die Erkennung von Umgebungsinformationen wie Betriebssystem, Programmversionen, IDE-Details und installierte Erweiterungen. Die erkannten Daten werden in Metadaten-Konfigurationsdateien integriert.

## 📋 Features

- ✅ Automatische Erkennung von OS, Python, Node.js Versionen
- ✅ VS Code Version (via `code --version`)
- ✅ Installierte Extensions (GitHub Copilot, Pylance, etc.)
- ✅ MCP Server aus VS Code Settings
- ✅ Aktuelles Datum
- ⚠️ IDE-Name: Semi-automatisch (Heuristik + manuelle Verifikation)

## 🚀 Verwendung

### 1. Standalone: Environment in separate Datei speichern

```bash
python skills/environment-detector/detect_env.py --output data/env-detected.json
```

**Output**: Erstellt `data/env-detected.json` mit vollständigem Environment-Objekt.

### 2. Merge: In existierende model-metadata.json einfügen

```bash
python skills/environment-detector/detect_env.py --merge data/model-metadata.json
```

**Effekt**: 
- Fügt `environment`-Objekt in `model-metadata.json` ein
- Überschreibt KEINE manuell gesetzten Werte
- Zeigt an, welche Felder manuelle Verifikation brauchen

### 3. Verbose: Detaillierte Erkennungsinformationen

```bash
python skills/environment-detector/detect_env.py --verbose --merge data/model-metadata.json
```

## 📊 Was wird erkannt?

### ✅ Vollautomatisch

- **OS**: Windows, macOS, Linux (mit Distribution)
- **Python Version**: Aus laufendem Interpreter
- **Node.js Version**: Falls installiert
- **Test-Datum**: Aktuelles Datum (ISO 8601)
- **MCP Server**: Aus VS Code Settings (`.vscode/settings.json` oder User Settings)

### ⚙️ Semi-automatisch (CLI-basiert)

- **VS Code Version**: Via `code --version` (falls VS Code im PATH)
- **Extensions**: Via `code --list-extensions --show-versions`
- **Copilot Version**: Aus Extension-Liste extrahiert

### ⚠️ Manuell erforderlich

- **IDE-Name**: Kann nicht zuverlässig unterschieden werden zwischen:
  - Visual Studio Code
  - Cursor (VS Code Fork)
  - VSCodium
  - Azure Data Studio
  - Andere VS Code-basierte IDEs

**Empfehlung**: Das Skript setzt `"Visual Studio Code (detected)"` — bitte manuell verifizieren und anpassen!

## 📝 Output-Format

```json
{
  "ide": "Visual Studio Code (please verify)",
  "ide_version": "1.95.3",
  "copilot_version": "1.250.0",
  "extensions": [
    "github.copilot@1.250.0",
    "ms-python.python@2024.20.0",
    "ms-python.vscode-pylance@2024.1.1"
  ],
  "mcp_servers": [
    "playwright",
    "microsoft-docs",
    "github"
  ],
  "test_date": "2026-01-27",
  "os": "Windows 11",
  "python_version": "3.12.0",
  "node_version": "v20.11.0",
  "notes": "",
  "_detection_metadata": {
    "auto_detected": true,
    "confidence": "medium",
    "manual_verification_needed": ["ide"]
  }
}
```

## 💡 Empfohlener Workflow für Agenten

1. **Führe Skill aus**:
   ```bash
   python skills/environment-detector/detect_env.py --merge data/model-metadata.json
   ```

2. **Prüfe Output**: Das Skript zeigt an, welche Felder manuelle Verifikation brauchen

3. **IDE-Name anpassen**:
   - Falls du weißt, dass du in VS Code bist: Setze `"ide": "Visual Studio Code"`
   - Falls Cursor: `"ide": "Cursor"`
   - Falls Visual Studio: `"ide": "Visual Studio"`
   - Falls unsicher: Behalte `"Visual Studio Code (detected)"` oder trage `"Visual Studio Code or compatible"` ein

4. **Optional**: Ergänze `notes` mit Besonderheiten (z.B. "YOLO Mode enabled", "Custom MCP setup")
