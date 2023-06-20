import subprocess

def update_network_settings(network_name, ip_address, subnet_mask, gateway, dns):
    ps_command = f"""
    $adapter = Get-NetAdapter -Name "{network_name}"
    $adapter | Set-NetIPAddress -IPAddress "{ip_address}" -PrefixLength {subnet_mask}
    $adapter | Set-NetIPInterface -InterfaceMetric 10
    $adapter | New-NetRoute -DestinationPrefix "0.0.0.0/0" -NextHop "{gateway}" -RouteMetric 20
    $adapter | Set-DnsClientServerAddress -ServerAddresses {','.join(dns)}
    """

    # PowerShell-Befehl ausführen und die Zeichenkodierung auf 'latin-1' festlegen
    result = subprocess.run(["powershell", "-Command", ps_command], capture_output=True, text=True, encoding='latin-1')

    # Ausgabe überprüfen
    if result.returncode == 0:
        print("Netzwerkeinstellungen erfolgreich aktualisiert.")
    else:
        print("Fehler beim Aktualisieren der Netzwerkeinstellungen.")
        print("PowerShell-Ausgabe:")
        print(result.stdout)

# Beispielaufruf - Aktualisierung der Netzwerkeinstellungen
network_name = 'Ethernet 2'
ip_address = '192.168.0.100'
subnet_mask = '24'
gateway = '192.168.0.1'
dns = ['8.8.8.8', '8.8.4.4']

update_network_settings(network_name, ip_address, subnet_mask, gateway, dns)
