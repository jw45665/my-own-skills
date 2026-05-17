param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,

    [Parameter(Mandatory=$true)]
    [string]$ServerUrl,

    [Parameter(Mandatory=$true)]
    [string]$SiteName,

    [string]$Username = "Administrator",

    [securestring]$AdminCredential,

    [string]$AdminCredentialEnvVar = "IIS_ADMIN",

    [ValidateSet("Auto", "WMSVC", "RemoteAgent")]
    [string]$PreferredMethod = "Auto"
)

function Get-MsDeployPath {
    $candidates = @(
        "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe",
        "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    throw "MSDeploy (Web Deploy) ist nicht installiert."
}

function Resolve-Password {
    param(
        [securestring]$ProvidedCredential,
        [string]$AdminCredentialEnvVarName,
        [string]$UserName
    )

    if ($null -ne $ProvidedCredential) {
        $providedBstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ProvidedCredential)
        try {
            return [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($providedBstr)
        }
        finally {
            if ($providedBstr -ne [IntPtr]::Zero) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($providedBstr)
            }
        }
    }

    $envSecret = [Environment]::GetEnvironmentVariable($AdminCredentialEnvVarName)
    if (-not [string]::IsNullOrWhiteSpace($envSecret)) {
        return $envSecret
    }

    $promptedSecret = Read-Host "Passwort für $UserName" -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($promptedSecret)
    try {
        return [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        if ($bstr -ne [IntPtr]::Zero) {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }
}

function Test-PortOpen {
    param(
        [string]$HostName,
        [int]$Port
    )

    try {
        $result = Test-NetConnection $HostName -Port $Port -WarningAction SilentlyContinue
        return [bool]$result.TcpTestSucceeded
    }
    catch {
        return $false
    }
}

function Invoke-Deploy {
    param(
        [string]$MsDeployPath,
        [string]$PublishPath,
        [string]$DestinationArgument
    )

    $arguments = @(
        "-verb:sync",
        "-source:contentPath='$PublishPath'",
        $DestinationArgument,
        "-enableRule:AppOffline",
        "-enableRule:DoNotDeleteRule"
    )

    & $MsDeployPath @arguments | Out-Host
    return $LASTEXITCODE
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Generic IIS Web Deploy" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $SourcePath)) {
    Write-Host "FEHLER: SourcePath nicht gefunden: $SourcePath" -ForegroundColor Red
    exit 1
}

$deploySecret = Resolve-Password -ProvidedCredential $AdminCredential -AdminCredentialEnvVarName $AdminCredentialEnvVar -UserName $Username
$msdeployPath = Get-MsDeployPath
$selectedMethod = $PreferredMethod
$wmsvcReachable = Test-PortOpen -HostName $ServerUrl -Port 8172

if ($PreferredMethod -eq "Auto") {
    if ($wmsvcReachable) {
        $selectedMethod = "WMSVC"
    }
    else {
        $selectedMethod = "RemoteAgent"
    }
}

$destinationArgument = switch ($selectedMethod) {
    "WMSVC" {
        "-dest:contentPath='$SiteName',computerName='https://${ServerUrl}:8172/msdeploy.axd?site=$SiteName',userName='$Username',password='$deploySecret',authType='Basic'"
    }
    "RemoteAgent" {
        "-dest:contentPath='$SiteName',computerName='http://${ServerUrl}/msdeployagentservice',userName='$Username',password='$deploySecret',authType='NTLM'"
    }
}

Write-Host "Führe Web Deploy aus ($selectedMethod)..." -ForegroundColor Yellow
$deployExitCode = Invoke-Deploy -MsDeployPath $msdeployPath -PublishPath $SourcePath -DestinationArgument $destinationArgument
if ($deployExitCode -ne 0 -and $PreferredMethod -eq "Auto" -and $selectedMethod -eq "WMSVC") {
    Write-Host "WMSVC fehlgeschlagen, versuche Remote Agent..." -ForegroundColor Yellow
    $selectedMethod = "RemoteAgent"
    $destinationArgument = "-dest:contentPath='$SiteName',computerName='http://${ServerUrl}/msdeployagentservice',userName='$Username',password='$deploySecret',authType='NTLM'"
    $deployExitCode = Invoke-Deploy -MsDeployPath $msdeployPath -PublishPath $SourcePath -DestinationArgument $destinationArgument
}

if ($deployExitCode -ne 0) {
    Write-Host "" 
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Fehler bei der Veröffentlichung!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    exit 1
}

Write-Host "" 
Write-Host "========================================" -ForegroundColor Green
Write-Host "Veröffentlichung erfolgreich!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Deploy-Methode: $selectedMethod" -ForegroundColor Green
