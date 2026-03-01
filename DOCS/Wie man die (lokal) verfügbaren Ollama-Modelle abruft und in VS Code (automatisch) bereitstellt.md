# Lokale Ollama-Modelle in VS Code verwenden

## Überblick

Mit GitHub Copilot in VS Code können Sie nicht nur Cloud-basierte Modelle nutzen, sondern auch lokal verfügbare Modelle von **Ollama** oder **LM-Studio** einbinden. Dies ermöglicht vollständige Privatsphäre Ihrer Code-Kontexte, Offline-Verfügbarkeit und die Nutzung kostengünstiger Hardware.

In diesem Artikel erfahren Sie:
- Wie Sie lokale Modelle konfigurieren
- Unterschied zwischen Projekt- und systemweiter Konfiguration
- Schritt-für-Schritt Anleitung zur Nutzung im Copilot Chat
- Automatische Synchronisation mit dem Ollama-Sync Skill

---

## Voraussetzungen

- ✅ **VS Code Insiders** (neueste Version mit Language Models API)
- ✅ **Ollama Server** lokal oder im Netzwerk verfügbar (z.B. `http://192.168.178.42:11434`)
- ✅ **Mindestens ein Modell** auf dem Ollama-Server installiert
- ✅ **GitHub Copilot** Erweiterung aktiviert

### Ollama-Installation überprüfen

```powershell
# Port testen
Test-NetConnection -ComputerName 192.168.178.42 -Port 11434

# Verfügbare Modelle auflisten
curl http://192.168.178.42:11434/api/tags
```

---

## Konfigurationsoptionen

### Option 1: Einzelnes Projekt (Workspace-Konfiguration)

Diese Konfiguration gilt nur für das aktuelle Projekt und ist ideal für Teams, die ihre Modell-Infrastruktur teilen möchten.

**Speicherort:** `.vscode/settings.json` (im Projekt-Root)

**Vorteil:**
- Alle Team-Mitglieder nutzen die gleiche Konfiguration
- Einfach in Git versionierbar
- Keine bereits vorhandene Benutzer-Konfiguration überschrieben

**Schritte:**

1. Erstellen Sie das `.vscode`-Verzeichnis im Projekt-Root (falls nicht vorhanden)

2. Erstellen Sie `settings.json`:

```json
{
  "chat.languageModels": [
    {
      "name": "Ollama",
      "vendor": "ollama",
      "url": "http://192.168.178.42:11434",
      "models": [
        {
          "id": "phi4-reasoning:14b",
          "name": "phi4-reasoning:14b",
          "maxInputTokens": 65536,
          "maxOutputTokens": 16384
        },
        {
          "id": "qwen3-coder:30b",
          "name": "qwen3-coder:30b",
          "maxInputTokens": 131072,
          "maxOutputTokens": 32768
        }
      ]
    },
    {
      "name": "LM-Studio",
      "vendor": "customoai",
      "models": [
        {
          "id": "1",
          "name": "mistral-7b-instruct",
          "url": "http://192.168.178.42:1234",
          "maxInputTokens": 128000,
          "maxOutputTokens": 16000
        }
      ]
    }
  ]
}
```

3. Speichern und VS Code neu laden (`Ctrl+Shift+P` → "Developer: Reload Window")

### Option 2: Benutzerspezifische Konfiguration

Diese Konfiguration ist global für alle Projekte des aktuellen Benutzers.

**Speicherort:** `%APPDATA%\Code - Insiders\User\chatLanguageModels.json`

**Vorteil:**
- Gilt für alle VS Code Projekte
- Zentrale Verwaltung

**Nachteil:**
- Nicht projektübergreifend teilbar
- Lokale Einstellung pro Benutzer

**Schritte:**

1. Öffnen Sie die Datei:
   - `Ctrl+Shift+P` → "Preferences: Open User Settings (JSON)"
   - Navigieren Sie zur Datei `chatLanguageModels.json` im Profil-Verzeichnis

2. Oder direkt erstellen unter:
   ```
   C:\Users\<YourUsername>\AppData\Roaming\Code - Insiders\User\chatLanguageModels.json
   ```

3. Fügen Sie Ihre Ollama- und LM-Studio Konfiguration ein (wie in Option 1)

### Token-Limits bestimmen

