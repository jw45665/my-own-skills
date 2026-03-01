---
name: ki-club-adaptive-theming
description: Implementiert ein dynamisches, CSS-Variablen-basiertes Theme-System für Websites mit Theme-Switcher UI, LocalStorage-Persistenz und Unterstützung für interne sowie externe Themes. Verwende diesen Skill, wenn der Benutzer ein Theme-System für eine Website implementieren möchte, mehrere Farbpaletten benötigt, einen Theme-Umschalter hinzufügen will oder einen Dark/Light-Mode implementieren möchte. Auch verwendbar für Bootstrap-Theme-Integration, Bootswatch-Integration oder das Hinzufügen von KI-Club-artigen Farbschemata zu bestehenden Websites.
---

# KI-Club Adaptive Theming Skill

Dieser Skill ermöglicht die Implementierung eines professionellen, flexiblen Theme-Systems für Websites, inspiriert vom KI-Club.online-Projekt. Das System kombiniert CSS Custom Properties (Variablen) mit einer intelligenten Theme-Engine für nahtlose Umschaltung zwischen verschiedenen Farbpaletten.

## Kernkonzepte

### 1. Hybrid-Theme-Architektur

Das System unterstützt zwei parallele Theme-Modi:

**Interne Themes**: CSS-Variablen-basierte Themes, die inline definiert werden
- Volle Kontrolle über alle Design-Aspekte
- Schnelle Anpassungen ohne externe Dateien
- Ideal für projekt-spezifische Themes

**Externe Themes**: Vollständige CSS-Dateien (z.B. Bootswatch)
- Plug-and-play Integration
- Bootstrap-kompatibel
- Ermöglicht Nutzung von Community-Themes

### 2. CSS-Variablen-System

Jedes Theme definiert konsistente Variablen für ein kohärentes Design:

```css
:root {
  /* Hintergrundfarben */
  --bg-primary: #ffffff;      /* Haupt-Hintergrund */
  --bg-secondary: #f8f9fa;    /* Alternativer Hintergrund */
  --bg-accent: #e9ecef;       /* Akzent-Hintergrund */
  
  /* Textfarben */
  --text-primary: #212529;    /* Haupttext */
  --text-secondary: #6c757d;  /* Sekundärtext */
  
  /* Akzentfarben */
  --accent-color: #dc3545;    /* Primäre Akzentfarbe */
  
  /* Navigation */
  --navbar-bg: #ffffff;       /* Navbar-Hintergrund */
  --navbar-text: #212529;     /* Navbar-Text */
  
  /* Header-spezifisch */
  --header-text: #ffffff;     /* Text in Gradient-Bereichen */
  
  /* Borders und Linien */
  --border-color: #dee2e6;    /* Standard-Rahmenfarbe */
  
  /* Komponenten-spezifisch (optional) */
  --list-item-bg: transparent;
  --list-border: var(--border-color);
  --accordion-collapsed-bg: var(--bg-secondary);
  --accordion-expanded-bg: var(--bg-accent);
}
```

### 3. Theme-Definitionen mit Attribut-Selektoren

Themes werden über `data-theme` Attribute aktiviert:

```css
/* Dunkles Theme */
[data-theme="dark"] {
  --bg-primary: #212529;
  --bg-secondary: #343a40;
  --bg-accent: #495057;
  --text-primary: #ffffff;
  --text-secondary: #adb5bd;
  --accent-color: #dc3545;
  --navbar-bg: #343a40;
  --navbar-text: #ffffff;
  --border-color: #495057;
}

/* KI-Club Style Theme */
[data-theme="ki-default"] {
  --bg-primary: #000000;
  --bg-secondary: #070708;
  --bg-accent: #0f0f12;
  --text-primary: #ffffff;
  --text-secondary: #cfd4d9;
  --accent-color: #dc3545;
  --navbar-bg: #dc3545;
  --navbar-text: #ffffff;
  --border-color: rgba(255,255,255,0.06);
  --list-item-bg: #1f2937;
}

/* Rotes Theme */
[data-theme="red"] {
  --bg-primary: #ffffff;
  --bg-secondary: #fff5f5;
  --bg-accent: #fee2e2;
  --text-primary: #0f1724;
  --text-secondary: #374151;
  --accent-color: #dc2626;
  --navbar-bg: #dc2626;
  --navbar-text: #ffffff;
  --border-color: #fca5a5;
}
```

