---
applyTo: '**'
description: 'Copilot-Anweisungen für statische Webseiten (HTML, CSS, JS) ohne Build-Tools oder Frameworks.'
---
## Copilot-Anweisungen für statische Webseiten (HTML, CSS, JS)

### Projektüberblick

Dieses Dokument beschreibt ein Template für reine Frontend-Anwendungen
(HTML, CSS, JS) ohne Build-Tools, Frameworks oder externe Abhängigkeiten.
Die Anwendung läuft vollständig clientseitig direkt im Browser.

Die Website muss:
- responsiv sein und auf Desktop, Tablets und Smartphones optimal dargestellt
  werden,
- vollständig mit Touch, Maus und Tastatur bedienbar sein,
- einen Light- und Dark-Mode unterstützen.

### Architektur & Hauptbestandteile

- **index.html**: Grundgerüst der Seite, semantische Struktur (header, nav,
  main, section, footer), Navigation/App-Shell.
- **style.css**: Modernes, responsives Design mit CSS-Variablen, Flexbox/Grid,
  Media Queries und Light-/Dark-Mode.
- **script.js**: Interaktionen, Navigation (falls vorhanden), Fokus-Management,
  ARIA-Attribute, Tastatur-/Touch-Handhabung und Theme-Umschaltung
  (Persistenz in `localStorage`).

Optional können weitere HTML-Seiten oder UI-Komponenten ergänzt werden, bleiben
aber weiterhin ohne Build-Schritt.

### Wichtige Patterns & Konventionen

- **Semantisches HTML**: Nutze sinnvolle Tags, Landmark-Roles und Labels.
- **Responsives Design**:
  - Mobile-First, flüssige Layouts, CSS Grid/Flexbox.
  - Media Queries für Telefon/Tablet/Desktop-Breakpoints.
  - Bilder/Medien responsiv bereitstellen.
- **Bedienung (Touch/Maus/Tastatur)**:
  - Sichtbarer Fokuszustand, sinnvolle Tab-Reihenfolge.
  - Tastatursteuerung (Enter/Space, Pfeiltasten bei Widgets).
  - Touch-Ziele ausreichend groß; Pointer- und Keyboard-Events berücksichtigen.
- **Accessibility (A11y)**:
  - ARIA nur ergänzend, wenn Semantik nicht ausreicht.
  - Kontraste, Alternativtexte, sinnvolle Link-/Button-Beschriftungen.
- **Theme (Light/Dark)**:
  - Umschaltung per Button; Zustand in `localStorage` speichern.
  - Systempräferenz `prefers-color-scheme` respektieren.
  - Farben über CSS-Variablen definieren.
- **Keine externen Abhängigkeiten**: Nur HTML, CSS und JS.

### Entwickler-Workflows

- **Starten/Testen**: `index.html` direkt im Browser öffnen; optional
  statischen Server verwenden (z. B. wegen CORS).
- **Inhalte anpassen**: Struktur in `index.html`, Styles in `style.css`,
  Verhalten in `script.js`.
- **Design anpassen**: CSS-Variablen und Media Queries in `style.css`.
- **Responsiveness prüfen**: DevTools Device-Emulation für gängige Viewports.
- **Accessibility prüfen**: Tastaturbedienung, Screenreader, Kontrast-Checks.

### Beispiele

- Theme-Umschaltung (JS):
```js
const root = document.documentElement;
const themeToggle = document.getElementById('theme-toggle');

function applyTheme(t) {
  root.setAttribute('data-theme', t);
  localStorage.setItem('theme', t);
}

applyTheme(localStorage.getItem('theme') ||
           (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'));

themeToggle?.addEventListener('click', () => {
  const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  applyTheme(next);
});
```

- Theme-Variablen (CSS):
```css
:root {
  --bg: #ffffff;
  --fg: #111111;
  --accent: #2563eb;
}

:root[data-theme="dark"] {
  --bg: #0b0f14;
  --fg: #e5e7eb;
  --accent: #60a5fa;
}

html, body { background: var(--bg); color: var(--fg); }
```

- Grundstruktur (HTML):
```html
<header>
  <nav aria-label="Hauptnavigation">
    <!-- Links -->
  </nav>
</header>
<main id="content" tabindex="-1">
  <!-- Seiteninhalt -->
</main>
<footer>
  <!-- Footer -->
</footer>
```

### Hinweise

- Keine serverseitige Logik, keine APIs, keine Datenpersistenz außer z. B.
  Theme in `localStorage`.
- Performance und Zugänglichkeit priorisieren (Lazy-Loading, reduzierte Motion
  respektieren, sinnvolle Landmark-Struktur).
- Änderungen stets gegen Responsiveness, Tastatur-/Touch-Bedienung und
  Kontrast prüfen.
