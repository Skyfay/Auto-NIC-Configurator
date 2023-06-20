import json
import os
import datetime
import customtkinter

def network_adapter_select_event(window, selected_adapter):
    json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator', 'network_adapters.json')

    with open(json_file_path) as file:
        adapters = json.load(file)
    selected_adapter_info = next((adapter for adapter in adapters if adapter['name'] == selected_adapter), None)
    if selected_adapter_info:
        info_text = ""
        if selected_adapter_info['description'] != 'Unknown':
            info_text += f"{selected_adapter_info['description']}\n"
        info_text += f"IP Address: {selected_adapter_info['ip']}\n"
        info_text += f"Subnet Mask: {selected_adapter_info['subnet_mask']}\n"
        info_text += f"Gateway: {selected_adapter_info['gateway']}\n"
        info_text += f"DNS Servers: {', '.join(selected_adapter_info['dns_servers'])}\n"
        info_text += f"Speed: {selected_adapter_info['speed']}"
        window.adapter_info_label.configure(text=info_text)
    else:
        window.adapter_info_label.config(text="No information available")

    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"Log: [{timestamp}] - Selected other network adapter")

# Placeholder Network adapter select

def initialize_adapter_select_placeholder(window):
    placeholder_text = "Select Adapter"
    window.home_frame_adapter_select.set(placeholder_text)
    window.home_frame_adapter_select.configure(state="readonly")

def update_adapter_select_values(window, adapter_names):
    window.home_frame_adapter_select.configure(values=adapter_names)
def initialize_adapter_select_placeholder(window):
    placeholder_text = "Select Adapter"
    window.home_frame_adapter_select.set(placeholder_text)
    window.home_frame_adapter_select.menu.entryconfig(0, state="disabled")