## Implementierungsschritte

### Schritt 1: HTML-Struktur vorbereiten

Stelle sicher, dass das Bootstrap CSS über ein identifizierbares `<link>` Element geladen wird:

```html
<head>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
        rel="stylesheet" 
        id="bootstrap-css">
</head>
```

### Schritt 2: Theme-CSS hinzufügen

Füge einen `<style id="custom-theme-styles">` Block im `<head>` ein:

```html
<style id="custom-theme-styles">
  /* CSS-Variablen und Theme-Definitionen hier */
  :root {
    /* Standard-Werte */
  }
  
  [data-theme="dark"] { /* ... */ }
  [data-theme="red"] { /* ... */ }
  [data-theme="ki-default"] { /* ... */ }
  
  /* Anwendung der Variablen mit Namespace */
  body:not([data-external-theme]) {
    background-color: var(--bg-primary);
    color: var(--text-primary);
    transition: background-color 0.3s ease, color 0.3s ease;
  }
  
  body:not([data-external-theme]) nav.navbar {
    background-color: var(--navbar-bg) !important;
    transition: background-color 0.3s ease;
  }
  
  body:not([data-external-theme]) .navbar-brand,
  body:not([data-external-theme]) .nav-link {
    color: var(--navbar-text) !important;
  }
  
  /* Weitere Komponenten-Styles */
</style>
```

**Wichtig**: Der Selector `body:not([data-external-theme])` stellt sicher, dass interne Styles nur dann angewendet werden, wenn kein externes Theme aktiv ist.

### Schritt 3: Theme-Engine JavaScript

Implementiere die Theme-Engine vor dem schließenden `</body>` Tag:

```html
<script>
// ===== THEME ENGINE =====
(function() {
  const body = document.body;
  const bootstrapCssLink = document.getElementById('bootstrap-css');
  const customStyles = document.getElementById('custom-theme-styles');
  
  // LocalStorage Keys
  const THEME_KEY = 'website-theme';
  const CSS_KEY = 'website-css';
  
  // ===== INTERNE THEMES =====
  function setInternalTheme(theme) {
    // Standard Bootstrap CSS verwenden
    bootstrapCssLink.href = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css';
    
    // Theme-Attribut setzen
    body.setAttribute('data-theme', theme);
    body.removeAttribute('data-external-theme');
    
    // Custom Styles aktivieren
    customStyles.disabled = false;
    
    // Persistieren
    try {
      localStorage.setItem(THEME_KEY, theme);
      localStorage.removeItem(CSS_KEY);
    } catch (e) {
      console.warn('localStorage nicht verfügbar', e);
    }
    
    // UI aktualisieren
    markActiveButton(theme, null);
    updateNavbarForInternalTheme(theme);
  }
  
  // ===== EXTERNE THEMES =====
  function loadExternalTheme(cssPath) {
    // Bootstrap CSS durch externes Theme ersetzen
    bootstrapCssLink.href = cssPath;
    
    // Markieren als externes Theme
    body.setAttribute('data-external-theme', 'true');
    body.removeAttribute('data-theme');
    
    // Custom Styles deaktivieren
    customStyles.disabled = true;
    
    // Persistieren
    try {
      localStorage.setItem(CSS_KEY, cssPath);
      localStorage.removeItem(THEME_KEY);
    } catch (e) {
      console.warn('localStorage nicht verfügbar', e);
    }
    
    // UI aktualisieren
    markActiveButton(null, cssPath);
    updateNavbarForExternalTheme(cssPath);
  }
  
  // ===== NAVBAR ANPASSUNGEN =====
  function updateNavbarForInternalTheme(theme) {
    const navbar = document.querySelector('.navbar');
    if (!navbar) return;
    
    // Dark Themes
    if (['dark', 'ki-default'].includes(theme)) {
      navbar.classList.remove('navbar-light');
      navbar.classList.add('navbar-dark');
    } else {
      navbar.classList.remove('navbar-dark');
      navbar.classList.add('navbar-light');
    }
  }
  
  function updateNavbarForExternalTheme(cssPath) {
    const navbar = document.querySelector('.navbar');
    if (!navbar) return;
    
    // Heuristik basierend auf Theme-Namen
    const darkThemes = ['cyborg', 'darkly', 'ki-club', 'slate', 'superhero'];
    const isDark = darkThemes.some(name => cssPath.includes(name));
    
    if (isDark) {
      navbar.classList.remove('navbar-light');
      navbar.classList.add('navbar-dark');
    } else {
      navbar.classList.remove('navbar-dark');
      navbar.classList.add('navbar-light');
    }
  }
  
  // ===== UI FEEDBACK =====
  function markActiveButton(theme, cssPath) {
    // Alle Theme-Buttons deaktivieren
    document.querySelectorAll('.theme-btn').forEach(btn => {
      btn.classList.remove('active');
    });
    
    // Aktiven Button markieren
    if (theme) {
      const activeBtn = document.querySelector(`.theme-btn[data-theme="${theme}"]`);
      if (activeBtn) activeBtn.classList.add('active');
    } else if (cssPath) {
      const activeBtn = document.querySelector(`.theme-btn[data-css="${cssPath}"]`);
      if (activeBtn) activeBtn.classList.add('active');
    }
  }
  
  // ===== EVENT LISTENERS =====
  document.querySelectorAll('.theme-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const themeAttr = btn.getAttribute('data-theme');
      const cssAttr = btn.getAttribute('data-css');
      
      if (themeAttr) {
        setInternalTheme(themeAttr);
      } else if (cssAttr) {
        loadExternalTheme(cssAttr);
      }
    });
  });
  
  // ===== THEME BEI SEITENAUFRUF LADEN =====
  function initTheme() {
    try {
      const savedCss = localStorage.getItem(CSS_KEY);
      const savedTheme = localStorage.getItem(THEME_KEY);
      
      if (savedCss) {
        loadExternalTheme(savedCss);
      } else {
        setInternalTheme(savedTheme || 'ki-default');
      }
    } catch (e) {
      console.warn('localStorage nicht verfügbar, verwende Default-Theme', e);
      setInternalTheme('ki-default');
    }
  }
  
  // Theme beim Laden initialisieren
  initTheme();
  
  // Globale Funktionen für Reset/Debug
  window.resetTheme = function() {
    try {
      localStorage.removeItem(THEME_KEY);
      localStorage.removeItem(CSS_KEY);
    } catch (e) {
      console.warn('localStorage nicht verfügbar', e);
    }
    setInternalTheme('ki-default');
  };
})();
</script>
```

### Schritt 4: Theme-Switcher UI

Füge einen Theme-Switcher in die Navigation ein (Bootstrap Dropdown):

```html
<nav class="navbar navbar-expand-lg navbar-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">Meine Website</a>
    
    <button class="navbar-toggler" type="button" 
            data-bs-toggle="collapse" 
            data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <!-- Theme Dropdown -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" 
             id="themeDropdown" role="button" 
             data-bs-toggle="dropdown">
            🎨 Themes
          </a>
          <ul class="dropdown-menu dropdown-menu-end">
            <!-- Interne Themes -->
            <li><h6 class="dropdown-header">Interne Themes</h6></li>
            <li><button class="dropdown-item theme-btn" 
                        data-theme="light">Light</button></li>
            <li><button class="dropdown-item theme-btn" 
                        data-theme="dark">Dark</button></li>
            <li><button class="dropdown-item theme-btn" 
                        data-theme="red">Red</button></li>
            <li><button class="dropdown-item theme-btn" 
                        data-theme="ki-default">KI-Club</button></li>
            
            <li><hr class="dropdown-divider"></li>
            
            <!-- Externe Themes -->
            <li><h6 class="dropdown-header">Externe Themes (Bootswatch)</h6></li>
            <li><button class="dropdown-item theme-btn" 
                        data-css="css/cerulean.bootstrap.min.css">Cerulean</button></li>
            <li><button class="dropdown-item theme-btn" 
                        data-css="css/cyborg.bootstrap.min.css">Cyborg</button></li>
            <li><button class="dropdown-item theme-btn" 
                        data-css="css/darkly.bootstrap.min.css">Darkly</button></li>
            
            <li><hr class="dropdown-divider"></li>
            
            <!-- Reset -->
            <li><button class="dropdown-item" 
                        onclick="window.resetTheme()">↻ Auf Standard zurücksetzen</button></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>
```

