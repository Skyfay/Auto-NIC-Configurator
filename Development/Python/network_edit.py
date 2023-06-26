import os
import json
import wmi
import customtkinter
import ctypes
import sys
from network_collector import get_network_adapters_info
from network_viewer import network_adapter_select_event

# This part need administrator privileges
# https://learn.microsoft.com/de-de/windows/win32/cimwin32prov/win32-networkadapterconfiguration?redirectedfrom=MSDN

# Obtain network adaptors configurations
nic_configs = wmi.WMI().Win32_NetworkAdapterConfiguration(IPEnabled=True)

# First network adaptor
nic = nic_configs[0]

# IP address, subnetmask and gateway values should be unicode objects
ip = u'192.168.0.11'
subnetmask = u'255.255.255.0'
gateway = u'192.168.0.1'

# DNS server addresses should be unicode objects
dns_servers = [u'8.8.8.8', u'8.8.4.4']  # Example DNS server addresses

# Set IP address, subnetmask and default gateway
# Note: EnableStatic() and SetGateways() methods require *lists* of values to be passed
# Set DNS server addresses
nic.EnableStatic(IPAddress=[ip],SubnetMask=[subnetmask])
nic.SetGateways(DefaultIPGateway=[gateway])
nic.SetDNSServerSearchOrder(DNSServerSearchOrder=dns_servers)

# Enable DHCP
nic.EnableDHCP()
# Reset DNS server to obtain automatically (DHCP)
nic.SetDNSServerSearchOrder(DNSServerSearchOrder=[])

def get_adapter_index_from_json(adapter_name, json_file_path):
    with open(json_file_path, 'r') as json_file:
        data = json.load(json_file)

        for adapter in data:  # Iteriere direkt über die Adapterobjekte in der Liste
            if adapter['name'] == adapter_name:
                return adapter['AdapterIndex']

    return None

# This need Administrator privileges

def selected_adapter_set_custom_values(window, selected_adapter):
    # Überprüfen, ob die Anwendung mit Administratorrechten gestartet wurde
    if ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1) != 42:
        print("Error: The application needs to be run with administrator privileges.")
        error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                             text="Error: The application needs to be run with administrator privileges.",
                                             text_color="#ff4155",
                                             font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=7, column=0, padx=20, pady=5)
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        window.destroy()

    # Überprüfen, ob der Benutzer Administratorrechte hat
    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("Error: You need administrator privileges to perform this operation.")
        error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                             text="Error: You need administrator privileges to perform this operation.",
                                             text_color="#ff4155",
                                             font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=7, column=0, padx=20, pady=5)
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        return
    adapter_name = window.network_adapter_select.get()
    print("Der Adapter welcher ausgewählt wurde war: " + adapter_name)

    if adapter_name != "Select Adapter":
        ip = window.network_custom_ipadress_entry.get()
        subnetmask = window.network_custom_subnetmask_entry.get()
        gateway = window.network_custom_Gateway_entry.get()

        if ip and subnetmask and gateway:
            json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator', 'network_adapters.json')
            adapter_index = get_adapter_index_from_json(adapter_name, json_file_path)
            print("Hier ist der Adapter Index: " + str(adapter_index))

            if adapter_index is not None:
                # Adapterindex gefunden
                nic = nic_configs[adapter_index]

                dns_servers = [window.network_custom_DNS_entry.get(), window.network_custom_DNS2_entry.get()]

                print(ip, subnetmask, gateway)

                nic.EnableStatic(IPAddress=[ip], SubnetMask=[subnetmask])
                nic.SetGateways(DefaultIPGateway=[gateway])
                nic.SetDNSServerSearchOrder(DNSServerSearchOrder=dns_servers)

                get_network_adapters_info()  # Reload the Json file with the Adapter Information
                network_adapter_select_event(window, selected_adapter)  # Get the new Adapter Information from the Json
                success_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                      text="Your information was successfully entered",
                                                      text_color="#44ff41",
                                                      font=("TkDefaultFont", 12, "bold"))
                success_label.grid(row=7, column=0, padx=20, pady=5)
                window.after(3000, success_label.destroy)  # Remove the success message after 3 seconds
            else:
                # Adapterindex nicht gefunden
                print(f"Der Adapter '{adapter_name}' wurde nicht gefunden.")
        else:
            # Fehlende Eingaben
            print("One or more input fields are empty!")
            error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                 text="One or more input fields are empty!",
                                                 text_color="#ff4155",
                                                 font=("TkDefaultFont", 12, "bold"))
            error_label.grid(row=7, column=0, padx=20, pady=5)
            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
    else:
        # Ungültiger Adaptername ausgewählt
        print("You have not selected a network adapter yet!")
        error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                             text="You have not selected a network adapter yet!",
                                             text_color="#ff4155",
                                             font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=7, column=0, padx=20, pady=5)
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds



