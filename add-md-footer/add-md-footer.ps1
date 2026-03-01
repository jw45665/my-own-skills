<#
.SYNOPSIS
    GitHub Copilot Skill: Fügt Markdown-Dateien einen Footer mit Titel und aktuellem Datum hinzu.

.DESCRIPTION
    Dieses Skill-Skript verarbeitet Markdown-Dateien und versieht sie mit einem standardisierten Footer.
    Der Footer enthält den Titel der Datei (aus der ersten Überschrift) und das aktuelle Datum.

.PARAMETER Path
    Der Pfad zum Verzeichnis mit Markdown-Dateien oder zu einer einzelnen MD-Datei.
    Standard: Aktuelles Verzeichnis (.)

.PARAMETER Force
    Wenn gesetzt, werden existierende Footer aktualisiert. Andernfalls wird eine Datei übersprungen,
    falls bereits ein Footer vorhanden ist.

.EXAMPLE
    .\add-md-footer.ps1 -Path "." -Force
    Verarbeitet alle MD-Dateien im aktuellen Verzeichnis und aktualisiert existierende Footer.

.EXAMPLE
    .\add-md-footer.ps1 -Path ".\docs\Dokumentation.md"
    Verarbeitet nur diese eine Datei.

.NOTES
    GitHub Copilot Skill: add-md-footer
    Version: 1.0.0
    Author: JW
    License: © JW 2026
#>

param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Path = ".",
    
    [Parameter(Mandatory = $false)]
    [switch]$Force
)

# ============================================================================
# Konfiguration
# ============================================================================

$config = @{
    Copyright        = "© JW 2026"
    DateFormat       = "dd.MM.yyyy"
    FooterMarker     = "<!-- Footer -->"
    Encoding         = "UTF8"
    SeparatorCount   = 1  # Anzahl der "---" vor dem Footer
}

$colors = @{
    Info     = "Cyan"
    Success  = "Green"
    Warning  = "Yellow"
    Error    = "Red"
    Debug    = "DarkGray"
}

# ============================================================================
# Funktionen
# ============================================================================

function Write-Log {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Success", "Warning", "Error", "Debug")]
        [string]$Level = "Info"
    )
    
    $color = $colors[$Level]
    Write-Host $Message -ForegroundColor $color
}

function Get-MarkdownTitle {
    param([string]$Content)
    
    $lines = $Content -split "`n"
    foreach ($line in $lines) {
        if ($line -match "^#\s+(.+)$") {
            return $Matches[1].Trim()
        }
    }
    return $null
}

function Remove-ExistingFooter {
    param([string]$Content)
    
    # Entferne existierenden Footer (inkl. separator line)
    $pattern = "(?s)---\s*\r?\n\s*$($config.FooterMarker).*?</div>\s*$"
    $cleaned = $Content -replace $pattern, ""
    return $cleaned.TrimEnd()
}

function New-Footer {
    param(
        [string]$Title,
        [string]$Date
    )
    
    $footer = @"

---

<!-- Footer -->
<div style="text-align: center; font-size: 0.8em; color: #666; margin-top: 2em;">
  <p style="margin:0;">$Title</p>
  <p style="margin:0; font-size: 0.9em;">$($config.Copyright) | Stand: $Date</p>
</div>
"@
    return $footer
}

# ============================================================================
# Haupt-Verarbeitung
# ============================================================================

Write-Log "🔧 MD-Footer Skill: Starte Verarbeitung..." -Level Info

# Bestimme ob Path ein Verzeichnis oder eine Datei ist
$isDirectory = Test-Path -Path $Path -PathType Container
$mdFiles = @()

if ($isDirectory) {
    $mdFiles = @(Get-ChildItem -Path $Path -Filter "*.md" -File -ErrorAction SilentlyContinue)
    Write-Log "📁 Verzeichnis gefunden: $Path" -Level Info
    Write-Log "📄 Gefundene MD-Dateien: $($mdFiles.Count)" -Level Info
} else {
    if (Test-Path -Path $Path -PathType Leaf) {
        if ($Path -like "*.md") {
            $mdFiles = @(Get-Item -Path $Path)
            Write-Log "📄 Einzelne Datei gefunden: $Path" -Level Info
        } else {
            Write-Log "❌ Datei ist keine Markdown-Datei: $Path" -Level Error
            exit 1
        }
    } else {
        Write-Log "❌ Pfad nicht gefunden: $Path" -Level Error
        exit 1
    }
}

if ($mdFiles.Count -eq 0) {
    Write-Log "⚠️  Keine MD-Dateien gefunden." -Level Warning
    exit 0
}

# Hole aktuelles Datum
$today = Get-Date -Format $config.DateFormat

# Verarbeite Dateien
$processed = 0
$skipped = 0

foreach ($file in $mdFiles) {
    $filePath = $file.FullName
    $fileName = $file.Name
    
    try {
        # Lese Datei-Inhalt
        $content = Get-Content -Path $filePath -Raw -Encoding $config.Encoding -ErrorAction Stop
        
        # Prüfe ob Footer bereits existiert
        $hasFooter = $content -match [regex]::Escape($config.FooterMarker)
        
        if ($hasFooter -and -not $Force) {
            Write-Log "⏭️  Übersprungen: $fileName (Footer existiert)" -Level Warning
            $skipped++
            continue
        }
        
        # Extrahiere Titel aus erster Heading-Zeile
        $title = Get-MarkdownTitle -Content $content
        if ([string]::IsNullOrWhiteSpace($title)) {
            $title = $fileName -replace '\.md$', ''
        }
        
        # Entferne existierenden Footer, falls vorhanden
        if ($hasFooter) {
            $content = Remove-ExistingFooter -Content $content
        }
        
        # Erstelle neuen Footer
        $footer = New-Footer -Title $title -Date $today
        
        # Schreibe Datei
        $newContent = $content + $footer
        Set-Content -Path $filePath -Value $newContent -Encoding $config.Encoding -NoNewline -ErrorAction Stop
        
        Write-Log "✅ Verarbeitet: $fileName" -Level Success
        $processed++
    }
    catch {
        Write-Log "❌ Fehler bei $fileName : $_" -Level Error
    }
}

# ============================================================================
# Zusammenfassung
# ============================================================================

Write-Host ""
Write-Log "📊 Zusammenfassung:" -Level Info
Write-Log "   ✅ Verarbeitet: $processed" -Level Success
Write-Log "   ⏭️  Übersprungen: $skipped" -Level Warning
Write-Log "📅 Heutiges Datum: $today" -Level Info

# Return exit code
if ($processed -gt 0) {
    exit 0
} else {
    exit 1
}
