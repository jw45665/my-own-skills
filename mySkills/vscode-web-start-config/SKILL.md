---
name: vscode-web-start-config
description: Configure and repair VS Code F5 startup workflows for website projects. Use whenever the user asks to start a local web project with F5, wire Run and Debug, launch browsers (Chrome Incognito, Edge InPrivate, default browser), or fix broken launch.json and tasks.json startup behavior.
---

# VS Code Web Start Config

Set up robust VS Code startup flows for website projects so users can press F5 and get a working local server plus browser launch.

## Scope

Use this skill for static websites, vanilla HTML/CSS/JS projects, and frontend projects without a stable F5 workflow.

## Inputs To Collect

1. Project root and actual web root folder.
2. Start command for local server and expected URL.
3. Browser launch preference:
- Chrome Incognito
- Edge InPrivate
- Default browser
4. Preferred window size for browser tasks.
5. Preferred runtime strategy:
- Node local server
- IIS Express
- Auto detect (recommended)

## Required Outcome

1. Pressing F5 must trigger Run and Debug startup.
2. Local server must start first.
3. Browser must open second.
4. User must be able to choose browser profiles from launch configurations.

## Implementation Workflow

1. Inspect existing configuration files:
- .vscode/tasks.json
- .vscode/launch.json
- .vscode/keybindings.json

2. Detect or confirm local start command:
- Reuse existing server entry points where possible.
- Do not invent ports without evidence from the project.

3. Resolve local server runtime (mandatory):
- First, detect available runtimes on Windows:
	- Node: `Get-Command node -ErrorAction SilentlyContinue`
	- IIS Express: `Get-Command iisexpress.exe -ErrorAction SilentlyContinue` and common paths:
		- `C:\Program Files\IIS Express\iisexpress.exe`
		- `C:\Program Files (x86)\IIS Express\iisexpress.exe`
- If Node is available and a Node entry point exists (for example `server.js`), prefer Node.
- If Node is not available but IIS Express is available, build an IIS Express launch task.
- If neither runtime is available, suggest installation options and proceed with user-approved path.

4. If Node is required but missing, provide install path and then configure tasks:
- Preferred install command on Windows:
	- `winget install OpenJS.NodeJS.LTS`
- Validate with:
	- `node -v`
- Then configure server task using Node startup command.

5. If IIS Express is chosen or required, configure server task accordingly:
- Use full iisexpress path when command resolution is unreliable.
- Example pattern:
	- `Start-Process 'C:\Program Files\\IIS Express\\iisexpress.exe' -ArgumentList '/path:${workspaceFolder}\\my-coming-soon-template','/port:5501'`
- If the web root differs from workspace root, point `/path:` to the actual website folder.

6. Build idempotent tasks in tasks.json:
- One task for local server start.
- One task per browser target.
- One compound task per startup profile using dependsOn and dependsOrder: sequence.

7. Build launch profiles in launch.json:
- Add one configuration per startup profile.
- Use preLaunchTask for the compound task.
- Keep profile names explicit and human-readable.

8. Wire F5 behavior:
- Prefer workbench.action.debug.start in keybindings.json when a custom F5 override exists and bypasses launch profiles.

9. Validate:
- Check JSON diagnostics for edited files.
- Run one or more startup tasks to confirm execution.

10. Document:
- Add or update README instructions for selecting startup profiles in Run and Debug.

## Editing Rules

1. Preserve unrelated existing tasks and launch configurations.
2. If labels are ambiguous, normalize names but keep behavior intact.
3. Avoid destructive git commands and avoid reverting unrelated local changes.
4. Keep changes minimal and easy to review.

## Runtime Decision Matrix

1. Existing project server task works:
- Keep it and only extend browser/profile wiring.

2. No working server task, Node available:
- Create Node start task.

3. Node missing, IIS Express available:
- Create IIS Express start task.

4. Node and IIS Express both missing:
- Propose Node installation first, then continue after confirmation.

## Server Bootstrap Policy

1. Never overwrite an existing server file automatically.
2. If a project already has a working `server.js` (or equivalent start command), reuse it.
3. Only create a new server file when all of the following are true:
- No working local server command exists.
- Node is available (or user approved Node installation).
- User agrees to create a new server entry point.
4. When creating a new Node static server, use the bundled template at:
- `.github/skills/vscode-web-start-config/templates/server.node-static.js`
5. After creation, wire tasks to the created file and report that a new server entry point was added.

## Example Prompt Collection

Use prompts like these to trigger this skill reliably:

1. "Fix F5 in this static website project: start local server then open browser."
2. "Create VS Code launch and task setup with Chrome Incognito and Edge InPrivate options."
3. "Make F5 run Run and Debug profiles instead of a direct task call."
4. "Our launch.json is broken. Repair startup flow and document usage in README."
5. "If Node is missing, install/configure Node LTS; otherwise use IIS Express on this machine."
6. "Add default browser startup profile in addition to Chrome and Edge private modes."

## Beispiel-Promptsammlung (Deutsch)

1. "Repariere F5 in diesem Website-Projekt: erst lokalen Server starten, dann Browser oeffnen."
2. "Lege Run-and-Debug-Profile fuer Chrome Inkognito, Edge InPrivate und Standardbrowser an."
3. "Wenn Node fehlt, fuehre durch die Node-LTS-Installation; sonst nutze IIS Express, falls vorhanden."
4. "Nutze vorhandene Serverdateien weiter und erzeuge nur bei Bedarf eine neue server.js."
5. "Bereinige launch.json, tasks.json und keybindings.json, ohne bestehende fremde Tasks zu loeschen."
6. "Ergaenze die README um kurze Hinweise zur Startauswahl in VS Code."

## Suggested Naming Convention

Use labels and names in this style:

- Task: Start Local Node Server
- Task: Open Chrome Incognito
- Task: Open Edge InPrivate
- Task: Open Default Browser
- Task: Start Website (Chrome Incognito)
- Task: Start Website (Edge InPrivate)
- Task: Start Website (Default Browser)

- Launch: Start Website - Chrome Incognito
- Launch: Start Website - Edge InPrivate
- Launch: Start Website - Default Browser

## Output Format For The User

After applying changes, report:

1. Files changed.
2. Startup profiles now available.
3. Validation results (errors and task test status).
4. Any assumptions that may need user confirmation.
