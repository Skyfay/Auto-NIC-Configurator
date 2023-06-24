import json
import os
import datetime

# Get the network adapters information from the json file and view it
def network_adapter_select_event(window, selected_adapter):
    # Set the path where the json file is located
    json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator', 'network_adapters.json')

    with open(json_file_path) as file:
        adapters = json.load(file)

    selected_adapter_info = next((adapter for adapter in adapters if adapter['name'] == selected_adapter), None)

    if selected_adapter_info:
        textbox_names = [
            "network_information_frame_ipadress_textbox",
            "network_information_frame_subnetmask_textbox",
            "network_information_frame_gateway_textbox",
            "network_information_frame_dns_textbox",
            "network_information_frame_mac_textbox"
        ]

        textbox_values = [
            selected_adapter_info['ip'],
            selected_adapter_info['subnet_mask'],
            selected_adapter_info['gateway'],
            ', '.join(selected_adapter_info['dns_servers']),
            selected_adapter_info['mac']
        ]

        for textbox_name, textbox_value in zip(textbox_names, textbox_values):
            textbox = getattr(window, textbox_name)
            textbox.configure(state="normal")
            textbox.delete("1.0", "end")
            textbox.insert("1.0", textbox_value)
            textbox.configure(state="disabled")
    else:
        textbox_names = [
            "network_information_frame_ipadress_textbox",
            "network_information_frame_subnetmask_textbox",
            "network_information_frame_gateway_textbox",
            "network_information_frame_dns_textbox",
            "network_information_frame_mac_textbox"
        ]

        for textbox_name in textbox_names:
            textbox = getattr(window, textbox_name)
            textbox.configure(state="normal")
            textbox.delete("1.0", "end")
            textbox.configure(state="disabled")



    # Log when the user selected another network adapter
    #timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    #print(f"Log: [{timestamp}] - Selected other network adapter")

# Functions to make an adapter selection placeholder
def initialize_adapter_select_placeholder(window):
    placeholder_text = "Select Adapter"
    window.network_adapter_select.set(placeholder_text)
    window.network_adapter_select.configure(state="readonly")

def update_adapter_select_values(window, adapter_names):
    window.home_frame_adapter_select.configure(values=adapter_names)
def initialize_adapter_select_placeholder(window):
    placeholder_text = "Select Adapter"
    window.network_adapter_select.set(placeholder_text)
    window.network_adapter_select.menu.entryconfig(0, state="disabled")
