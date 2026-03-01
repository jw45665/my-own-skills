# Lokale LM-Studio-Modelle in VS Code verwenden

## Überblick

**LM Studio** ist eine Alternative zu Ollama für die lokale Ausführung von Large Language Models. Im Gegensatz zu Ollama mit seiner CLI-basierten Verwaltung bietet LM Studio eine benutzerfreundliche GUI zur Modellverwaltung und verfügt über eine REST-API für die Integration in andere Anwendungen.

Mit LM Studio können Sie:
- ✅ GGUF-Modelle visuell verwalten
- ✅ GPU/CPU Auslastung überwachen
- ✅ Modelle über vs Code direkt nutzen
- ✅ OpenAI-kompatible API verwenden
- ✅ Vision- und Tool-Calling Features nutzen

---

## Voraussetzungen

- ✅ **LM Studio** lokal installiert und Server läuft (z.B. `http://192.168.178.42:1234`)
- ✅ **VS Code Insiders** mit Language Models API
- ✅ **GitHub Copilot** Erweiterung
- ✅ **Mindestens ein Modell** in LM Studio geladen

### LM Studio Server überprüfen

```powershell
# LM Studio API testen (OpenAI-kompatible API)
curl http://192.168.178.42:1234/v1/models
```

---

## Konfiguration für LM Studio

### Option 1: Workspace-Konfiguration

Speicherort: `.vscode/settings.json`

```json
{
  "chat.languageModels": [
    {
      "name": "LM-Studio",
      "vendor": "customoai",
      "models": [
        {
          "id": "llm/gguf/mistral-7b-instruct-v0.1.q4_0.gguf",
          "name": "mistral-7b-instruct",
          "url": "http://192.168.178.42:1234",
          "toolCalling": false,
          "vision": false,
          "maxInputTokens": 128000,
          "maxOutputTokens": 16000
        },
        {
          "id": "qwen/qwen2.5-coder-14b",
          "name": "qwen2.5-coder-14b",
          "url": "http://192.168.178.42:1234",
          "toolCalling": true,
          "vision": false,
          "maxInputTokens": 128000,
          "maxOutputTokens": 16000
        },
        {
          "id": "qwen/qwen3-coder-30b",
          "name": "qwen3-coder-30b",
          "url": "http://192.168.178.42:1234",
          "toolCalling": true,
          "vision": false,
          "maxInputTokens": 256000,
          "maxOutputTokens": 32000
        }
      ]
    }
  ]
}
```

### Option 2: Benutzerkonfiguration

Speicherort: `%APPDATA%\Code - Insiders\User\chatLanguageModels.json`

Gleiche Struktur wie Option 1.

### Wichtige Konfigurationsfelder

| Feld | Beschreibung |
|------|-------------|
| `id` | Eindeutige Kennung pro Modell |
| `name` | Anzeigename für den Model Picker |
| `url` | LM Studio Server URL (Port 1234 standard) |
| `toolCalling` | true wenn das Modell Tool-Calling unterstützt |
| `vision` | true wenn das Modell Bilder verarbeiten kann |
| `maxInputTokens` | Maximale Input-Token |
| `maxOutputTokens` | Maximale Output-Token |

### Tool-Calling und Vision

**Tool-Calling aktivieren (falls das Modell es unterstützt):**
- Qwen Models (Qwen-1.5, Qwen-7B, etc.)
- Funktioniert mit OpenAI-kompatiblen Models

**Vision aktivieren (falls das Modell es unterstützt):**
- LLaVA Modelle
- Phi 3 Vision

---

## LM Studio API Referenz

### Verfügbare Modelle abrufen

```powershell
curl http://192.168.178.42:1234/v1/models
```

**Antwort-Beispiel:**

```json
{
  "data": [
    {
      "id": "llm/gguf/mistral-7b-instruct-v0.1.q4_0.gguf",
      "object": "model",
      "owned_by": "organization_owner"
    },
    {
      "id": "qwen/qwen2.5-coder-14b",
      "object": "model",
      "owned_by": "organization_owner"
    }
  ],
  "object": "list"
}
```

### Server-Status prüfen

Der Status wird implizit durch die Modell-Abfrage geprüft. Falls die Verbindung fehlschlägt, ist der Server nicht erreichbar.

---

## Token-Limits für häufige LM Studio Modelle

