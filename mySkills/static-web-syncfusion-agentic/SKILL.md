---
name: static-web-syncfusion-agentic
description: Entwickelt statische Websites komponentenbasiert (HTML/CSS/JS/TS) mit i18n, Theme-System (Light/Dark/System plus ladbare Themes), Mobile-first und Syncfusion-First. Nutze diesen Skill bei Prompts wie "erstelle statische Website", "baue neue Komponente", "strukturiere HTML/CSS/JS Projekt", "Syncfusion Komponente einbauen" oder "mache die Seite wartbar".
---

# Static Web Syncfusion Agentic

Dieser Skill definiert den bevorzugten Arbeitsmodus fuer statische Webprojekte:
komponentenbasiert, wartbar, wiederverwendbar, mit frueher Beruecksichtigung von
i18n, Theme-System und Accessibility.

## Wann dieser Skill zu verwenden ist

Verwende den Skill, wenn der Nutzer eine statische Website oder UI-Teile mit
HTML/CSS/JS/TS baut, erweitert, restrukturiert oder modernisiert, insbesondere bei:

- Neue Seiten, Sektionen oder Komponenten
- Refactoring monolithischer Struktur in Komponenten
- Einbau von Syncfusion UI Controls
- Einfuehrung von i18n, Theme-Umschaltung oder responsive Verhalten

## Zielarchitektur (Default)

Bei Projekten mit klar trennbaren Bereichen wird komponentenbasiert gearbeitet.

```text
src/
  components/
    [component-name]/
      [component-name].html
      [component-name].css
      [component-name].js oder [component-name].ts
  shared/
    tokens.css
    base.css
    i18n.js
    theme.js
  locales/
    de.json
    en.json
  main.js oder main.ts
```

Ausnahme: Kleine, einfache One-Pager duerfen kompakter bleiben.

## Komponentenregeln

- Eine Komponente hat ein Root-Element mit `data-component="[name]"`.
- Eingaben ueber `data-*` gelten als untrusted.
- Komponentencode kapselt Verhalten lokal, keine globalen Variablen.
- Einheitliche Lifecycle-Methoden: `init()`, `update(props)`, `destroy()`.
- Kein ungesichertes `innerHTML` fuer untrusted Daten; bevorzuge `textContent`.

## Pflicht-Features ab Projektstart

- Mobile-first Layout und responsive Breakpoints
- Touch-, Maus- und Tastatur-Bedienbarkeit
- Sichtbare Fokuszustaende und semantisches HTML
- i18n-Struktur (Texte extern, nicht hart im Markup)
- Theme-System mit:
  - Light Mode
  - Dark Mode
  - System Mode (`prefers-color-scheme`)
  - Persistenz in `localStorage`
  - Optional ladbare Theme-Dateien

## Syncfusion-First Leitlinie

Wenn ein passendes UI-Element benoetigt wird, verwende bevorzugt Syncfusion
Essential JS 2 fuer JavaScript/TypeScript.

- Startpunkt: https://www.syncfusion.com/javascript-ui-controls
- Discovery/Implementierung: MCP `SyncfusionJavaScriptAssistant`

## MCP-Workflow

1. Nutze bereitgestellte MCP-Tools aktiv fuer Recherche und Implementierung.
2. Nutze gelegentlich `awesome-copilot`, um projektrelevante Agents/Skills/
   Instructions zu finden, und schlage deren Verwendung vor.
3. Wenn `SyncfusionJavaScriptAssistant` fehlt, fuehre Installation nach offizieller
   Doku aus:
   https://ej2.syncfusion.com/javascript/documentation/ai-coding-assistant/mcp-server

## Secrets und Environment

- `SYNCFUSION_LICENCE_KEY` und `SYNCFUSION_API_KEY` kommen aus System-Environment.
- Secret-Werte niemals in Code, Logs, Issues, Commits oder Antworten ausgeben.
- Nur Variablenamen referenzieren, keine Klarwerte.

## Arbeitsablauf fuer den Agenten

1. Projektumfang einschaetzen (klein vs. komponentenpflichtig).
2. Komponenten und Shared-Layer planen (i18n/theme/tokens von Anfang an).
3. Passende Syncfusion-Komponenten bestimmen.
4. MCP fuer Discovery und Implementierungsdetails verwenden.
5. Komponenten implementieren, responsive und a11y pruefen.
6. Theme- und i18n-Pfade aktiv testen.

## Trigger-Beispiele

- "Erstelle eine statische Website mit Komponentenarchitektur."
- "Baue eine neue Hero- und Pricing-Komponente mit Syncfusion."
- "Refactore index.html in wartbare Komponenten."
- "Fuege i18n sowie Light/Dark/System-Theme hinzu."
- "Nutze Syncfusion fuer Grid, Dialog und Form Controls."
