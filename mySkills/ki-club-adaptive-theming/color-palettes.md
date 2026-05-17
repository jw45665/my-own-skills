# Farbpaletten-Sammlung für Adaptive Theming

Diese Datei enthält vordefinierte Farbpaletten, die direkt in das Theme-System übernommen werden können.

## 🎨 Original KI-Club Themes

### KI-Club Signature Style

Das charakteristische Design von KI-Club.online mit tiefem Schwarz und kraftvollem Rot.

```css
[data-theme="ki-default"] {
  --bg-primary: #000000;           /* Tiefstes Schwarz */
  --bg-secondary: #070708;         /* Minimal aufgehellt */
  --bg-accent: #0f0f12;           /* Subtiler Akzent */
  --text-primary: #ffffff;         /* Reines Weiß */
  --text-secondary: #cfd4d9;      /* Helles Grau */
  --accent-color: #dc3545;        /* KI-Club Rot */
  --navbar-bg: #dc3545;           /* Rote Navigation */
  --navbar-text: #ffffff;         /* Weißer Text */
  --header-text: #ffffff;         /* Weißer Header-Text */
  --border-color: rgba(255,255,255,0.06);
  --list-item-bg: #1f2937;        /* Slate-800 */
  --list-border: rgba(255,255,255,0.06);
}
```

**Kontrast-Ratio:**
- Text auf Hintergrund: 21:1 (WCAG AAA ✓)
- Rot auf Schwarz: 5.4:1 (WCAG AA ✓)

**Stimmung:** Modern, technologisch, kraftvoll, premium

---

### Light (Standard)

Klassisches helles Theme mit neutralen Farben.

```css
[data-theme="light"] {
  --bg-primary: #ffffff;
  --bg-secondary: #f8f9fa;
  --bg-accent: #e9ecef;
  --text-primary: #212529;
  --text-secondary: #6c757d;
  --accent-color: #dc3545;
  --navbar-bg: #ffffff;
  --navbar-text: #212529;
  --header-text: #ffffff;
  --border-color: #dee2e6;
}
```

**Kontrast-Ratio:**
- Text auf Weiß: 16:1 (WCAG AAA ✓)

**Stimmung:** Sauber, professionell, neutral, zugänglich

---

### Dark

Dunkles Theme mit mittlerem Kontrast für angenehmes Lesen.

```css
[data-theme="dark"] {
  --bg-primary: #212529;
  --bg-secondary: #343a40;
  --bg-accent: #495057;
  --text-primary: #ffffff;
  --text-secondary: #adb5bd;
  --accent-color: #dc3545;
  --navbar-bg: #343a40;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #495057;
}
```

**Kontrast-Ratio:**
- Weiß auf Dunkelgrau: 15.8:1 (WCAG AAA ✓)

**Stimmung:** Modern, augenschonend, elegant, Tech

---

### Red

Warmes rotes Theme mit hellem Hintergrund.

```css
[data-theme="red"] {
  --bg-primary: #ffffff;
  --bg-secondary: #fff5f5;
  --bg-accent: #fee2e2;
  --text-primary: #0f1724;
  --text-secondary: #374151;
  --accent-color: #dc2626;
  --navbar-bg: #dc2626;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #fca5a5;
}
```

**Kontrast-Ratio:**
- Dunkelblau auf Weiß: 17:1 (WCAG AAA ✓)
- Rot auf Rosa: 7.2:1 (WCAG AA ✓)

**Stimmung:** Energisch, leidenschaftlich, warm, aufmerksamkeitsstark

---

## 💼 Business & Professional Themes

### Professional Blue

Vertrauenswürdiges, geschäftliches Blau.

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
  --header-text: #ffffff;
  --border-color: #cbd5e1;
}
```

**Use Cases:** Corporate Websites, Fintech, B2B SaaS, Consulting

**Stimmung:** Vertrauenswürdig, professionell, stabil, kompetent

---

### Corporate Gray

Minimalistisches Grau-Schema für Business-Anwendungen.

```css
[data-theme="corporate-gray"] {
  --bg-primary: #ffffff;
  --bg-secondary: #f9fafb;
  --bg-accent: #f3f4f6;
  --text-primary: #111827;
  --text-secondary: #6b7280;
  --accent-color: #4b5563;
  --navbar-bg: #1f2937;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #e5e7eb;
}
```

**Use Cases:** Admin Dashboards, Enterprise Software, Analytics Tools

**Stimmung:** Neutral, fokussiert, professionell, minimalistisch

---

### Executive Purple

Luxuriöses Lila für Premium-Brands.

```css
[data-theme="executive-purple"] {
  --bg-primary: #ffffff;
  --bg-secondary: #faf5ff;
  --bg-accent: #f3e8ff;
  --text-primary: #3b0764;
  --text-secondary: #6b21a8;
  --accent-color: #9333ea;
  --navbar-bg: #7e22ce;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #e9d5ff;
}
```

**Use Cases:** Luxury Brands, Premium Services, Creative Agencies

**Stimmung:** Luxuriös, kreativ, sophisticated, premium

---

## 🌿 Nature-Inspired Themes

### Forest Green

Beruhigendes Grün inspiriert von Wäldern.

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
  --header-text: #ffffff;
  --border-color: #bbf7d0;
}
```

