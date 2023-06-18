import json
import os
import psutil
import socket

def get_network_adapters_info():
    adapters = []

    # Get network adapters information using psutil module
    for interface, addresses in psutil.net_if_addrs().items():
        adapter_info = {}
        adapter_info['name'] = interface

        # Get IPv4 address, subnet mask, and gateway
        for address in addresses:
            if address.family == socket.AF_INET:
                adapter_info['ip'] = address.address
                adapter_info['subnet_mask'] = address.netmask
                adapter_info['gateway'] = address.broadcast

        # Get DNS servers using socket module
        dns_servers = []
        try:
            resolver = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            resolver.connect(('8.8.8.8', 80))
            dns_servers.append(resolver.getsockname()[0])
            resolver.close()
        except socket.error:
            pass
        adapter_info['dns_servers'] = dns_servers

        # Get network speed information using psutil module
        try:
            stats = psutil.net_if_stats()[interface]
            adapter_info['speed'] = stats.speed
        except KeyError:
            adapter_info['speed'] = 'Unknown'

        adapters.append(adapter_info)

    # Create directory if it doesn't exist
    output_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    os.makedirs(output_dir, exist_ok=True)

    # Save adapters information to JSON file
    output_file = os.path.join(output_dir, 'network_adapters.json')
    with open(output_file, 'w') as file:
        json.dump(adapters, file, indent=4)


def network_adapter_select_function():
    def get_network_adapter_names(window):
        # Load network adapters from JSON file
        with open(json_file_path) as file:
            adapters = json.load(file)

        # Extract adapter names
        adapter_names = [adapter['name'] for adapter in adapters]

        return adapter_names

    # Definiere den Pfad zur network_adapters.json-Datei
    json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator',
                                  'network_adapters.json')

    adapter_names = get_network_adapter_names(window)