import json
import os
import psutil
import socket

def get_network_adapters_info():
    adapters = []

    for interface, addresses in psutil.net_if_addrs().items():
        adapter_info = {}
        adapter_info['name'] = interface

        for address in addresses:
            if address.family == socket.AF_INET:
                adapter_info['ip'] = address.address
                adapter_info['subnet_mask'] = address.netmask
                adapter_info['gateway'] = address.broadcast

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

def network_adapter_select_event(window, selected_adapter):
    json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator', 'network_adapters.json')

    with open(json_file_path) as file:
        adapters = json.load(file)
    selected_adapter_info = next((adapter for adapter in adapters if adapter['name'] == selected_adapter), None)
    if selected_adapter_info:
        info_text = f"Adapter: {selected_adapter_info['name']}\n"
        info_text += f"IP Address: {selected_adapter_info['ip']}\n"
        info_text += f"Subnet Mask: {selected_adapter_info['subnet_mask']}\n"
        info_text += f"Gateway: {selected_adapter_info['gateway']}\n"
        info_text += f"DNS Servers: {', '.join(selected_adapter_info['dns_servers'])}\n"
        info_text += f"Speed: {selected_adapter_info['speed']}"
        window.adapter_info_label.config(text=info_text)
    else:
        window.adapter_info_label.config(text="No information available")
