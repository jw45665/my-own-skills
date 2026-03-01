param(
    [string]$OllamaUrl = "http://192.168.178.42:11434",
    [string]$ConfigPath = "$env:APPDATA\Code - Insiders\User\chatLanguageModels.json"
)

Write-Host "Synchronisiere Ollama-Modelle von $OllamaUrl..." -ForegroundColor Cyan

try {
    # Abrufen der verfügbaren Modelle
    $response = Invoke-RestMethod -Uri "$OllamaUrl/api/tags" -ErrorAction Stop
    
    if (-not $response.models -or $response.models.Count -eq 0) {
        Write-Host "Keine Modelle gefunden!" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "Gefundene Modelle: $($response.models.Count)" -ForegroundColor Green

    $models = @()
    foreach ($model in $response.models) {
        # Parameter-Größe extrahieren und Token-Limits berechnen
        $paramSizeStr = $model.details.parameter_size
        if ($paramSizeStr -match '(\d+\.?\d*)B') {
            $paramSize = [double]$matches[1]
        } else {
            $paramSize = 7.0  # Default
        }

        # Token-Limits basierend auf Modellgröße
        if ($paramSize -lt 10) {
            $maxInput = 32768
            $maxOutput = 8192
        } elseif ($paramSize -lt 20) {
            $maxInput = 65536
            $maxOutput = 16384
        } else {
            $maxInput = 131072
            $maxOutput = 32768
        }

        $models += @{
            id = $model.name
            name = $model.name
            maxInputTokens = $maxInput
            maxOutputTokens = $maxOutput
        }

        Write-Host "  - $($model.name) ($paramSizeStr, $maxInput/$maxOutput Tokens)" -ForegroundColor Gray
    }

    # Config laden und aktualisieren
    if (-not (Test-Path $ConfigPath)) {
        Write-Host "Konfigurationsdatei nicht gefunden: $ConfigPath" -ForegroundColor Red
        exit 1
    }

    $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    $ollamaConfig = $config | Where-Object { $_.vendor -eq "ollama" }
    
    if (-not $ollamaConfig) {
        Write-Host "Ollama-Konfiguration nicht gefunden!" -ForegroundColor Yellow
        exit 1
    }

    $ollamaConfig.models = $models

    # Speichern
    $config | ConvertTo-Json -Depth 10 | Set-Content $ConfigPath -Encoding UTF8

    Write-Host "`n✓ $($models.Count) Modelle erfolgreich synchronisiert" -ForegroundColor Green

} catch {
    Write-Host "Fehler: $_" -ForegroundColor Red
    exit 1
}
