---
name: buchformat-artikel
description: >
  Befähigt jeden Agenten, einen Artikel oder ein Buchkapitel im festgelegten Buch-Layout zu verfassen – als Kapitel eines laufenden Werks oder als eigenständigen Zeitschriften- bzw. Blogartikel. Verwende diesen Skill, wenn strukturierter Fließtext im Buchformat erstellt, überarbeitet oder in ein Veröffentlichungsformat überführt werden soll.
---

# Skill: Buchformat & Artikel

Dieser Skill definiert das vollständige Schreib- und Strukturformat für Buchkapitel und Fachartikel. Er ist sowohl für Kapitel in einem laufenden Buchprojekt als auch für eigenständige Veröffentlichungen (Zeitschrift, Blog, Online-Magazin) konzipiert.

---

## 1  Frontmatter-Vorlage

Jede Datei beginnt mit einem YAML-Frontmatter-Block:

```yaml
---
post_title: "Vollständiger Kapiteltitel oder Artikeltitel"
author1: ""
post_slug: "url-freundlicher-slug-in-kleinbuchstaben"
categories: ["Hauptkategorie", "Unterkategorie"]
tags: ["Tag1", "Tag2", "Tag3"]
ai_note: true
summary: "Kurzbeschreibung in 1–2 Sätzen (max. 160 Zeichen für SEO)"
post_date: 2026-05-01
---
```

Pflichtfelder: `post_title`, `post_slug`, `summary`, `post_date`.  
`ai_note: true` kennzeichnet KI-unterstützte Inhalte.

---

## 2  Textstruktur

### Hierarchie

```
# Kapiteltitel (h1, nur einmal pro Datei)
## Abschnitt (h2)
### Unterabschnitt (h3)
#### Detail-Ebene (h4, sparsam einsetzen)
```

### Fließtext-Prinzip

Das zentrale Qualitätsmerkmal dieses Formats ist fließender, leserbindender Text:

- **Kein unkontextualisiertes Aufzählen**: Jede Liste wird durch einen einleitenden Satz eingeleitet und nach der Liste kommentiert oder ausgewertet.
- **Vollständige Sätze**: Keine Stichworte, keine fragmentierten Aussagen.
- **Narrative Kohärenz**: Jeder Abschnitt schließt an den vorherigen an. Der Leser soll nicht springen, sondern geführt werden.
- **Progressives Offenlegen**: Komplexe Konzepte werden schrittweise eingeführt, nicht als Informationsblock präsentiert.
- **Emotionale Verbindung**: Der Leser wird dort abgeholt, wo er steht – Bedenken werden anerkannt, Fortschritte gewürdigt.

### Listen und Tabellen

Listen und Tabellen sind erlaubt, aber nie ohne Kontext:

```
Einleitender Satz, der erklärt, was die Liste zeigt und warum sie relevant ist.

- Punkt A – mit kurzer Erläuterung
- Punkt B – mit kurzer Erläuterung

Nach der Liste folgt mindestens ein Satz, der das Wesentliche einordnet.
```

---

## 3  Fachbegriffe und Glossar

- Fachbegriffe und Abkürzungen werden beim **ersten Auftreten** kurz erläutert.
- Danach genügt ein Verweis: `(siehe Stichwortverzeichnis)`.
- Neue Begriffe werden nach dem Schreiben in `Booklet/Stichwortverzeichnis.md` eingetragen (alphabetisch, mit Definition und Kapitelreferenz).
- Vor dem Eintragen auf Duplikate prüfen.

---

## 4  Code- und Prompt-Beispiele

### Sprach-Tags (Pflicht)

```bash
# Bash / CLI-Befehl mit erklärendem Kommentar
gh copilot suggest "erstelle eine React-Komponente"
```

```powershell
# PowerShell-Äquivalent für Windows-Nutzer
gh copilot suggest "erstelle eine React-Komponente"
```

```text
# Terminalausgabe (nicht ausführbarer Text)
✔ Suggestion ready
```

```typescript
// TypeScript-Beispiel mit Kommentaren
const greet = (name: string): string => `Hallo, ${name}!`;
```

### Bevorzugte Sprachen

HTML, CSS, JavaScript und TypeScript mit React/Vite – weit verbreitet, für jeden nachvollziehbar. Andere Sprachen nur, wenn das Thema es explizit erfordert.

### Aufbau eines Beispielblocks

1. Einleitender Satz: Was zeigt das Beispiel?
2. Code-Block mit Sprach-Tag und Kommentaren
3. Erklärender Nachsatz: Was ist das Ergebnis, was ist zu beachten?

