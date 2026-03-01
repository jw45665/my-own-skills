---
name: image-downloader
displayName: Image Downloader
description: Automatisiert das Finden und Herunterladen von lizenzfreien Bildern mit Browser-Unterstützung, Cookie-Akzeptanz, Varianten-Generierung und automatischer Lizenzangabe
version: 1.0.0
author: JW
---

# 🖼️ Image Downloader Skill

Dieses Skill automatisiert das Finden und Herunterladen von lizenzfreien Bildern (z.B. von Unsplash/Pexels) inklusive optionaler Annahme von Cookie-Bannern per Playwright und sichert Lizenzangaben in `assets/credits.md`.

## 📋 Features

- ✅ Browser-gestützte Suche & Cookie-Akzeptanz (Playwright)
- ✅ Extraktion von `src` / `srcset` / EXIF Metadaten (Unsplash)
- ✅ Robuster Downloader mit User-Agent + Referer + Pillow-basierter Varianten-Generierung (640/1280 + WebP)
- ✅ Automatische Lizenzangaben in `assets/credits.md`
- ✅ Optionale Aktualisierung von `data/model-metadata.json`

## 🚀 Verwendung

### 1. Vorbereitung: Virtual Environment und Dependencies

```bash
python -m venv .venv
source .venv/bin/activate  # oder .venv\Scripts\Activate.ps1 on Windows
pip install -r skills/image-downloader/requirements.txt
playwright install
```

### 2. Bild nach URL herunterladen

```bash
python skills/image-downloader/image_skill.py --page-url "https://unsplash.com/de/fotos/..." --out-base assets/images/hero-3
```

### 3. Bild nach Suchbegriff (headless - Standard)

```bash
python skills/image-downloader/image_skill.py --search "artificial intelligence" --pick 1 --out-base assets/images/feature-2
```

### 4. Bild nach Suchbegriff (sichtbarer Browser für Demo)

```bash
python skills/image-downloader/image_skill.py --search "artificial intelligence" --pick 1 --out-base assets/images/feature-2 --no-headless
```

### 5. Interaktive Demo

```bash
python scripts/image_skill_cli.py --demo
```

## ⚠️ Ethik und Best Practices

- Respektiere `robots.txt` und die Nutzungsbedingungen von Bildanbietern
- Umgehe keine Paywalls oder CAPTCHAs
- Nutze offizielle APIs (Unsplash/Pexels) wenn möglich und autorisiert
- Speichere immer Lizenzmetadaten
- Überprüfe die Lizenz vor der Veröffentlichung

## 📁 Dateien

- `image_skill.py` — Hauptskript des Skills
- `requirements.txt` — Liste der Abhängigkeiten
- `config.example.json` — Beispielkonfiguration mit Platzhaltern für API-Schlüssel

## 💾 Nach dem Download

Stelle sicher, dass du folgende Dateien aktualisierst:
- `assets/credits.md` — Lizenzangaben für heruntergeladene Bilder
- `data/model-metadata.json` — Metadaten-Informationen (falls erforderlich)