## Farbpaletten-Beispiele

### KI-Club Signature Style

```css
[data-theme="ki-default"] {
  --bg-primary: #000000;           /* Tiefstes Schwarz */
  --bg-secondary: #070708;         /* Leicht aufgehellt */
  --bg-accent: #0f0f12;           /* Akzent-Dunkel */
  --text-primary: #ffffff;         /* Weißer Text */
  --text-secondary: #cfd4d9;      /* Helles Grau */
  --accent-color: #dc3545;        /* KI-Club Rot */
  --navbar-bg: #dc3545;           /* Rote Navigation */
  --navbar-text: #ffffff;
  --border-color: rgba(255,255,255,0.06);
  --list-item-bg: #1f2937;        /* Dunkles Grau für Listen */
}
```

### Professional Blue

```css
[data-theme="professional-blue"] {
  --bg-primary: #ffffff;
  --bg-secondary: #f0f4f8;
  --bg-accent: #dbeafe;
  --text-primary: #1e293b;
  --text-secondary: #64748b;
  --accent-color: #3b82f6;
  --navbar-bg: #1e40af;
  --navbar-text: #ffffff;
  --border-color: #cbd5e1;
}
```

### Forest Green

```css
[data-theme="forest"] {
  --bg-primary: #ffffff;
  --bg-secondary: #f0fdf4;
  --bg-accent: #dcfce7;
  --text-primary: #14532d;
  --text-secondary: #16a34a;
  --accent-color: #22c55e;
  --navbar-bg: #166534;
  --navbar-text: #ffffff;
  --border-color: #bbf7d0;
}
```

### Warm Sunset

```css
[data-theme="sunset"] {
  --bg-primary: #fffbeb;
  --bg-secondary: #fef3c7;
  --bg-accent: #fde68a;
  --text-primary: #78350f;
  --text-secondary: #92400e;
  --accent-color: #f59e0b;
  --navbar-bg: #ea580c;
  --navbar-text: #ffffff;
  --border-color: #fcd34d;
}
```

## Erweiterte Anwendungsfälle

### Komponenten-spezifisches Styling

Für detaillierte Kontrolle über einzelne Komponenten:

```css
/* Akkordeon mit Theme-Variablen */
body:not([data-external-theme]) .accordion-item {
  background-color: var(--bg-primary);
  border-color: var(--accordion-border, var(--border-color));
}

body:not([data-external-theme]) .accordion-button {
  background-color: var(--accordion-collapsed-bg, var(--bg-secondary));
  color: var(--text-primary);
}

body:not([data-external-theme]) .accordion-button:not(.collapsed) {
  background-color: var(--accordion-expanded-bg, var(--bg-accent));
  color: var(--text-primary);
}

/* Listen mit Theme-Anpassungen */
body:not([data-external-theme]) .list-group-item {
  background-color: var(--list-item-bg, var(--bg-primary));
  color: var(--text-primary);
  border-color: var(--list-border, var(--border-color));
}

/* Cards */
body:not([data-external-theme]) .card {
  background-color: var(--bg-primary);
  border-color: var(--border-color);
}

/* Alerts */
body:not([data-external-theme]) .alert-info {
  background-color: var(--bg-accent);
  border-color: var(--accent-color);
  color: var(--text-primary);
}
```

### Gradients und fortgeschrittene Effekte

