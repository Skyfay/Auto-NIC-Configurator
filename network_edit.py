import logging
import os
import json
import wmi
import customtkinter
import ctypes
import sys
import ipaddress
import subprocess
from network_collector import get_network_adapters_info
from network_viewer import network_adapter_select_event
from log import log_warning, log_info, log_error, log_success

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

def selected_adapter_release_renew(window, selected_adapter):
    if ctypes.windll.shell32.IsUserAnAdmin():
        log_info("The Application already got admin privileges.")
    else:
        # Überprüfen, ob die Anwendung mit Administratorrechten gestartet wurde
        if ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1) != 42:
            log_warning("The application needs to be run with administrator privileges. Restarting the application...")
        window.destroy()

    adapter_name = window.network_adapter_select.get()
    log_info("The selected adapter in network tab is: " + adapter_name)

    if adapter_name != "Select Adapter":
        json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator',
                                      'network_adapters.json')
        adapter_index = get_adapter_index_from_json(adapter_name, json_file_path)
        log_info("The adapter index from the selected adapter is: " + str(adapter_index))

        if adapter_index is not None:

            wait_label = customtkinter.CTkLabel(window.network_presettings_frame,
                                                   text="This can take a few seconds please wait...",
                                                   text_color="#ffaa41",
                                                   font=("TkDefaultFont", 12, "bold"))
            wait_label.grid(row=7, column=0, padx=20, pady=5)
            window.update()

            # Adapterindex gefunden
            nic = nic_configs[adapter_index]

            # IP-Adresse freigeben
            nic.ReleaseDHCPLease()
            # IP-Adresse erneuern
            nic.RenewDHCPLease()

            get_network_adapters_info()  # Reload the Json file with the Adapter Information
            network_adapter_select_event(window, selected_adapter)  # Get the new Adapter Information from th

            log_success("The IP address of the adapter " + adapter_name + " was successfully released and renewed.")

            success_label = customtkinter.CTkLabel(window.network_presettings_frame,
                                                   text="The adapter was successfully released and renewed.",
                                                   text_color="#44ff41",
                                                   font=("TkDefaultFont", 12, "bold"))
            success_label.grid(row=7, column=0, padx=20, pady=5)
            window.after(3000, success_label.destroy)  # Remove the success message after 3 seconds
            wait_label.destroy()
        else:
            # Adapterindex nicht gefunden
            log_error("The adapter " + adapter_name + " was not found.")

    else:
        # Ungültiger Adaptername ausgewählt
        log_warning("You have not selected a network adapter yet!")
        error_label = customtkinter.CTkLabel(window.network_presettings_frame,
                                             text="You have not selected a network adapter yet!",
                                             text_color="#ff4155",
                                             font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=7, column=0, padx=20, pady=5)
        window.network_adapter_select.configure(fg_color="#ff4155", button_color="#a13f48")
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        window.after(3000, lambda: window.network_adapter_select.configure(fg_color=("#3b8ed0", "#1f6aa5"),
                                                                           button_color=("#36719f",
                                                                                         "#144870")))  # Remove the error message after 3 seconds

def flush_dns(window):
    if ctypes.windll.shell32.IsUserAnAdmin():
        log_info("The application already has admin privileges.")
    else:
        # Überprüfen, ob die Anwendung mit Administratorrechten gestartet wurde
        if ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1) != 42:
            log_warning("The application needs to be run with administrator privileges. Restarting the application...")
        window.destroy()

    try:
        # Befehl "ipconfig /flushdns" ausführen
        subprocess.run(["ipconfig", "/flushdns"], check=True, shell=True)
        log_success("The DNS cache was successfully flushed.")
        success_label = customtkinter.CTkLabel(window.network_presettings_frame,
                                               text="The DNS cache was successfully flushed.",
                                               text_color="#44ff41",
                                               font=("TkDefaultFont", 12, "bold"))
        success_label.grid(row=7, column=0, padx=20, pady=5)
        window.after(3000, success_label.destroy)  # Remove the success message after 3 seconds
    except subprocess.CalledProcessError as e:
        log_error("Failed to flush DNS cache:", e)

