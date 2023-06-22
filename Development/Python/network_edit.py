import wmi
import time

def set_network_adapter_config(adapter_name, ip_address=None, subnet_mask=None, gateway=None, dhcp_enabled=True, dns_servers=None):
    # Verbindung zur WMI-Instanz herstellen
    c = wmi.WMI()

    # Netzwerkadapter finden
    adapters = c.Win32_NetworkAdapterConfiguration(Index=adapter_name)
    if len(adapters) == 0:
        print("Adapter nicht gefunden.")
        return

    adapter = adapters[0]

    # Vorhandene Konfiguration entfernen
    adapter.EnableDHCP()  # DHCP aktivieren

    # Statische IP-Adresse setzen
    if ip_address and subnet_mask:
        adapter.EnableStatic()
        adapter.SetIPAddress(IPAddress=[ip_address])
        adapter.SetIPSubnetMask(SubnetMask=[subnet_mask])

    # Gateway setzen
    if gateway:
        adapter.SetGateways(DefaultIPGateway=[gateway])

    # DNS-Server setzen
    if dns_servers:
        adapter.SetDNSServerSearchOrder(dns_servers)

    # DHCP aktivieren/deaktivieren
    if not dhcp_enabled:
        adapter.EnableStatic()
        adapter.SetIPAddress(IPAddress=[ip_address])
        adapter.SetIPSubnetMask(SubnetMask=[subnet_mask])
        adapter.SetDNSServerSearchOrder(dns_servers)

    # Kurze Wartezeit, um Änderungen anzuwenden
    time.sleep(5)

    # IP-Einstellungen abrufen und überprüfen
    adapter = c.Win32_NetworkAdapterConfiguration(Index=adapter_name)[0]
    if adapter.IPAddress and adapter.IPAddress[0] == ip_address:
        print("IP-Einstellungen erfolgreich aktualisiert.")
    else:
        print("Fehler beim Aktualisieren der IP-Einstellungen.")

# Beispielaufruf: Netzwerkadapter "Ethernet" konfigurieren
adapter_name = 0  # Index des Netzwerkadapters
ip_address = '192.168.0.100'
subnet_mask = '255.255.255.0'
gateway = '192.168.0.1'
dhcp_enabled = False
dns_servers = ['8.8.8.8', '8.8.4.4']

set_network_adapter_config(adapter_name, ip_address, subnet_mask, gateway, dhcp_enabled, dns_servers)
