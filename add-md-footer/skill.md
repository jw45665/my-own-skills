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

### Eine einzelne Datei verarbeiten:

```powershell
.\.github\skills\add-md-footer\add-md-footer.ps1 -Path ".\Minimale ASP.NET Core App für statische Dateien.md"
```

### Existierende Footer aktualisieren (-Force):

```powershell
.\.github\skills\add-md-footer\add-md-footer.ps1 -Path "." -Force
```

## 📋 Parameter

| Parameter | Typ | Standard | Beschreibung |
|-----------|-----|----------|-------------|
| `-Path` | string | `.` (aktuelles Verz.) | Pfad zum Verzeichnis oder zur MD-Datei |
| `-Force` | switch | `false` | Existierende Footer werden aktualisiert |

## ✨ Features

- ✅ **Automatische Titel-Erkennung** aus der ersten `#`-Überschrift
- ✅ **Aktuelles Datum** wird automatisch eingefügt (DD.MM.YYYY)
- ✅ **Duplikat-Schutz** (verhindert mehrfache Footer)
- ✅ **UTF-8 Encoding** für deutsche Umlaute
- ✅ **Übersichtliches Logging** mit Farben
- ✅ **Force-Modus** zum Aktualisieren existierender Footer

## 📊 Beispiel-Output

```
🔧 MD-Footer Skill: Starte Verarbeitung...
📁 Verzeichnis gefunden: .
📄 Gefundene MD-Dateien: 3
✅ Verarbeitet: Minimale ASP.NET Core App für statische Dateien.md
✅ Verarbeitet: Pure React und Vite vs. React NET Apps.md
⏭️  Übersprungen: Dokumentation.md (Footer existiert)

📊 Zusammenfassung:
   ✅ Verarbeitet: 2
   ⏭️  Übersprungen: 1
📅 Heutiges Datum: 01.03.2026
```

## 🔧 Fehlerbehebung

### "Skripts sind auf diesem System deaktiviert"

Falls du eine Ausführungsrichtlinien-Warnung erhältst:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Footer wird nicht korrekt erkannt

Stelle sicher, dass deine MD-Datei mit einer `#`-Überschrift beginnt:

```markdown
# Mein Dokumenttitel

Inhalt...
```

## 📝 Lizenz

Ressource von https://ki-coder.de. © JW 2026