# This need Administrator privileges
def selected_adapter_enable_dhcp(window, selected_adapter):
    if ctypes.windll.shell32.IsUserAnAdmin():
        log_info("The Application already got admin privileges.")
    else:
        # Überprüfen, ob die Anwendung mit Administratorrechten gestartet wurde
        if ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1) != 42:
            log_warning("The application needs to be run with administrator privileges. Restarting the application...")
        window.destroy()

    adapter_name = window.network_adapter_select.get()
    log_info("The selected adapter in network tab is: " + adapter_name)

    if adapter_name != "Select Adapter":
        json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator',
                                      'network_adapters.json')
        adapter_index = get_adapter_index_from_json(adapter_name, json_file_path)
        log_info("The adapter index from the selected adapter is: " + str(adapter_index))

        if adapter_index is not None:
            # Adapterindex gefunden
            nic = nic_configs[adapter_index]

            # Remove default gateway
            nic.SetGateways(DefaultIPGateway=[], GatewayCostMetric=[])
            # Enable DHCP
            nic.EnableDHCP()
            # Reset DNS server to obtain automatically (DHCP)
            nic.SetDNSServerSearchOrder(DNSServerSearchOrder=[])
            # IP-Adresse freigeben
            #nic.ReleaseDHCPLease()
            # IP-Adresse erneuern
            #nic.RenewDHCPLease()

            get_network_adapters_info()  # Reload the Json file with the Adapter Information
            network_adapter_select_event(window, selected_adapter)  # Get the new Adapter Information from the Json
            log_success("The network adapter was successfully set to DHCP")
            success_label = customtkinter.CTkLabel(window.network_presettings_frame,
                                                   text="Your network adapter was successfully set to DHCP",
                                                   text_color="#44ff41",
                                                   font=("TkDefaultFont", 12, "bold"))
            success_label.grid(row=7, column=0, padx=20, pady=5)
            window.after(3000, success_label.destroy)  # Remove the success message after 3 seconds
        else:
            # Adapterindex nicht gefunden
            log_error("The adapter " + adapter_name + " was not found.")

    else:
        # Ungültiger Adaptername ausgewählt
        log_warning("You have not selected a network adapter yet!")
        error_label = customtkinter.CTkLabel(window.network_presettings_frame,
                                             text="You have not selected a network adapter yet!",
                                             text_color="#ff4155",
                                             font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=7, column=0, padx=20, pady=5)
        window.network_adapter_select.configure(fg_color="#ff4155", button_color="#a13f48")
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        window.after(3000, lambda: window.network_adapter_select.configure(fg_color=("#3b8ed0", "#1f6aa5"),
                                                                           button_color=("#36719f",
                                                                                         "#144870")))  # Remove the error message after 3 seconds