| Modell | Größe | maxInputTokens | maxOutputTokens |
|--------|-------|--|--|
| Mistral 7B | 7B | 32768 | 8192 |
| Qwen 7B | 7B | 128000 | 16000 |
| LLaVA 7B | 7B | 4096 | 512 |
| Phi 3.5 | 3.8B | 128000 | 16000 |
| DeepSeek 6.7B | 6.7B | 8000 | 4096 |
| Qwen 72B | 72B | 128000 | 32000 |

---

## Schritt-für-Schritt: LM Studio im Copilot Chat

### 1. LM Studio starten

1. Öffnen Sie die LM Studio Anwendung
2. Laden Sie Ihr bevorzugtes Modell
3. Gehen Sie zum Tab **"Local Server"**
4. Starten Sie den Server (normalerweise Port 1234)

### 2. Modell in VS Code konfigurieren

Addieren Sie die Konfiguration zu `.vscode/settings.json` oder zur globalen `chatLanguageModels.json`.

### 3. Copilot Chat öffnen

```
Ctrl+Shift+P → GitHub Copilot: Open Copilot Chat
```

### 4. LM-Studio Modell auswählen

Klicken Sie auf das Modell-Symbol und wählen Sie Ihr LM Studio Modell aus.

### 5. Mit Agent Mode arbeiten

```
@workspace Erstelle eine TypeScript-Komponente für einen Datei-Upload
```

---

## Automatische Synchronisation mit LM-Studio-Sync Skill

### Was macht der Skill?

1. Verbindet sich mit dem LM Studio Server
2. Liest alle verfügbaren Modelle aus
3. Generiert automatische Konfiguration mit angemessenen Tokens
4. Aktualisiert `chatLanguageModels.json`
5. Entfernt nicht mehr verfügbare Modelle

### Installation

Der Skill befindet sich in: `lm-studio-sync/`

Dateien:
- `SKILL.md` - Skill-Dokumentation
- `sync-lm-studio-models.ps1` - PowerShell-Synchronisations-Script

### Verwendung im Copilot Chat

```
Synchronisiere die LM-Studio-Modelle
```

oder

```
Aktualisiere LM-Studio Modelle
```

### Manuelle Synchronisation

```powershell
cd C:\Users\blazo\source\Feuerwerk
.\lm-studio-sync\sync-lm-studio-models.ps1
```

**Mit optionalen Parametern:**

```powershell
# Anderer LM Studio Server
.\lm-studio-sync\sync-lm-studio-models.ps1 -LMStudioUrl "http://192.168.178.100:1234"

# Andere Konfigurationsdatei
.\lm-studio-sync\sync-lm-studio-models.ps1 -ConfigPath "C:\custom\path\chatLanguageModels.json"

# Mit Vision-Support aktivieren
.\lm-studio-sync\sync-lm-studio-models.ps1 -EnableVision
```

### Script-Ausgabe

```
Synchronisiere LM-Studio-Modelle von http://192.168.178.42:1234...
Verbindung zu LM Studio Server erfolgreich.
Gefundene Modelle: 2

  - mistral-7b-instruct-v0.1.q4_0.gguf (ID: 1)
  - llava-1.5-7b-hf-q4.gguf (ID: 2, Vision)

Konfiguration aktualisiert.
✓ 2 Modelle erfolgreich synchronisiert
```

---

## Kombination mit Ollama

Sie können Ollama und LM Studio gleichzeitig nutzen:

```json
{
  "chat.languageModels": [
    {
      "name": "Ollama",
      "vendor": "ollama",
      "url": "http://192.168.178.42:11434",
      "models": [...]
    },
    {
      "name": "LM-Studio",
      "vendor": "customoai",
      "url": "http://192.168.178.42:1234",
      "models": [...]
    }
  ]
}
```

**Synchronisiert dann nacheinander:**

1. Ollama-Modelle synchronisieren
2. LM Studio Modelle synchronisieren
3. Beide Konfigurationen zusammenführen

---

## Häufige Probleme und Lösungen

### Problem: LM Studio Server wird nicht gefunden

**Lösung:** Server läuft?
```powershell
# Server starten
curl http://192.168.178.42:1234/api/status
```

Falls nicht erreichbar:
```powershell
# Test localhost
curl http://localhost:1234/api/models
```

Update URL in Konfiguration:
```json
"url": "http://localhost:1234"
```

### Problem: Keine Modelle verfügbar

**Lösung:** Modell in LM Studio laden

1. LM Studio öffnen
2. "Search & Download" Tab
3. Modell herunterladen
4. Zum "Local Server" wechseln
5. Modell starten
6. Synchronisierung ausführen

### Problem: Tool-Calling funktioniert nicht

**Lösung:** Nicht alle Modelle unterstützen Tool-Calling