Die Token-Limits sollten der Modellgröße entsprechen:

| Modellgröße | maxInputTokens | maxOutputTokens |
|-------------|----------------|-----------------|
| < 10B      | 32.768         | 8.192           |
| 10B - 20B  | 65.536         | 16.384          |
| > 20B      | 131.072        | 32.768          |

**Beispiele für verfügbare Modelle:**

```json
{
  "id": "phi4-reasoning:14b",
  "name": "phi4-reasoning:14b",
  "maxInputTokens": 65536,
  "maxOutputTokens": 16384
}
```

```json
{
  "id": "deepseek-r1:8b",
  "name": "deepseek-r1:8b",
  "maxInputTokens": 32768,
  "maxOutputTokens": 8192
}
```

---

## Schritt-für-Schritt: Ollama-Modelle im Copilot Chat verwenden

### 1. VS Code öffnen und Chat aktivieren

```
Ctrl+Shift+P → GitHub Copilot: Open Copilot Chat
```

oder nutzen Sie das Chat-Symbol in der Seitenleiste.

### 2. Agent Mode aktivieren

Im Chat-Fenster gibt es ein `@`-Symbol (Mentions). Klicken Sie darauf und wählen Sie den **@workspace**-Agent oder aktivieren Sie den **Agent Mode** über dem Chat-Eingabefeld.

### 3. Modell auswählen

Klicken Sie auf das Modell-Symbol im Chat-Header (normalerweise zeigt es das Standard-Modell). Wählen Sie Ihr Ollama-Modell aus:

- **Ollama** → Ihr bevorzugtes Modell (z.B. "phi4-reasoning:14b")
- **LM-Studio** → Falls konfiguriert

### 4. Chat-Anfrage stellen

Im Agent Mode können Sie nun Anfragen stellen. Das ausgewählte lokal verfügbare Modell verarbeitet die Anfrage:

```
@workspace Erstelle eine React-Komponente für ein Login-Formular
```

### 5. Agentenaktionen nutzen

Der Agent im Workspace-Modus kann:
- ✅ Dateien durchsuchen
- ✅ Code-Struktur analysieren
- ✅ Vorschläge machen
- ✅ Mit dem Dateisystem interagieren

### Tipps für optimale Ergebnisse

**Gute Prompts für lokale Modelle:**
- Seien Sie spezifisch und klar
- Geben Sie Kontext über `@workspace` oder `@file` an
- Nutzen Sie Code-Snippets für besseres Verständnis

**Agent-Mode Besonderheiten:**
- Der Agent hat Zugriff auf Ihren Code-Kontext
- Tool-Calling sollte für reflexive Aufgaben aktiviert sein
- Längere Prompts sind bei kleineren Modellen weniger effizient

---

## Automatische Modell-Synchronisation mit Ollama-Sync Skill

Der **Ollama-Sync Skill** aktualisiert automatisch Ihre `chatLanguageModels.json` mit allen verfügbaren Modellen vom Ollama-Server.

### Was macht der Skill?

1. Verbindet sich mit Ihrem Ollama-Server
2. Liest alle installierten Modelle aus
3. Berechnet automatisch angemessene Token-Limits basierend auf Modellgröße
4. Aktualisiert die `chatLanguageModels.json`
5. Entfernt nicht mehr verfügbare Modelle

### Installation

Der Skill befindet sich im Verzeichnis: `ollama-sync/`

Dateien:
- `SKILL.md` - Skill-Dokumentation für GitHub Copilot
- `sync-ollama-models.ps1` - PowerShell-Script zur manuellen Synchronisation

### Verwendung im Copilot Chat

Fragen Sie den Copilot einfach:

```
Synchronisiere die Ollama-Modelle
```

oder

```
Aktualisiere verfügbare Modelle
```

Der Skill wird:
- Den Ollama-Server abfragen
- Alle Modelle auflisten
- Token-Limits automatisch berechnen
- Ihre Konfiguration aktualisieren

### Manuelle Synchronisation (PowerShell)

Falls Sie den Skill nicht über Copilot nutzen möchten:

```powershell
cd C:\Users\blazo\source\Feuerwerk
.\ollama-sync\sync-ollama-models.ps1
```

**Optionale Parameter:**