---

## 5  Praxisboxen

Praxisboxen heben anwendbare Handlungsanweisungen oder typische Fehler hervor:

```markdown
> **Praxisbox: Titel der Box**
>
> Kurze, direkt umsetzbare Anweisung oder Warnung. Maximal 5–7 Zeilen.  
> Kann einen Code-Schnipsel oder einen konkreten CLI-Befehl enthalten.
```

---

## 6  Plattformhinweise

Unterschiede zwischen Plattformen werden nur dann ausgewiesen, wenn sie inhaltlich relevant sind:

```markdown
> **Hinweis für Windows / PowerShell**  
> Unter Windows gilt abweichend: ...
```

```markdown
> **Hinweis für macOS / Linux**  
> Unter macOS/Linux gilt abweichend: ...
```

---

## 7  Format: Buchkapitel vs. Zeitschriftenartikel

| Merkmal | Buchkapitel | Zeitschriften-/Blogartikel |
|---|---|---|
| Länge | 1.500–5.000 Wörter, bei Bedarf aufgeteilt | 800–2.500 Wörter, kompakt |
| Voraussetzungen | Baut auf vorangegangenen Kapiteln auf | In sich abgeschlossen, keine Vorkenntnisse voraussetzen |
| Struktur | h1 Kapiteltitel, h2 Abschnitte, h3 Unterabschnitte | h1 Artikeltitel, h2 Abschnitte (max. 3–4) |
| Verweise | Auf andere Kapitel und Stichwortverzeichnis | Auf externe Quellen und weiterführende Links |
| Ton | Lehrend, schrittweise, Einsteiger bis Profi | Journalistisch, direkter Einstieg, Kernaussage zuerst |
| Einleitung | Überblick + Lernziel des Kapitels | Hook: Frage, These oder konkretes Szenario |
| Abschluss | Zusammenfassung + Ausblick auf nächstes Kapitel | Fazit mit klarer Kernaussage und ggf. Call-to-Action |

### Einleitung Buchkapitel

Die Einleitung eines Buchkapitels enthält:
- Eine kurze Einordnung in den Kontext des Gesamtwerks (1–2 Sätze)
- Das Lernziel: Was kann der Leser nach diesem Kapitel?
- Optional: Ein konkretes Einstiegsszenario oder eine Frage, die das Kapitel beantwortet

### Einleitung Zeitschriftenartikel

Die Einleitung eines Zeitschriftenartikels:
- Beginnt mit einem **Hook**: einer These, einer überraschenden Aussage oder einem konkreten Praxisszenario
- Kommt ohne Vorwissen des Lesers aus
- Nennt in den ersten drei Sätzen das Kernthema

---

## 8  Standard-Fußzeile (Pflicht)

Jede Datei endet mit dieser Fußzeile:

```markdown
---

© 2026 Jörg Walkowiak ([joerg-walkowiak.de](https://joerg-walkowiak.de))  
**Manuskript-Vorabdruck** • Vertraulich • Nur zum persönlichen Gebrauch • Nicht zur Veröffentlichung
```

Für Zeitschriften-/Blogartikel, die zur Veröffentlichung bestimmt sind, entfällt der Vertraulichkeitshinweis:

```markdown
---

© 2026 Jörg Walkowiak ([joerg-walkowiak.de](https://joerg-walkowiak.de))  
Erstveröffentlichung: [Medienname], [Monat Jahr]
```

---

## 9  SEO-Metadaten (optional, für Online-Veröffentlichung)

```markdown
<!-- SEO
title: Prägnanter Seitentitel (max. 65 Zeichen)
description: Meta-Beschreibung (max. 160 Zeichen)
keywords: Begriff1, Begriff2, Begriff3, Begriff4
-->
```

---

## 10  Qualitätscheckliste vor Abgabe

- [ ] Frontmatter vollständig ausgefüllt
- [ ] Titel und Abschnitte in korrekter Hierarchie (h1 → h2 → h3)
- [ ] Fließtext ohne unkontextualisierte Aufzählungen
- [ ] Jede Liste eingeleitet und ausgewertet
- [ ] Alle Code-Blöcke mit Sprach-Tag und Kommentaren
- [ ] Neue Fachbegriffe erklärt oder mit Glossarverweis versehen
- [ ] Plattformhinweise gesetzt, wo inhaltlich relevant
- [ ] Praxisboxen für anwendbare Handlungsanweisungen genutzt
- [ ] Standard-Fußzeile vorhanden
- [ ] Rechtschreib- und Grammatikprüfung