Tool-Calling kompatibel:
- ✅ Function-Calling Modelle (Qwen, ChatGLM)

Nicht kompatibel:
- ❌ Basis-Modelle ohne Instruktions-Tuning
- ❌ Einzelne Versionen (verifizieren Sie im Model-Info)

Setzen Sie `"toolCalling": false` für diese Modelle.

### Problem: Vision-Features verfügbar?

**Lösung:** Nur multimodale Modelle unterstützen Vision

Vision-kompatibel:
- ✅ LLaVA Modelle
- ✅ Phi 3 Vision
- ✅ GPT-4V kompatible Modelle

### Problem: Modell wird nicht im Agent-Mode angezeigt

**Lösung:** Modell im Ask-Modus überprüfen

VS Code unterscheidet zwischen zwei Chat-Modi:
- **Agent-Mode (@workspace):** Nur Modelle mit Tool-Calling Fähigkeit
- **Ask-Mode:** Alle konfigurierten Modelle

**Prüfung:**
1. Wechseln Sie vom Agent-Mode in den Ask-Mode (entfernen Sie `@workspace`)
2. Überprüfen Sie, ob das Modell dort sichtbar ist
3. Falls ja: Das Modell hat keine Tool-Calling Unterstützung

**Hintergrund:**
Nur Modelle mit `"toolCalling": true` können als Agent arbeiten und auf den Workspace zugreifen. Basis-Modelle ohne diese Fähigkeit sind ausschließlich im Ask-Mode verfügbar.

**Tool-Calling in LM Studio aktivieren:**
- Stellen Sie sicher, dass Sie ein Modell verwenden, das Function-Calling unterstützt (z.B. Qwen-Modelle)
- Setzen Sie in der Konfiguration: `"toolCalling": true`
- Der Synchronisations-Skill erkennt Tool-Calling-fähige Modelle automatisch

---

## LM Studio vs. Ollama - Vergleich

| Feature | LM Studio | Ollama |
|---------|-----------|---------|
| GUI | ✅ Ja | ❌ Nein (CLI) |
| Vision Support | ✅ Native | ⚠️ Begrenzt |
| Tool-Calling | ✅ Support | ⚠️ Begrenzt |
| API-Typ | OpenAI-kompatibel | Proprietär |
| Installation | Einfach | Sehr einfach |
| Modellverwaltung | Visuell | CLI-basiert |
| Performance | Optimiert | Sehr optimiert |
| Community | Wachsend | Größer |

**Empfehlung:**
- **LM Studio:** Komplexe Anforderungen, Vision, experimentelle Features
- **Ollama:** Performance, große Modelle, Server-Setup

---

## Best Practices für LM Studio

✅ **GPU-Auslastung:**
- Nutzen Sie ONNX/CUDA wenn GPU verfügbar
- Quantisierte Modelle (Q4_K_M) für beste Balance

✅ **Modellauswahl:**
- Mistral für generalistische Aufgaben
- Qwen für Code-spezifische Tasks
- LLaVA für Vision-Features
- Phi für kleine, schnelle Modelle

✅ **Token-Limits optimieren:**
- Kontextfenster des Modells beachten
- Nicht höher als vom Modell unterstützt setzen

✅ **Test vor Produktioneinsatz:**
- Modell mit einfachen Prompts testen
- Performance auf Ihrer Hardware prüfen
- Tool-Calling/Vision Features verifizieren

---

## LM Studio auf dem Netzwerk-Server

Wenn Sie LM Studio auf einem zentralen Server hosten:

```powershell
# Server mit "--cors-enabled" starten
# Ermöglicht Zugriffe von anderen Maschinen
```

Dann können alle im Netzwerk denselben Server verwenden:

```json
{
  "url": "http://192.168.178.42:1234"
}
```

Mit dem Synchronisations-Skill können alle Benutzer automatisch aktualisiert werden.

---

## Zusammenfassung

| Aspekt | Details |
|--------|---------|
| **Installation** | LM Studio GUI, Modell laden, Server starten |
| **Konfiguration** | `.vscode/settings.json` oder globale `chatLanguageModels.json` |
| **Synchronisation** | Automatisch mit `sync-lm-studio-models.ps1` |
| **Features** | Vision, Tool-Calling, Quantisierung |
| **Kombination** | Mit Ollama für flexibles Multi-Provider Setup |

Mit LM Studio und dem LM-Studio-Sync Skill haben Sie eine vollständige Lösung für lokal gehostete, intelligente Code-Assistenz in VS Code! 🚀
