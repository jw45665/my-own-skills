### Frontend / UI — Kurze, exakte Vorgaben für Agenten (jw-react-ui-instructions.md)

**Ziel:** Erzeuge modulare, wiederverwendbare, barrierefreie UI‑Komponenten für React + TypeScript (Vite/aktuelle Templates). Nutze Tailwind CSS + shadcn/ui; Syncfusion nur für komplexe Enterprise‑Controls. Komponenten müssen i18n‑fähig, testbar und PWA‑/mobile‑freundlich sein.

- **Projektbasis**
  - **Framework:** React + TypeScript (Vite oder aktuelles VS/ASP.NET‑Template).
  - **Monorepo:** Frontend, Mobile, Shared‑UI in getrennten Paketen; gemeinsame Komponenten im `packages/ui`‑Ordner.
  - **Build:** ESM, tree‑shaking, minimaler Bundle‑Footprint.

- **Styling**
  - **Utility‑First:** Tailwind CSS als einzige Basis‑Utility‑Bibliothek.
  - **Design Tokens:** Farben, Abstände, Typografie als Tailwind‑Theme‑Tokens definieren.
  - **Keine globalen CSS‑Overrides**; Styles nur über Tailwind‑Klassen oder komponierte Utility‑Klassen.

- **Komponenten**
  - **Primär:** shadcn/ui‑kompatible, Headless‑first Komponenten (kopierbar in Repo).
  - **Syncfusion:** Nur für komplexe Controls (Grid, Scheduler, Chart); Wrapper‑Komponenten mit einheitlicher Props‑Schnittstelle erstellen.
  - **API:** Jede Komponente exportiert Props‑Interface, Storybook‑Story, Unit‑Test (Jest/Testing Library) und ein kurzes README (1–2 Sätze).
  - **Wiederverwendbarkeit:** Kleine, atomare Komponenten; zusammengesetzte Komponenten im `composites`‑Ordner.

- **Zustand & Daten**
  - **Local UI State:** React state / hooks; keine globale State‑Abhängigkeit für einfache Komponenten.
  - **Shared State:** Zustand nur in expliziten Stores (Zustand/Redux Toolkit) mit klaren Schnittstellen.
  - **Data Fetching:** SWR oder React Query; API‑Layer strikt trennen (services/api).

- **Internationalisierung**
  - **Lib:** react-i18next (oder vergleichbar).  
  - **Vorgabe:** Alle Texte über i18n‑Keys; Komponenten dürfen keine hardcodierten Strings enthalten.

- **Accessibility**
  - **A11y:** ARIA‑Attribute, keyboard‑navigation, focus‑management; automatisierte Tests (axe).
  - **Kontrast & Skalierbarkeit:** Design Tokens prüfen; responsive Breakpoints definieren.

- **PWA & Offline**
  - **Service Worker:** PWA‑Manifest + Service Worker für Web Push und Offline‑Caching.
  - **Push:** Subscription‑Flow UI (Web Push) und Hooks für Token‑Registrierung (FCM/APNs) bereitstellen.

- **Interoperabilität**
  - **Blazor/MAUI‑Interop:** Wenn nötig, Komponenten als Web Components exportierbar halten (Stencil/Custom Elements).
  - **Syncfusion‑MCP:** Konfigurationsdateien und Lizenzhinweise im Repo; Wrapper‑API konsistent halten.

- **Code‑Qualität**
  - **Linting/Formatting:** ESLint + Prettier; strikte TS‑Konfiguration (`noImplicitAny`, `strict`).
  - **Tests:** Unit + Integration; Storybook für visuelle Tests.
  - **Dokumentation:** Kurzbeschreibung, Props‑Tabelle, Beispiel‑Usage in jeder Komponente.

- **Agenten‑Spezifika**
  - **Deterministische Patterns:** Verwende klare Namenskonventionen (`<ComponentName>`, `useXxx`, `hooks/`, `services/`).
  - **Scaffold‑Templates:** Vorlagen für neue Komponenten (TSX, Tailwind, Story, Test, README).
  - **Commit‑Messages:** Standardisierte Commit‑Konvention (Conventional Commits).
  - **LLM‑Hints:** Füge in Komponenten‑Templates kurze Kommentare mit Intent, Props‑Semantik und i18n‑Key‑Beispielen ein, damit Agenten konsistent erweitern.

- **Deployment‑Hinweis**
  - **PWA‑Build:** Manifest, Service Worker, und VAPID‑Key‑Platzhalter in Konfigurationsdatei.
  - **CI:** Build‑Checks für Lint, Tests, Storybook‑Snapshot; Artefakte für Store‑Builds (Expo / MAUI) vorbereiten.