```powershell
# Anderer Ollama-Server
.\ollama-sync\sync-ollama-models.ps1 -OllamaUrl "http://192.168.178.100:11434"

# Andere Konfigurationsdatei
.\ollama-sync\sync-ollama-models.ps1 -ConfigPath "C:\custom\path\chatLanguageModels.json"
```

### Script-Ausgabe

```
Synchronisiere Ollama-Modelle von http://192.168.178.42:11434...
Gefundene Modelle: 4
  - phi4-reasoning:14b (14.7B, 65536/16384 Tokens)
  - qwen3-coder:30b (30.5B, 131072/32768 Tokens)
  - gpt-oss:20b (20.9B, 131072/32768 Tokens)
  - deepseek-r1:8b (8.2B, 32768/8192 Tokens)

✓ 4 Modelle erfolgreich synchronisiert
```

---

## Häufige Probleme und Lösungen

### Problem: Modelle werden nicht angezeigt

**Lösung 1:** VS Code neu laden
```
Ctrl+Shift+P → Developer: Reload Window
```

**Lösung 2:** Ollama-Server erreichbar?
```powershell
curl http://192.168.178.42:11434/api/tags
```

**Lösung 3:** Konfiguration überprüfen
- Hat die Datei das richtige JSON-Format?
- Sind Kommas korrekt platziert?
- Existiert das `models`-Array?

### Problem: Verbindungsfehler beim Chat

**Lösung:** URL und Port überprüfen
```json
{
  "url": "http://192.168.178.42:11434"  // Keine Port-Redundanz!
}
```

### Problem: Token-Limits sind zu gering

**Lösung:** Der Skill berechnet diese automatisch. Alternativ manuell erhöhen:
```json
{
  "maxInputTokens": 262144,
  "maxOutputTokens": 65536
}
```

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
Nur Modelle mit aktiviertem Tool-Calling können als Agent arbeiten und auf den Workspace zugreifen. Basis-Modelle ohne diese Fähigkeit sind ausschließlich im Ask-Mode verfügbar.

**Für Ollama-Modelle gilt:**
Die meisten aktuellen Modelle unterstützen Tool-Calling standardmäßig. Falls ein Modell nicht im Agent-Mode erscheint, nutzen Sie es im Ask-Mode für einfache Fragen ohne Workspace-Zugriff.

---

## Weitere Modelle installieren

### Mit Ollama CLI

```bash
ollama pull qwen2.5-coder
ollama pull llama2
ollama pull neural-chat
```

### Server-weit verfügbar

Wenn Ollama auf einem Netzwerk-Server läuft (z.B. `192.168.178.42`), sind neue Modelle sofort für alle verfügbar, die den Server nutzen.

### Modell-Synchronisation

Nach Installation neuer Modelle einfach synchronisieren:
```
Copilot Chat: Synchronisiere die Ollama-Modelle
```

---

## Best Practices

✅ **Team-Konfiguration:**
- Speichern Sie `.vscode/settings.json` im Git-Repository
- Alle Entwickler nutzen den gleichen Modell-Stack

✅ **Regelmäßige Synchronisation:**
- Führen Sie `sync-ollama-models.ps1` nach neuen Installationen aus
- Der Skill hilft, alte Modelle aus der Konfiguration zu entfernen

✅ **Modellauswahl:**
- CodeLLaMa oder Qwen-Coder für Code-Aufgaben
- Phi4-Reasoning für komplexes Reasoning
- Deepseek-R1 für technisches Debugging

✅ **Ressourcen optimieren:**
- Größere Modelle (>20B) auf stärkeren Maschinen
- Kleinere Modelle (<10B) für schnelle Antworten

---

## Zusammenfassung

| Funktion | Workspace | Benutzer |
|----------|-----------|----------|
| Gültig für | Aktuelles Projekt | Alle Projekte |
| Speicherort | `.vscode/settings.json` | AppData Profil |
| Git-versionierbar | ✅ Ja | ❌ Nein |
| Teamfähig | ✅ Ja | ❌ Nein |

Mit der Ollama-Integration und dem Ollama-Sync Skill haben Sie nun:
- ✅ Vollständige Privatsphäre Ihrer Daten
- ✅ Offline-Verfügbarkeit
- ✅ Automatische Modell-Verwaltung
- ✅ Nahtlose Integration in Copilot Chat
