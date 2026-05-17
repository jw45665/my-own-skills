---
post_title: "VS-F5 für React/Vite: Skill-Dokumentation"
author1: ""
post_slug: "vs-f5-react-vite-enable-readme"
categories: ["Skills", "Visual Studio"]
tags: ["React", "Vite", "F5", "Visual Studio", "Debugging"]
ai_note: true
summary: "Diese READ.MD beschreibt den Skill zur F5-Aktivierung in React/Vite-Projekten mit Visual Studio und den Merge der VS-Code-Launchprofile."
post_date: 2026-05-04
---

# VS-F5 für React/Vite: Skill-Dokumentation

Dieser Skill stellt sicher, dass ein React/Vite-Projekt in Visual Studio direkt mit **F5** gestartet werden kann. Der Ablauf ist deterministisch gehalten, damit wiederholte Ausführungen keine doppelten Konfigurationen erzeugen und bestehende Einstellungen respektiert werden.

## Ziel und Nutzen

Im Zentrum steht ein stabiler Entwicklungsstart: Visual Studio soll den Dev-Server über `npm run dev` starten, während VS Code passende Browserprofile für dieselbe URL bereitstellt. So entsteht ein einheitlicher Debug-Flow über beide Umgebungen hinweg.

## Funktionsweise des Skills

Der Skill arbeitet in vier Schritten. Zuerst wird der Vite-Port aus der `vite.config.ts` gelesen; falls dort kein Port gesetzt ist, gilt `5173` als Fallback. Anschließend wird die `*.esproj` geprüft oder erstellt und auf den definierten Sollzustand gebracht.

Danach wird die Datei `.vscode/launch.json` nicht blind überschrieben, sondern gemerged. Bestehende Konfigurationen bleiben erhalten, während die beiden Profile `localhost (Edge)` und `localhost (Chrome)` ergänzt oder aktualisiert werden. Zum Abschluss validiert der Skill, dass die F5-Startkette korrekt ist und ein zweiter Lauf idempotent bleibt.

## Sollzustand der Projektdatei

Der Skill erwartet in der `*.esproj` folgende Werte im `PropertyGroup`-Block:

```xml
<StartupCommand>npm run dev</StartupCommand>
<JavaScriptTestRoot>src\</JavaScriptTestRoot>
<JavaScriptTestFramework>Vitest</JavaScriptTestFramework>
<ShouldRunBuildScript>false</ShouldRunBuildScript>
<BuildOutputFolder>$(MSBuildProjectDirectory)\dist</BuildOutputFolder>
```

Diese Werte sind die Grundlage dafür, dass Visual Studio beim Debug-Start den richtigen Entwicklungsprozess startet.

## Sollzustand der VS-Code-Profile

Für beide Profile wird dieselbe URL mit dem ermittelten Port verwendet:

```json
{
  "type": "edge",
  "request": "launch",
  "name": "localhost (Edge)",
  "url": "http://localhost:<PORT>",
  "webRoot": "${workspaceFolder}"
}
```

```json
{
  "type": "chrome",
  "request": "launch",
  "name": "localhost (Chrome)",
  "url": "http://localhost:<PORT>",
  "webRoot": "${workspaceFolder}"
}
```

Damit bleibt das Verhalten in VS Code konsistent mit dem Startverhalten in Visual Studio.

## Fehlerverhalten und Grenzen

Fehlt eine `package.json`, bricht der Skill mit einer klaren Meldung ab. Ist eine vorhandene `launch.json` ungültig, wird sie gesichert und in einen validen Zustand mit den Zielprofilen überführt. Bei mehreren `*.esproj`-Dateien wird die Datei mit dem passendsten Projektnamen bevorzugt, um Seiteneffekte zu minimieren.

## Ergebnisbericht

Nach jeder Ausführung meldet der Skill kompakt die geänderten Dateien, den verwendeten Port, ob Dateien erstellt oder gemerged wurden und ob manuelle Restschritte offen sind. Dadurch bleibt der Ablauf für Teams transparent und reproduzierbar.

---

© 2026 Jörg Walkowiak ([joerg-walkowiak.de](https://joerg-walkowiak.de))  
**Manuskript-Vorabdruck** • Vertraulich • Nur zum persönlichen Gebrauch • Nicht zur Veröffentlichung
