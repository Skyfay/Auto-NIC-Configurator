cls
# Script von Skyfay
# Support auf Githup oder support@skyfay.ch

# ------------------------------------------------------------------------------ #

# AppData-Ordnerpfad holen
$appDataPath = [Environment]::GetFolderPath("LocalApplicationData")

# Ordnerpfad erstellen
$folderPath = Join-Path $appDataPath "SkyfaySoftware\AutoNicConfigurator"

# Ordner erstellen, falls er noch nicht vorhanden ist
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

# JSON-Dateipfad erstellen
$jsonFilePath = Join-Path $folderPath "db.json"

# JSON-Datei erstellen, falls sie noch nicht vorhanden ist
if (-not (Test-Path $jsonFilePath)) {
    $jsonObject = @{
        "Network-Adapter" = @()
    } | ConvertTo-Json -Depth 100
    Set-Content $jsonFilePath $jsonObject
}

# ------------------------------------------------------------------------------ #

# JSON-Datei laden
$jsonObject = Get-Content $jsonFilePath | ConvertFrom-Json

# Misst die Anzahl der Netzwerk Adapter, welche auf dem System vorhanden sind
$netAdapterCount = Get-NetAdapter | Measure

# Netzwerkadapter zählen und Informationen in ein Array speichern
$netAdapters = Get-NetAdapter | Select-Object Name, Status, MacAddress, LinkSpeed
$netAdapterCount = $netAdapters.Count

# Array für die Adapter erstellen
$adapters = @()

# Informationen zu jedem Adapter hinzufügen und in das Array einfügen
foreach ($adapter in $netAdapters) {
    $adapterInfo = @{
        "Name" = $adapter.Name
        "Status" = $adapter.Status
        "MacAddress" = $adapter.MacAddress
        "Speed" = $adapter.LinkSpeed
    }
    $adapters += $adapterInfo
}

# JSON-Objekt aktualisieren
$jsonObject."Network-Adapter" = @{
    "Count" = $netAdapterCount
    "Adapters" = $adapters
}

# JSON-Datei aktualisieren
$jsonObject | ConvertTo-Json -Depth 10 | Set-Content $jsonFilePath


# ------------------------------------------------------------------------------ #
