import json
import os
import psutil
import socket
import wmi
import ipaddress
import subprocess
import re


import subprocess
import re

def get_default_gateway():
    process = subprocess.Popen(['ipconfig', '/all'], stdout=subprocess.PIPE)
    output, _ = process.communicate()

    output = output.decode('utf-8', errors='replace')

    adapters = re.split(r'\r\n\r\n', output)

    for adapter in adapters:
        if 'Standardgateway' in adapter:
            match = re.search(r'Beschreibung[.:]\s+(.*)', adapter)
            if match:
                adapter_description = match.group(1)
                gateway_match = re.search(r'Standardgateway[.:]\s+(\d+\.\d+\.\d+\.\d+)', adapter)
                if gateway_match:
                    gateway = gateway_match.group(1)
                    print(f"Adapter: {adapter_description}, Gateway: {gateway}")

get_default_gateway()

def get_network_adapters_info():
    wmi_interface = wmi.WMI()
    adapters = []

    for interface, addresses in psutil.net_if_addrs().items():
        adapter_info = {}
        adapter_info['name'] = interface

        # Get adapter description
        query = f"SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID = '{interface}'"
        results = wmi_interface.query(query)
        if results:
            adapter_info['description'] = results[0].Description
        else:
            adapter_info['description'] = 'Unknown'

        for address in addresses:
            if address.family == socket.AF_INET:
                adapter_info['ip'] = address.address
                adapter_info['subnet_mask'] = address.netmask

        # Get default gateway
        adapter_info['gateway'] = get_default_gateway()

        dns_servers = []
        try:
            resolver = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            resolver.connect(('8.8.8.8', 80))
            dns_servers.append(resolver.getsockname()[0])
            resolver.close()
        except socket.error:
            pass
        adapter_info['dns_servers'] = dns_servers

        try:
            stats = psutil.net_if_stats()[interface]
            adapter_info['speed'] = stats.speed
        except KeyError:
            adapter_info['speed'] = 'Unknown'

        adapters.append(adapter_info)

    output_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    os.makedirs(output_dir, exist_ok=True)

    output_file = os.path.join(output_dir, 'network_adapters.json')
    with open(output_file, 'w') as file:
        json.dump(adapters, file, indent=4)
