# Copilot Instructions – Blazor Components

## Ziel
Alle von Copilot erzeugten Blazor-Komponenten sollen **autark, wiederverwendbar und kapselbar** sein.  
Das bedeutet:

1. **Komponentenstruktur**
   - Jede Komponente wird in einer eigenen `.razor`-Datei erstellt.
   - Zu jeder Komponente gehört eine `.razor.css`-Datei für **CSS-Isolation**.
   - Falls JavaScript benötigt wird, wird eine separate `.razor.js`-Datei oder ein Modul im `wwwroot` erstellt und über **JS-Isolation** (`IJSRuntime` / `IJSObjectReference`) eingebunden.

2. **Namenskonventionen**
   - Dateien heißen konsistent: `MyComponent.razor`, `MyComponent.razor.css`, `MyComponent.razor.js`.
   - Klassen und Selektoren sind scoped, keine globalen IDs oder Styles.

3. **Wiederverwendbarkeit**
   - Keine direkten Abhängigkeiten zu globalem CSS oder JS.
   - Parameter (`[Parameter]`) für alle konfigurierbaren Eigenschaften.
   - Events werden über `EventCallback` exponiert.

4. **Packaging**
   - Komponenten sollen so entworfen sein, dass sie in einer **Razor Class Library (RCL)** oder als **NuGet-Paket** verteilt werden können.
   - Keine hartcodierten Pfade oder projektspezifischen Abhängigkeiten.

5. **Best Practices**
   - Saubere Trennung von UI (Razor), Styles (CSS), Verhalten (JS).
   - Dokumentation per XML‑Kommentare und kurze Usage‑Beispiele im Code.
   - Komponenten sollen ohne externe Anpassungen in beliebigen Blazor‑Projekten lauffähig sein.

## Beispiel
Wenn Copilot eine Button-Komponente generiert, soll er automatisch:
- `Button.razor` mit Markup und Parametern erstellen,
- `Button.razor.css` mit isolierten Styles anlegen,
- optional `Button.razor.js` für Interaktionen (z. B. Animationen) erzeugen,
- und die Komponente so strukturieren, dass sie direkt in einer RCL nutzbar ist.