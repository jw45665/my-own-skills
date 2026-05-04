# my-skills

Eine Sammlung von AI Agent Skills für die automatisierte Unterstützung verschiedener Aufgaben.

## 📋 Skills

| # | Titel | Funktion | Trigger |
|---|---|---|---|
| 1 | **Add-MD-Footer** | Versieht Markdown-Dateien mit einem standardisierten Footer (Titel + Datum). | "Ergänze die MD-Datei um den Footer" / "Füge Footer hinzu" |
| 2 | **Buchformat & Artikel** | Erstellt strukturierte Buchkapitel und Fachartikel im definierten Buch-Layout. | "Erstelle ein Kapitel im Buchformat" / "Schreibe einen Artikel im Buchformat" |
| 3 | **Environment Detector** | Erkennt automatisch OS-, Tool-, IDE- und MCP-Umgebungsinformationen für Metadaten. | `python skills/environment-detector/detect_env.py --merge data/model-metadata.json` |
| 4 | **Image Downloader** | Findet und lädt lizenzfreie Bilder inkl. Credits und Varianten (z. B. WebP). | `python skills/image-downloader/image_skill.py --search "..." --out-base assets/images/...` |
| 5 | **KI-Club Adaptive Theming** | Implementiert ein dynamisches CSS-Variablen-Theme-System mit Theme-Switcher. | "Implementiere ein Theme-System" / "Füge Dark/Light-Mode hinzu" |
| 6 | **LM Studio Model Sync** | Synchronisiert verfügbare LM-Studio-Modelle in die `chatLanguageModels.json`. | "Synchronisiere die LM-Studio-Modelle" |
| 7 | **Ollama Model Sync** | Synchronisiert verfügbare Ollama-Modelle in die `chatLanguageModels.json`. | "Synchronisiere die Ollama-Modelle" |
| 8 | **Publish to IIS** | Veröffentlicht ein Vite/React-Projekt auf IIS per Web Deploy mit Verifikation. | "Deploye auf IIS" / "Publish to IIS" |
| 9 | **Social Media Postings** | Erstellt plattformspezifische Social-Media-Beiträge mit Hashtags und CTA. | "Erstelle einen LinkedIn-/Facebook-/X-Post" |
| 10 | **VS-F5 React/Vite Enable** | Aktiviert F5-Start und Debug-Konfiguration für React/Vite in Visual Studio und VS Code. | "Ich möchte die Anwendung in VS mit F5 starten können" / "React/Vite in Visual Studio debuggen" |
| 11 | **VS Template Agent** | Erstellt, installiert und validiert robuste Visual-Studio-Projekt- und Item-Templates. | "Erstelle ein Visual-Studio-Template" / "Template aus bestehendem Projekt erzeugen" |

## 📄 Dokumente

| # | Dokument | Pfad |
|---|---|---|
| 1 | **LM Studio Modelle in VS Code verwenden** | `DOCS/LM Studio Modelle in VS Code verwenden.md` |
| 2 | **Wie man die (lokal) verfügbaren Ollama-Modelle abruft und in VS Code (automatisch) bereitstellt** | `DOCS/Wie man die (lokal) verfügbaren Ollama-Modelle abruft und in VS Code (automatisch) bereitstellt.md` |

---

## 🔧 Über Skills

AI Agent Skills sind spezialisierte Module, die von AI-Assistenten verwendet werden, um spezifische Aufgaben automatisiert auszuführen. Jeder Skill kann durch bestimmte Benutzeranforderungen oder automatische Trigger aktiviert werden und führt vordefinierte Operationen durch, um die gewünschten Ergebnisse zu liefern.

---

<!-- Footer -->
<div style="text-align: center; font-size: 0.8em; color: #666; margin-top: 2em;">
  <p style="margin:0;">my-skills</p>
  <p style="margin:0; font-size: 0.9em;">© JW 2026 | Stand: 01.03.2026</p>
</div>