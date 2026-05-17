param(
    [string]$LMStudioUrl = "http://192.168.178.42:1234",
    [string]$ConfigPath = "$env:APPDATA\Code - Insiders\User\chatLanguageModels.json",
    [bool]$EnableVision = $true
)

Write-Host "Synchronisiere LM-Studio-Modelle von $LMStudioUrl..." -ForegroundColor Cyan

try {
    # Abrufen der verfügbaren Modelle (OpenAI-kompatible API)
    Write-Host "Verbindung zu LM Studio Server wird geprüft..." -ForegroundColor Gray
    $response = Invoke-RestMethod -Uri "$LMStudioUrl/v1/models" -ErrorAction Stop
    
    if (-not $response.data -or $response.data.Count -eq 0) {
        Write-Host "Keine Modelle gefunden!" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "Verbindung zu LM Studio Server erfolgreich." -ForegroundColor Green
    Write-Host "Gefundene Modelle: $($response.data.Count)" -ForegroundColor Green
    Write-Host ""

    $models = @()
    foreach ($model in $response.data) {
        $modelId = $model.id
        
        # Vision erkennen (basierend auf Modell-ID)
        $hasVision = $false
        if ($EnableVision -and ($modelId -match 'llava|vision|clip')) {
            $hasVision = $true
        }

        # Tool-Calling erkennen (basierend auf Modell-ID)
        $hasToolCalling = $false
        if ($modelId -match 'qwen|function|gpt|command|tool' -and $modelId -notmatch 'embedding') {
            $hasToolCalling = $true
        }

        # Token-Limits basierend auf Modellgröße (aus ID extrahieren)
        $maxInput = 128000
        $maxOutput = 16000

        if ($modelId -match '(\d+)b' -or $modelId -match '(\d+\.?\d+)b') {
            $size = [double]$matches[1]
            if ($size -lt 10) {
                $maxInput = 32768
                $maxOutput = 8192
            } elseif ($size -gt 30) {
                $maxInput = 256000
                $maxOutput = 32000
            }
        }

        # Friendly name: Letzter Teil des ID verwenden
        $friendlyName = if ($modelId -match '/([^/]+)$') { $matches[1] } else { $modelId }

        $modelEntry = @{
            id = $modelId
            name = $friendlyName
            url = $LMStudioUrl
            toolCalling = $hasToolCalling
            vision = $hasVision
            maxInputTokens = $maxInput
            maxOutputTokens = $maxOutput
        }

        $models += $modelEntry

        # Capabilities anzeigen
        $capabilities = @()
        if ($hasVision) { $capabilities += "Vision" }
        if ($hasToolCalling) { $capabilities += "Tool-Calling" }
        
        $capStr = if ($capabilities.Count -gt 0) { " (" + ($capabilities -join ", ") + ")" } else { "" }
        Write-Host "  - $friendlyName$capStr" -ForegroundColor Gray
    }

    Write-Host ""

    # Config laden
    if (-not (Test-Path $ConfigPath)) {
        Write-Host "Konfigurationsdatei nicht gefunden: $ConfigPath" -ForegroundColor Red
        exit 1
    }

    $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    
    # LM-Studio-Konfiguration suchen oder erstellen
    $lmStudioConfig = $config | Where-Object { $_.vendor -eq "customoai" }
    
    if (-not $lmStudioConfig) {
        Write-Host "LM-Studio-Konfiguration nicht gefunden, wird erstellt..." -ForegroundColor Yellow
        $lmStudioConfig = @{
            name = "LM-Studio"
            vendor = "customoai"
            models = @()
        }
        $config += $lmStudioConfig
    }

    $lmStudioConfig.models = $models

    # Speichern
    $config | ConvertTo-Json -Depth 10 | Set-Content $ConfigPath -Encoding UTF8

    Write-Host "Konfiguration aktualisiert." -ForegroundColor Green
    Write-Host "✓ $($models.Count) Modelle erfolgreich synchronisiert" -ForegroundColor Green

} catch {
    Write-Host "Fehler: $_" -ForegroundColor Red
    if ($_.Exception.Message -match "unable to connect") {
        Write-Host "Hinweis: Stelle sicher, dass LM Studio läuft und der Server gestartet ist." -ForegroundColor Yellow
    }
    exit 1
}
