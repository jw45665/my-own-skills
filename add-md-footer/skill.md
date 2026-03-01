---
name: add-md-footer
description: Versieht Markdown-Dateien mit einem standardisierten Footer (Titel + Datum)
version: 1.0.0
author: JW
---

# 🎯 Add-MD-Footer Skill

Dieser Skill versieht Markdown-Dateien automatisch mit einem standardisierten Footer, der den Titel der Datei und das aktuelle Datum enthält.

## 📝 Footer-Format

```html
---

<!-- Footer -->
<div style="text-align: center; font-size: 0.8em; color: #666; margin-top: 2em;">
  <p style="margin:0;">Dateititel</p>
  <p style="margin:0; font-size: 0.9em;">© JW 2026 | Stand: DD.MM.YYYY</p>
</div>
```

## 🚀 Verwendung

### Alle MD-Dateien in einem Verzeichnis verarbeiten:

```powershell
.\.github\skills\add-md-footer\add-md-footer.ps1 -Path "."
```

... (truncated) ...