**Use Cases:** Umwelt, Wellness, Bio-Produkte, Nachhaltigkeit

**Stimmung:** Natürlich, beruhigend, wachstumsorientiert, frisch

---

### Ocean Blue

Erfrischendes Theme inspiriert vom Ozean.

```css
[data-theme="ocean"] {
  --bg-primary: #ffffff;
  --bg-secondary: #ecfeff;
  --bg-accent: #cffafe;
  --text-primary: #083344;
  --text-secondary: #155e75;
  --accent-color: #06b6d4;
  --navbar-bg: #0e7490;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #a5f3fc;
}
```

**Use Cases:** Reise, Wassersport, Maritime, Wellness

**Stimmung:** Erfrischend, ruhig, weitläufig, klar

---

### Earth Brown

Warmes, erdiges Braun.

```css
[data-theme="earth"] {
  --bg-primary: #fefce8;
  --bg-secondary: #fef9c3;
  --bg-accent: #fef08a;
  --text-primary: #422006;
  --text-secondary: #78350f;
  --accent-color: #a16207;
  --navbar-bg: #92400e;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #fde047;
}
```

**Use Cases:** Handwerk, Bio, Vintage, Naturprodukte

**Stimmung:** Geerdet, warm, authentisch, organisch

---

## 🌅 Warm & Energetic Themes

### Warm Sunset