```css
/* Header mit Gradient */
body:not([data-external-theme]) header {
  background: linear-gradient(90deg, var(--accent-color), #1e293b);
  color: var(--header-text);
}

/* Button mit Hover-Effekt */
body:not([data-external-theme]) .btn-primary {
  background-color: var(--accent-color);
  border-color: var(--accent-color);
  color: white;
  transition: all 0.3s ease;
}

body:not([data-external-theme]) .btn-primary:hover {
  background-color: color-mix(in srgb, var(--accent-color) 80%, black);
  border-color: color-mix(in srgb, var(--accent-color) 80%, black);
}
```

### Prefers-Color-Scheme Integration

Automatische Theme-Anpassung basierend auf System-Präferenzen:

```javascript
// In der initTheme() Funktion:
function initTheme() {
  try {
    const savedCss = localStorage.getItem(CSS_KEY);
    const savedTheme = localStorage.getItem(THEME_KEY);
    
    if (savedCss) {
      loadExternalTheme(savedCss);
    } else if (savedTheme) {
      setInternalTheme(savedTheme);
    } else {
      // Kein gespeichertes Theme - System-Präferenz prüfen
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      setInternalTheme(prefersDark ? 'dark' : 'light');
    }
  } catch (e) {
    console.warn('localStorage nicht verfügbar', e);
    setInternalTheme('light');
  }
}

// Optional: Auf System-Theme-Änderungen reagieren
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
  // Nur reagieren, wenn kein manuell gewähltes Theme gespeichert ist
  if (!localStorage.getItem(THEME_KEY) && !localStorage.getItem(CSS_KEY)) {
    setInternalTheme(e.matches ? 'dark' : 'light');
  }
});
```

## Externe Themes hinzufügen (Bootswatch)

### Themes lokal einbinden

1. Lade Bootswatch-Themes von https://bootswatch.com/
2. Speichere CSS-Dateien im `css/` Verzeichnis
3. Füge Buttons im Theme-Dropdown hinzu:

```html
<li><button class="dropdown-item theme-btn" 
            data-css="css/flatly.bootstrap.min.css">Flatly</button></li>
<li><button class="dropdown-item theme-btn" 
            data-css="css/lux.bootstrap.min.css">Lux</button></li>
<li><button class="dropdown-item theme-btn" 
            data-css="css/minty.bootstrap.min.css">Minty</button></li>
```

### Themes von CDN

Alternativ direkt von CDN laden:

```html
<li><button class="dropdown-item theme-btn" 
            data-css="https://cdn.jsdelivr.net/npm/bootswatch@5.3.3/dist/flatly/bootstrap.min.css">
    Flatly (CDN)
</button></li>
```

## Best Practices

### 1. Performance

- Verwende `transition` für sanfte Theme-Wechsel:
  ```css
  body:not([data-external-theme]) {
    transition: background-color 0.3s ease, color 0.3s ease;
  }
  ```

- Minimiere Layout-Shifts während Theme-Wechseln

### 2. Accessibility

- Stelle ausreichenden Kontrast sicher (WCAG AA: mindestens 4.5:1 für normalen Text)
- Verwende semantische Farbnamen für Variablen
- Teste mit Screen-Readern

### 3. Wartbarkeit

- Dokumentiere alle Custom Properties im `:root` Block
- Verwende konsistente Namenskonventionen
- Gruppiere zusammengehörige Variablen

### 4. Browser-Kompatibilität

- CSS Custom Properties werden von allen modernen Browsern unterstützt
- Für ältere Browser (IE11): Verwende Fallback-Werte oder Polyfills
- `color-mix()` erfordert moderne Browser (2023+)

## Debugging und Fehlerbehebung

### Theme wird nicht angewendet

1. **Prüfe LocalStorage:**
   ```javascript
   console.log('Theme:', localStorage.getItem('website-theme'));
   console.log('CSS:', localStorage.getItem('website-css'));
   ```

2. **Prüfe Body-Attribute:**
   ```javascript
   console.log('data-theme:', document.body.getAttribute('data-theme'));
   console.log('data-external-theme:', document.body.getAttribute('data-external-theme'));
   ```

