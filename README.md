# my-skills

Eine Sammlung von AI Agent Skills für die automatisierte Unterstützung verschiedener Aufgaben.

## 📋 Skills

| #  | Titel                          | Funktion                                                                                                                                                                            | Trigger                                                                                                                                                        |
|----|--------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1  | **Add-MD-Footer**             | Versieht Markdown-Dateien automatisch mit einem standardisierten Footer (Titel + Datum)                                                                                           | "Ergänze die MD-Datei um den Footer" / "Füge Footer hinzu" / "Versehe die Markdown mit Footer"                                                                                                  |
| 2  | **Environment Detector**       | Automatische Erkennung von Umgebungsinformationen wie OS, Python/Node.js Versionen, VS Code, Extensions und MCP Server für Metadaten-Konfigurationen                    | `python skills/environment-detector/detect_env.py --merge data/model-metadata.json` / "Erkenne die Umgebungsinformationen" |
| 3  | **Image Downloader**           | Automatisiert das Finden und Herunterladen von lizenzfreien Bildern mit Browser-Unterstützung, Cookie-Akzeptanz, Varianten-Generierung und Lizenzangaben       | `python skills/image-downloader/image_skill.py --search "..." --out-base assets/images/...` / "Lade ein Bild herunter" |
| 4  | **KI-Club Adaptive Theming**  | Implementiert ein dynamisches, CSS-Variablen-basiertes Theme-System für Websites mit Theme-Switcher UI und LocalStorage-Persistenz                                                | Verwendung, wenn Theme-System für Website benötigt wird, Dark/Light-Mode implementiert werden soll oder Bootstrap-Theme-Integration erforderlich ist |
| 5  | **LM Studio Model Sync**      | Synchronisiert automatisch die verfügbaren LM-Studio-Modelle mit der chatLanguageModels.json Konfiguration                                                                          | "Synchronisiere die LM-Studio-Modelle" / "Aktualisiere LM-Studio Modelle" / "Stelle die LM Studio Modelle bereit"                                     |
| 6  | **Ollama Model Sync**         | Synchronisiert automatisch die verfügbaren Ollama-Modelle mit der chatLanguageModels.json Konfiguration                                                                             | "Synchronisiere die Ollama-Modelle" / "Aktualisiere die Ollama-Modelliste" / "Stelle die verfügbaren Ollama-Modelle bereit"                            |

---

## 🔧 Über Skills

AI Agent Skills sind spezialisierte Module, die von AI-Assistenten verwendet werden, um spezifische Aufgaben automatisiert auszuführen. Jeder Skill kann durch bestimmte Benutzeranforderungen oder automatische Trigger aktiviert werden und führt vordefinierte Operationen durch, um die gewünschten Ergebnisse zu liefern.

---

<!-- Footer -->
<div style="text-align: center; font-size: 0.8em; color: #666; margin-top: 2em;">
  <p style="margin:0;">my-skills</p>
  <p style="margin:0; font-size: 0.9em;">© JW 2026 | Stand: 01.03.2026</p>
</div>