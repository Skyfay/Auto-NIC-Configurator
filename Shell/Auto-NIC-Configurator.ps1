# creator: Skyfay
# Last edit: 14.07.2022

# Auto Network Interface Card Script

################
## Funktionen ##
################


function dhcp {
    Remove-NetIPAddress -InterfaceIndex $network_adapter -confirm:$false
    Remove-NetRoute -ifIndex $network_adapter -confirm:$false # -DestinationPrefix 0.0.0.0/0
    Set-DnsClientServerAddress -InterfaceIndex $network_adapter -confirm:$false -ResetServerAddresses
    Set-NetIPInterface -InterfaceIndex $network_adapter -Dhcp Enabled -confirm:$false
}

function securepoint {
    dhcp

    # Securepoint Settings
    New-Netipaddress -InterfaceIndex $network_adapter -IPAddress 192.168.175.5 -PrefixLength 24 -DefaultGateway 192.168.175.1 -confirm:$false
    # New-NetRoute -ifIndex $network_adapter -DestinationPrefix 0.0.0.0/0 -NextHop 192.168.175.1
    Set-DnsClientServerAddress -InterfaceIndex $network_adapter -ServerAddresses 192.168.175.1 -confirm:$false
}

function custom {
    dhcp
    cls
    $ip_adress = Read-Host "Welche IP Adresse möchtest du vergeben?"
    $cidr = Read-Host "Welche Subnetzmaske möchtest du vergeben? (z.B 24)"
    $gateway = Read-Host "Welchen Gateway möchtest du vergeben?"
    $dns = Read-Host "Welche IP möchtest du als DNS Adresse"
    New-Netipaddress -InterfaceIndex $network_adapter -IPAddress $ip_adress -PrefixLength $cidr -DefaultGateway $gateway -confirm:$false
    Set-DnsClientServerAddress -InterfaceIndex $network_adapter -ServerAddresses $dns -confirm:$false
}

################
##  Main Code ##
################
cls

Write-Host "Willkommen beim Nic Interface Card Setup"
Start-Sleep 1
Write-Host `n
Write-Host "(1)  -  DHCP (Default)"
Write-Host "(2)  -  Custom (Eigene Werte)"
Write-Host "(3)  -  Securepoint Firewall"
Write-Host `n
# Start-Sleep 1
$mode = Read-Host "Welchen Modus möchtest du verwenden?"
cls
Get-NetAdapter
Write-Host `n
$network_adapter = Read-Host "Hier sind die Netzwerk Schnittstellen. Welche möchtest du konfigurieren? (ifIndex Nummer)"
Start-Sleep 1

switch ($mode) {
        1 {dhcp}
        2 {custom}
        3 {securepoint}
        4 {asus}
        Default {Bitte gib eine Nummer zwischen 1-3 ein!}
}

cls

Write-Host "Der Adapter wurde erfolgreich geändert!"
Start-Sleep 1