3. **Prüfe Bootstrap CSS Link:**
   ```javascript
   console.log('Bootstrap href:', document.getElementById('bootstrap-css').href);
   ```

4. **Prüfe Custom Styles Status:**
   ```javascript
   console.log('Custom styles disabled:', document.getElementById('custom-theme-styles').disabled);
   ```

### Externe Themes überschreiben lokale Anpassungen

- Erhöhe Spezifität mit zusätzlichen Selektoren
- Verwende `!important` sparsam und nur wenn nötig
- Oder: Lade eine zusätzliche Override-CSS nach dem externen Theme

### LocalStorage nicht verfügbar

```javascript
// Fallback auf Session Storage
function getStorage() {
  try {
    localStorage.setItem('test', 'test');
    localStorage.removeItem('test');
    return localStorage;
  } catch (e) {
    console.warn('localStorage nicht verfügbar, verwende sessionStorage');
    return sessionStorage;
  }
}

const storage = getStorage();
```

## Integration in bestehende Projekte

### Schritt-für-Schritt Anleitung

1. **Vorbereitung:**
   - Identifiziere das Bootstrap CSS `<link>` Element
   - Füge `id="bootstrap-css"` hinzu wenn nicht vorhanden

2. **Theme-System einfügen:**
   - Kopiere den `<style id="custom-theme-styles">` Block
   - Passe Farbpaletten an Projekt-Branding an
   - Kopiere das Theme-Engine JavaScript

3. **UI anpassen:**
   - Füge Theme-Dropdown zur Navigation hinzu
   - Style die Theme-Buttons passend zum Design

4. **Testen:**
   - Teste alle Theme-Varianten
   - Prüfe auf Layout-Brüche
   - Teste auf verschiedenen Geräten
   - Validiere Kontraste mit Tools wie WebAIM

5. **Dokumentieren:**
   - Erstelle eine Theme-Übersicht für das Team
   - Dokumentiere verfügbare Variablen
   - Notiere Browser-Anforderungen

## Anpassung für andere Frameworks

### Tailwind CSS Integration

```html
<style>
  :root {
    /* Tailwind-kompatible Variablen */
    --color-primary: #dc3545;
    --color-secondary: #6c757d;
    --color-background: #ffffff;
    --color-text: #212529;
  }
  
  [data-theme="dark"] {
    --color-background: #0f172a;
    --color-text: #f1f5f9;
  }
</style>

<!-- In Tailwind Config -->
<script>
  module.exports = {
    theme: {
      extend: {
        colors: {
          primary: 'var(--color-primary)',
          secondary: 'var(--color-secondary)',
        },
        backgroundColor: {
          'body': 'var(--color-background)',
        },
        textColor: {
          'body': 'var(--color-text)',
        },
      },
    },
  }
</script>
```

### Vanilla CSS (ohne Framework)

```css
/* Ohne Bootstrap - direktes Styling */
body {
  background-color: var(--bg-primary);
  color: var(--text-primary);
  font-family: system-ui, -apple-system, sans-serif;
}

header {
  background-color: var(--navbar-bg);
  color: var(--navbar-text);
  padding: 1rem 2rem;
}

button.primary {
  background-color: var(--accent-color);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.25rem;
}
```

## Zusammenfassung

Dieses Theme-System bietet:

✅ **Flexibilität**: Interne und externe Themes  
✅ **Persistenz**: LocalStorage für User-Präferenzen  
✅ **Wartbarkeit**: CSS-Variablen für konsistentes Design  
✅ **Performance**: Sanfte Transitions ohne Layout-Shifts  
✅ **Accessibility**: Kontrastprüfung und semantische Farben  
✅ **Erweiterbarkeit**: Einfaches Hinzufügen neuer Themes

### Nächste Schritte

- Passe die Farbpaletten an dein Branding an
- Erstelle projekt-spezifische Theme-Varianten
- Füge weitere Bootswatch-Themes hinzu
- Integriere mit System-Theme-Präferenzen
- Dokumentiere für dein Team

Bei Fragen oder Problemen: Prüfe die Debugging-Sektion oder öffne die Browser DevTools Console für detaillierte Logs.