Inspiriert von Sonnenuntergängen.

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
  --header-text: #ffffff;
  --border-color: #fcd34d;
}
```

**Use Cases:** Food & Beverage, Lifestyle, Kreativ-Agenturen

**Stimmung:** Warm, einladend, energetisch, optimistisch

---

### Fiery Orange

Kraftvolles Orange mit hoher Energie.

```css
[data-theme="fiery-orange"] {
  --bg-primary: #fff7ed;
  --bg-secondary: #ffedd5;
  --bg-accent: #fed7aa;
  --text-primary: #7c2d12;
  --text-secondary: #9a3412;
  --accent-color: #f97316;
  --navbar-bg: #ea580c;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #fdba74;
}
```

**Use Cases:** Sport, Fitness, Events, Start-ups

**Stimmung:** Energetisch, dynamisch, motivierend, auffällig

---

## ❄️ Cool & Calm Themes

### Arctic Frost

Kühles, eisiges Blau-Weiß.

```css
[data-theme="arctic"] {
  --bg-primary: #f0f9ff;
  --bg-secondary: #e0f2fe;
  --bg-accent: #bae6fd;
  --text-primary: #0c4a6e;
  --text-secondary: #075985;
  --accent-color: #0284c7;
  --navbar-bg: #0369a1;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #7dd3fc;
}
```

**Use Cases:** Medizin, Tech, Clean Design

**Stimmung:** Klar, präzise, sauber, kühl

---

### Mint Fresh

Erfrischendes Mintgrün.

```css
[data-theme="mint"] {
  --bg-primary: #f0fdfa;
  --bg-secondary: #ccfbf1;
  --bg-accent: #99f6e4;
  --text-primary: #134e4a;
  --text-secondary: #115e59;
  --accent-color: #14b8a6;
  --navbar-bg: #0f766e;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #5eead4;
}
```

**Use Cases:** Gesundheit, Wellness, Beauty, Fresh Brands

**Stimmung:** Frisch, sauber, belebend, modern

---

## 🌸 Soft & Friendly Themes

### Rose Pink

Sanftes, freundliches Pink.

```css
[data-theme="rose"] {
  --bg-primary: #fff1f2;
  --bg-secondary: #ffe4e6;
  --bg-accent: #fecdd3;
  --text-primary: #881337;
  --text-secondary: #9f1239;
  --accent-color: #f43f5e;
  --navbar-bg: #e11d48;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #fda4af;
}
```

**Use Cases:** Beauty, Fashion, Lifestyle, Social

**Stimmung:** Freundlich, weiblich, warm, einladend

---

### Lavender Dream

Beruhigendes Lavendel.

```css
[data-theme="lavender"] {
  --bg-primary: #faf5ff;
  --bg-secondary: #f3e8ff;
  --bg-accent: #e9d5ff;
  --text-primary: #581c87;
  --text-secondary: #6b21a8;
  --accent-color: #a855f7;
  --navbar-bg: #9333ea;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #d8b4fe;
}
```

**Use Cases:** Wellness, Spiritualität, Kreativ, Art

**Stimmung:** Beruhigend, kreativ, spirituell, träumerisch

---

## 🌙 Dark Mode Variations

### Deep Space

Ultra-dunkles Theme für OLED-Displays.

```css
[data-theme="deep-space"] {
  --bg-primary: #000000;
  --bg-secondary: #0a0a0a;
  --bg-accent: #1a1a1a;
  --text-primary: #ffffff;
  --text-secondary: #a3a3a3;
  --accent-color: #8b5cf6;
  --navbar-bg: #7c3aed;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: rgba(255,255,255,0.08);
}
```

**Use Cases:** Gaming, Entertainment, Premium Apps

**Stimmung:** Immersiv, premium, modern, fokussiert

---

### Midnight Blue

Tiefblaues Dark Theme.

```css
[data-theme="midnight"] {
  --bg-primary: #0f172a;
  --bg-secondary: #1e293b;
  --bg-accent: #334155;
  --text-primary: #f1f5f9;
  --text-secondary: #cbd5e1;
  --accent-color: #3b82f6;
  --navbar-bg: #1e40af;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #475569;
}
```

**Use Cases:** Developer Tools, Analytics, Professional Apps

**Stimmung:** Professionell, fokussiert, tech-orientiert

---

### Charcoal

Warmes, dunkles Grau.

```css
[data-theme="charcoal"] {
  --bg-primary: #18181b;
  --bg-secondary: #27272a;
  --bg-accent: #3f3f46;
  --text-primary: #fafafa;
  --text-secondary: #d4d4d8;
  --accent-color: #f59e0b;
  --navbar-bg: #3f3f46;
  --navbar-text: #fafafa;
  --header-text: #ffffff;
  --border-color: #52525b;
}
```

**Use Cases:** Portfolio, Photography, Creative

**Stimmung:** Elegant, kreativ, modern, warm

---

## 🎯 Specialized Themes

### High Contrast

Maximaler Kontrast für Accessibility.

```css
[data-theme="high-contrast"] {
  --bg-primary: #ffffff;
  --bg-secondary: #f3f4f6;
  --bg-accent: #e5e7eb;
  --text-primary: #000000;
  --text-secondary: #1f2937;
  --accent-color: #0000ff;
  --navbar-bg: #000000;
  --navbar-text: #ffffff;
  --header-text: #ffffff;
  --border-color: #000000;
}
```

**Use Cases:** Accessibility, Government, Education

**Kontrast:** WCAG AAA für alle Texte

---

### Sepia Reader

Warmes Sepia für langes Lesen.

```css
[data-theme="sepia"] {
  --bg-primary: #f4f1ea;
  --bg-secondary: #ebe6dd;
  --bg-accent: #e0d9cc;
  --text-primary: #3e3328;
  --text-secondary: #5c4d3c;
  --accent-color: #8b5a3c;
  --navbar-bg: #6b4423;
  --navbar-text: #f4f1ea;
  --header-text: #f4f1ea;
  --border-color: #d4c9b8;
}
```

**Use Cases:** Blogs, Dokumentation, E-Reader

**Stimmung:** Warm, lesbar, nostalgisch, augenschonend

---

## 📊 Verwendungshinweise

### Kontrast-Prüfung

Teste alle Themes mit:
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Accessible Colors](https://accessible-colors.com/)

**Mindest-Anforderungen (WCAG AA):**
- Normaler Text: 4.5:1
- Großer Text (18pt+): 3:1
- UI-Komponenten: 3:1

### Theme-Auswahl Checkliste

- [ ] Passt zur Markenidentität
- [ ] Ausreichender Kontrast (WCAG AA minimum)
- [ ] Konsistente Farbtemperatur (warm/kalt)
- [ ] Funktioniert in Light und Dark Variants
- [ ] Alle Variablen definiert
- [ ] Auf verschiedenen Displays getestet

### Quick Copy Template

```css
[data-theme="YOUR-THEME-NAME"] {
  --bg-primary: #______;
  --bg-secondary: #______;
  --bg-accent: #______;
  --text-primary: #______;
  --text-secondary: #______;
  --accent-color: #______;
  --navbar-bg: #______;
  --navbar-text: #______;
  --header-text: #______;
  --border-color: #______;
}
```

---

**Tipp:** Verwende Tools wie [Coolors](https://coolors.co/) oder [Adobe Color](https://color.adobe.com/) zum Erstellen eigener Paletten!
