---
description: 'Copilot-Anweisungen für komponentenbasierte statische Webentwicklung mit Blazor/MAUI-Migration'
applyTo: '**/*.html, **/*.js, **/*.css'
---

## Projektüberblick

Dieses Template dient der **MVP-first Entwicklung** einer statischen Website mit **komponentenbasierter Architektur**, die nahtlos zu **Blazor (hybrid)**, **React** oder **.NET MAUI** migriert werden kann.

**Primäres Ziel:** Schnellstmögliche Entwicklung eines MVP → vollständige Website → Blazor/MAUI-Anwendung || React-App

**Architektur-Philosophie:**
- **Atomic Components**: Jede Funktionalität wird als eigenständige, isolierte Komponente entwickelt
- **Selbstständige Module**: Jede Komponente enthält HTML, CSS und JavaScript in abgeschlossenen Modulen
- **Blazor-Ready**: Struktur und Patterns sind für .razor-Komponenten optimiert
- **Zero-Breaking Migration**: Komponenten können 1:1 zu Blazor- bzw. React-Komponenten konvertiert werden

**Website-Anforderungen:**
- Responsiv (Desktop/Tablet/Mobile)
- Vollständige Touch/Maus/Tastatur-Bedienung  
- Light/Dark-Mode Support
- Performance-optimiert für MVP-Geschwindigkeit

## Komponentenarchitektur (Kern-Kontrakt)

### Dateistruktur pro Komponente
```
src/components/
├── [component-name]/
│   ├── [component-name].html     # Template mit {{prop}} Platzhaltern
│   ├── [component-name].css      # Scoped Styles (CSS-Module Pattern)
│   └── [component-name].js       # Komponentenlogik + Event-Handler
└── shared/                       # Wiederverwendbare Styles/Utils
    ├── variables.css             # CSS Custom Properties
    ├── utilities.css             # Utility Classes
    └── base.css                  # Reset + Grundstyles
```

### Komponenten-Konventionen

**HTML-Template (`[component].html`):**
- Verwende `{{prop}}` für dynamische Werte
- Einzelnes Root-Element mit `data-component="[name]"` 
- Semantische HTML-Struktur (Header, Main, Section, etc.)
- ARIA-Attribute für Accessibility

**CSS-Module (`[component].css`):**
- Scoped über `.component-[name]` Präfix
- CSS Custom Properties für konfigurierbare Werte  
- BEM-Methodologie für Klassen-Namen
- Mobile-First Media Queries

**JavaScript-Module (`[component].js`):**
- ES6-Module Export: `export class ComponentName {}`
- Lifecycle-Methoden: `init()`, `destroy()`, `update(props)`
- Event-Handler als Klassen-Methoden
- Keine globalen Variablen

### Shell-Integration
- Host-Elemente nutzen `data-component="[name]"` + `data-*` für Props
- `src/main.js` lädt Komponenten aus `COMPONENTS_PATH = 'src/components'`
- Automatisches CSS/JS-Loading pro Komponente
- Props-Validation und Type-Safety

### Sicherheit
- **Kritisch:** Alle `data-*` Werte sind untrusted
- **Niemals:** Direktes `innerHTML` ohne Sanitization
- **Verwende:** DOMPurify für HTML-Content oder `textContent`

## Blazor/MAUI-Migration Guidelines

### Komponentenbasierte Entwicklung für .razor-Konvertierung

**Aktuelle Struktur → Blazor Mapping:**
```
[component].html     → [Component].razor (HTML Section)
[component].css      → [Component].razor.css (Scoped Styles)  
[component].js       → [Component].razor.cs (Code-Behind)
```

**Blazor-Ready Patterns:**
- **Props**: `data-*` Attribute → `[Parameter]` Properties
- **Events**: Custom Events → `EventCallback<T>`
- **State**: Local Variables → Component State
- **Lifecycle**: `init()/destroy()` → `OnInitialized()/Dispose()`

### Entwicklungsrichtlinien für Migration

**HTML-Template (→ .razor):**
```html
<!-- Aktuell: component.html -->
<div class="component-card" data-component="card">
  <h3>{{title}}</h3>
  <p>{{content}}</p>
  <button data-action="{{action}}">{{buttonText}}</button>
</div>

<!-- Blazor-Ziel: Card.razor -->
<div class="component-card">
  <h3>@Title</h3>
  <p>@Content</p>
  <button @onclick="HandleClick">@ButtonText</button>
</div>
```

**CSS-Scoping (→ .razor.css):**
```css
/* Aktuell: component.css */
.component-card {
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
}

/* Blazor-Ziel: Card.razor.css (automatisch scoped) */
.component-card {
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius);
}
```

**JavaScript-Logic (→ .razor.cs):**
```javascript
// Aktuell: component.js
export class Card {
  init(element, props) {
    this.element = element;
    this.props = props;
  }
  
  handleClick() {
    // Event logic
  }
}

// Blazor-Ziel: Card.razor.cs
public partial class Card : ComponentBase
{
  [Parameter] public string Title { get; set; }
  [Parameter] public string Content { get; set; }
  [Parameter] public EventCallback OnClick { get; set; }
  
  private async Task HandleClick()
  {
    await OnClick.InvokeAsync();
  }
}
```

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

### Entwickler-Workflows

- **Starten/Testen**: `index.html` direkt im Browser öffnen; optional
  statischen Server verwenden (z. B. wegen CORS).
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

- Theme in `localStorage`
- Performance und Zugänglichkeit priorisieren (Lazy-Loading, reduzierte Motion
  respektieren, sinnvolle Landmark-Struktur).
- Änderungen stets gegen Responsiveness, Tastatur-/Touch-Bedienung und
  Kontrast prüfen

## Sicherheits‑Kernregeln (1‑Satz jeweils)

- Alle `data-*` Werte als untrusted behandeln; keine direkte `innerHTML`‑Zuweisung ohne Sanitizer.
- Keine Secrets in `package.json` oder Skripten; verwende environment variables / GitHub Secrets.
- Fehler‑Logs in Issues nur mit sensiblen Daten redacted.

## Konkrete Grenzen (was nicht geändert werden darf ohne PR‑Note)

- Keine Breaking‑Änderungen an `index.html` Shell API ohne RFC/PR und Migrationshinweis.
- Wenn die Template‑Syntax (`{{...}}`) geändert wird, ergänze `src/main.js` in derselben PR und dokumentiere die Migration.

## Quick troubleshooting checklist

- Keine Seite? Läuft `npm run start`? Wenn nein: `npm install` → prüfe Errors.
- Komponenten laden nicht? Existiert `src/components/<name>.html`? Ist `COMPONENTS_PATH` relativ?
- XSS‑Risiko? Wird `innerHTML` verwendet? Wenn ja, warum?

## Befugnisse

- Erstelle Issues, Branches und PRs. Kleine Komponenten/Docs dürfen per PR hinzugefügt werden. Shell‑API Änderungen nur mit Review.

---