def selected_adapter_set_custom_values(window, selected_adapter):
    if ctypes.windll.shell32.IsUserAnAdmin():
        log_info("The Application already got admin privileges.")
    else:
        # Überprüfen, ob die Anwendung mit Administratorrechten gestartet wurde
        if ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1) != 42:
            log_warning("The application needs to be run with administrator privileges. Restarting the application...")
        window.destroy()


    adapter_name = window.network_adapter_select.get()
    log_info("The selected adapter in network tab is: " + adapter_name)

    if adapter_name != "Select Adapter":
        ip = window.network_custom_ipadress_entry.get()
        subnetmask = window.network_custom_subnetmask_entry.get()
        gateway = window.network_custom_Gateway_entry.get()
        dns1 = window.network_custom_DNS_entry.get()
        dns2 = window.network_custom_DNS2_entry.get()

        if (ip and subnetmask and gateway) or dns1 or dns2:
            if ip and subnetmask and gateway:
                # Überprüfen, ob die anderen beiden Werte ebenfalls ausgefüllt sind
                if not (subnetmask and gateway) or not (ip and gateway) or not (ip and subnetmask):
                    log_error("One or more input fields are missing!")
                    error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                         text="One or more input fields are missing!",
                                                         text_color="#ff4155",
                                                         font=("TkDefaultFont", 12, "bold"))
                    error_label.grid(row=7, column=0, padx=20, pady=5)
                    window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
                    return

                # Überprüfen der IP-Adresse
                try:
                    ipaddress.ip_address(ip)
                except ValueError:
                    log_error("Invalid IP Address!")
                    error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                         text="Invalid IP Address!",
                                                         text_color="#ff4155",
                                                         font=("TkDefaultFont", 12, "bold"))
                    error_label.grid(row=7, column=0, padx=20, pady=5)
                    window.network_custom_ipadress_entry.configure(fg_color="#a13f48")
                    window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
                    window.after(3000, lambda: window.network_custom_ipadress_entry.configure(fg_color=("#f9f9fa", "#343638")))
                    return

                # Überprüfen der Subnetzmaske
                try:
                    ipaddress.ip_network(ip + "/" + subnetmask, strict=False)
                except ValueError:
                    log_error("Invalid Subnet Mask!")
                    error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                         text="Invalid Subnet Mask!",
                                                         text_color="#ff4155",
                                                         font=("TkDefaultFont", 12, "bold"))
                    error_label.grid(row=7, column=0, padx=20, pady=5)
                    window.network_custom_subnetmask_entry.configure(fg_color="#a13f48")
                    window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
                    window.after(3000, lambda: window.network_custom_subnetmask_entry.configure(fg_color=("#f9f9fa", "#343638")))
                    return

                # Überprüfen des Gateways
                try:
                    ipaddress.ip_address(gateway)
                except ValueError:
                    log_error("Invalid Gateway!")
                    error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                         text="Invalid Gateway!",
                                                         text_color="#ff4155",
                                                         font=("TkDefaultFont", 12, "bold"))
                    error_label.grid(row=7, column=0, padx=20, pady=5)
                    window.network_custom_Gateway_entry.configure(fg_color="#a13f48")
                    window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
                    window.after(3000, lambda: window.network_custom_Gateway_entry.configure(fg_color=("#f9f9fa", "#343638")))

                try:
                    ipaddress.ip_address(gateway)
                except ValueError:
                    log_error("Invalid Gateway!")
                    error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                         text="Invalid Gateway!",
                                                         text_color="#ff4155",
                                                         font=("TkDefaultFont", 12, "bold"))
                    error_label.grid(row=7, column=0, padx=20, pady=5)
                    window.network_custom_Gateway_entry.configure(fg_color="#a13f48")
                    window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
                    window.after(3000, lambda: window.network_custom_Gateway_entry.configure(fg_color=("#f9f9fa", "#343638")))
                    return

            # Überprüfen der DNS-Server
            dns_servers = []
            if dns1:
                try:
                    ipaddress.ip_address(dns1)
                    dns_servers.append(dns1)
                except ValueError:
                    log_error("Invalid DNS Server!")
                    error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                         text="Invalid DNS Server!",
                                                         text_color="#ff4155",
                                                         font=("TkDefaultFont", 12, "bold"))
                    error_label.grid(row=7, column=0, padx=20, pady=5)
                    window.network_custom_DNS_entry.configure(fg_color="#a13f48")
                    window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
                    window.after(3000, lambda: window.network_custom_DNS_entry.configure(fg_color=("#f9f9fa", "#343638")))
                    return

            if dns2:
                try:
                    ipaddress.ip_address(dns2)
                    dns_servers.append(dns2)
                except ValueError:
                    log_error("Invalid DNS Server!")
                    error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                         text="Invalid DNS Server!",
                                                         text_color="#ff4155",
                                                         font=("TkDefaultFont", 12, "bold"))
                    error_label.grid(row=7, column=0, padx=20, pady=5)
                    window.network_custom_DNS2_entry.configure(fg_color="#a13f48")
                    window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
                    window.after(3000, lambda: window.network_custom_DNS2_entry.configure(fg_color=("#f9f9fa", "#343638")))
                    return

            json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator',
                                          'network_adapters.json')
            adapter_index = get_adapter_index_from_json(adapter_name, json_file_path)
            log_info("The adapter index from the selected adapter is: " + str(adapter_index))

            if adapter_index is not None:
                # Adapterindex gefunden
                nic = nic_configs[adapter_index]

                nic.EnableStatic(IPAddress=[ip], SubnetMask=[subnetmask])
                nic.SetGateways(DefaultIPGateway=[gateway])
                nic.SetDNSServerSearchOrder(DNSServerSearchOrder=dns_servers)

                get_network_adapters_info()  # Reload the Json file with the Adapter Information
                network_adapter_select_event(window, selected_adapter)  # Get the new Adapter Information from the Json
                log_success("The network adapter was successfully configured")
                success_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                       text="Your information was successfully entered",
                                                       text_color="#44ff41",
                                                       font=("TkDefaultFont", 12, "bold"))
                success_label.grid(row=7, column=0, padx=20, pady=5)
                window.after(3000, success_label.destroy)  # Remove the success message after 3 seconds
            else:
                # Adapterindex nicht gefunden
                log_error("The adapter " + adapter_name + " was not found.")
        else:
            # Ungültige Eingabe
            log_error("Invalid input! Please enter at least one of the following: IP Address, Subnet Mask, Gateway, or DNS.")
            error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                                 text="Invalid input!\nPlease enter IP Address, Subnet Mask, Gateway, or DNS.",
                                                 text_color="#ff4155",
                                                 font=("TkDefaultFont", 12, "bold"))
            error_label.grid(row=7, column=0, padx=20, pady=5)
            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
    else:
        # Ungültiger Adaptername ausgewählt
        log_warning("You have not selected a network adapter yet!")
        error_label = customtkinter.CTkLabel(window.network_custom_frame,
                                             text="You have not selected a network adapter yet!",
                                             text_color="#ff4155",
                                             font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=7, column=0, padx=20, pady=5)
        window.network_adapter_select.configure(fg_color="#ff4155", button_color="#a13f48")
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        window.after(3000, lambda: window.network_adapter_select.configure(fg_color=("#3b8ed0", "#1f6aa5"), button_color=("#36719f", "#144870")))  # Remove the error message after 3 seconds



def open_network_adapter_settings():
    try:
        result = subprocess.run(['ncpa.cpl'], check=False, shell=True)
        return result
    except subprocess.CalledProcessError as e:
        log_error("Fehler beim Öffnen der Netzwerkadaptereinstellungen:", e)

