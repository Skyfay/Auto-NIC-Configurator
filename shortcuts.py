import customtkinter
import json
import os
import ctypes
import wmi
import ipaddress
import sys
import re

from network_viewer import network_adapter_select_event
from network_edit import get_adapter_index_from_json
from network_collector import get_network_adapters_info
from log import log_warning, log_info, log_error, log_success


def update_entry_numbers():
    # Pfad zur JSON-Datei
    CONFIG_DIR = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    CONFIG_FILE = os.path.join(CONFIG_DIR, 'shortcuts.json')

    # Überprüfe, ob die JSON-Datei existiert
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as file:
            entries = json.load(file)

        # Überprüfe, ob die Einträge in aufsteigender Reihenfolge sind
        keys = sorted(entries.keys(), key=lambda x: int(x))
        if keys != [str(i) for i in range(1, len(entries) + 1)]:
            new_entries = {}
            # Weise den Einträgen neue aufsteigende Nummern zu
            for index, key in enumerate(keys, start=1):
                new_entries[str(index)] = entries[key]

            entries = new_entries

            # Schreibe die aktualisierten Einträge zurück in die JSON-Datei
            with open(CONFIG_FILE, 'w') as file:
                json.dump(entries, file, indent=4)

            print("Einträge wurden aktualisiert und neu nummeriert.")
        else:
            print("Einträge sind bereits in aufsteigender Reihenfolge.")
    else:
        print("Die JSON-Datei existiert nicht.")

def write_entries_to_json(window):
    # Erstelle das Verzeichnis, falls es nicht existiert
    CONFIG_DIR = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    os.makedirs(CONFIG_DIR, exist_ok=True)

    # Pfad zur JSON-Datei
    CONFIG_FILE = os.path.join(CONFIG_DIR, 'shortcuts.json')

    try:
        file = open(CONFIG_FILE, "a+")
        file.seek(0)  # Gehe zum Anfang der Datei
        if file.read(1):  # Überprüfe, ob die Datei bereits Inhalt hat
            print("Die Datei existiert bereits.")
        else:
            file.write("{}")
            print("Die Datei wurde erstellt.")
        file.close()
    except FileExistsError:
        print("Die Datei existiert bereits.")

    # Lese die Werte aus den Entry-Feldern aus
    name = window.shortcut_name_entry.get()
    ip_address = window.shortcut_ipadress_entry.get()
    subnet_mask = window.shortcut_subnetmask_entry.get()
    gateway = window.shortcut_Gateway_entry.get()
    dns = window.shortcut_DNS_entry.get()
    dns2 = window.shortcut_DNS2_entry.get()

    if not name:
        log_error("Name field is missing!")
        print("Name-Feld ist leer!")
        error_label = customtkinter.CTkLabel(window,
                                             text="Name field is missing!",
                                             text_color="#ff4155",
                                             font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=8, column=0, padx=20, pady=5)
        window.shortcut_name_entry.configure(fg_color="#cc3444")
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        window.after(3000, lambda: window.shortcut_name_entry.configure(fg_color=("#f9f9fa", "#343638")))
        return

    # Überprüfen, ob der Name ungültige Zeichen enthält
    if not re.match(r'^[a-zA-Z0-9-_]+$', name):
        log_error("Invalid characters in name field!")
        invalid_chars = re.findall(r'[^a-zA-Z0-9-_]', name)
        invalid_chars = ', '.join(invalid_chars)
        error_msg = "Invalid characters in name field!\nDisallowed characters are: " + invalid_chars
        if ' ' in name:
            error_msg += "\nSpace key between characters is not allowed."
        error_label = customtkinter.CTkLabel(window, text=error_msg, text_color="#ff4155", font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=8, column=0, padx=20, pady=5)
        window.shortcut_name_entry.configure(fg_color="#cc3444")
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        window.after(3000, lambda: window.shortcut_name_entry.configure(fg_color=("#f9f9fa", "#343638")))
        return False

    # Überprüfe, ob bereits ein Eintrag mit demselben Namen vorhanden ist
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as file:
            existing_entries = json.load(file)
            for entry in existing_entries.values():
                if entry['name'] == name:
                    print("Es gibt bereits einen Eintrag mit diesem Namen.")
                    return

    # Überprüfen, ob mindestens eines der anderen Felder ausgefüllt ist
    if not any([ip_address, subnet_mask, gateway, dns, dns2]):
        error_msg = "Please fill in at least one additional field,\n besides the name."
        error_label = customtkinter.CTkLabel(window, text=error_msg, text_color="#ff4155", font=("TkDefaultFont", 12, "bold"))
        error_label.grid(row=9, column=0, padx=20, pady=5)
        window.after(100, lambda: window.shortcut_ipadress_entry.configure(fg_color="#cc3444"))
        window.after(300, lambda: window.shortcut_subnetmask_entry.configure(fg_color="#cc3444"))
        window.after(500, lambda: window.shortcut_Gateway_entry.configure(fg_color="#cc3444"))
        window.after(700, lambda: window.shortcut_DNS_entry.configure(fg_color="#cc3444"))
        window.after(900, lambda: window.shortcut_DNS2_entry.configure(fg_color="#cc3444"))

        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds

        window.after(1500, lambda: window.shortcut_ipadress_entry.configure(fg_color=("#f9f9fa", "#343638")))
        window.after(1700, lambda: window.shortcut_subnetmask_entry.configure(fg_color=("#f9f9fa", "#343638")))
        window.after(1900, lambda: window.shortcut_Gateway_entry.configure(fg_color=("#f9f9fa", "#343638")))
        window.after(2100, lambda: window.shortcut_DNS_entry.configure(fg_color=("#f9f9fa", "#343638")))
        window.after(2300, lambda: window.shortcut_DNS2_entry.configure(fg_color=("#f9f9fa", "#343638")))
        return False

    if ip_address or subnet_mask or gateway:
        if not (ip_address and subnet_mask and gateway):
            print("Eines oder mehrere Felder sind leer!")
            log_error("One or more input fields are missing!")
            error_label = customtkinter.CTkLabel(window,
                                                 text="One or more input fields are missing!",
                                                 text_color="#ff4155",
                                                 font=("TkDefaultFont", 12, "bold"))
            error_label.grid(row=8, column=0, padx=20, pady=5)
            window.shortcut_ipadress_entry.configure(fg_color="#cc3444")
            window.shortcut_subnetmask_entry.configure(fg_color="#cc3444")
            window.shortcut_Gateway_entry.configure(fg_color="#cc3444")
            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
            window.after(3000, lambda: window.shortcut_ipadress_entry.configure(fg_color=("#f9f9fa", "#343638")))
            window.after(3000, lambda: window.shortcut_subnetmask_entry.configure(fg_color=("#f9f9fa", "#343638")))
            window.after(3000, lambda: window.shortcut_Gateway_entry.configure(fg_color=("#f9f9fa", "#343638")))
            return

    # Überprüfen der IP-Adresse
    if ip_address:
        try:
            ipaddress.ip_address(ip_address)
        except ValueError:
            log_error("Invalid IP Address!")
            error_label = customtkinter.CTkLabel(window,
                                                 text="Invalid IP Address!",
                                                 text_color="#ff4155",
                                                 font=("TkDefaultFont", 12, "bold"))
            error_label.grid(row=8, column=0, padx=20, pady=5)
            window.shortcut_ipadress_entry.configure(fg_color="#a13f48")
            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
            window.after(3000, lambda: window.shortcut_ipadress_entry.configure(fg_color=("#f9f9fa", "#343638")))
            return

    # Überprüfen der Subnetzmaske
    if subnet_mask:
        try:
            ipaddress.ip_network(ip_address + "/" + subnet_mask, strict=False)
        except ValueError:
            log_error("Invalid Subnet Mask!")
            error_label = customtkinter.CTkLabel(window,
                                                 text="Invalid Subnet Mask!",
                                                 text_color="#ff4155",
                                                 font=("TkDefaultFont", 12, "bold"))
            error_label.grid(row=8, column=0, padx=20, pady=5)
            window.shortcut_subnetmask_entry.configure(fg_color="#a13f48")
            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
            window.after(3000, lambda: window.shortcut_subnetmask_entry.configure(fg_color=("#f9f9fa", "#343638")))
            return

    # Überprüfen des Gateways
    if gateway:
        try:
            ipaddress.ip_address(gateway)
        except ValueError:
            log_error("Invalid Gateway!")
            error_label = customtkinter.CTkLabel(window,
                                                 text="Invalid Gateway!",
                                                 text_color="#ff4155",
                                                 font=("TkDefaultFont", 12, "bold"))
            error_label.grid(row=8, column=0, padx=20, pady=5)
            window.shortcut_Gateway_entry.configure(fg_color="#a13f48")
            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
            window.after(3000, lambda: window.shortcut_Gateway_entry.configure(fg_color=("#f9f9fa", "#343638")))
            return

    # Überprüfen der DNS-Server
    dns_servers = []
    if dns:
        try:
            ipaddress.ip_address(dns)
            dns_servers.append(dns)
        except ValueError:
            log_error("Invalid DNS Server!")
            error_label = customtkinter.CTkLabel(window,
                                                 text="Invalid DNS Server!",
                                                 text_color="#ff4155",
                                                 font=("TkDefaultFont", 12, "bold"))
            error_label.grid(row=8, column=0, padx=20, pady=5)
            window.shortcut_DNS_entry.configure(fg_color="#a13f48")
            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
            window.after(3000, lambda: window.shortcut_DNS_entry.configure(fg_color=("#f9f9fa", "#343638")))
            return

    if dns2:
        try:
            ipaddress.ip_address(dns2)
            dns_servers.append(dns2)
        except ValueError:
            log_error("Invalid DNS Server!")
            error_label = customtkinter.CTkLabel(window,
                                                 text="Invalid DNS Server!",
                                                 text_color="#ff4155",
                                                 font=("TkDefaultFont", 12, "bold"))
            error_label.grid(row=8, column=0, padx=20, pady=5)
            window.shortcut_DNS2_entry.configure(fg_color="#a13f48")
            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
            window.after(3000, lambda: window.shortcut_DNS2_entry.configure(fg_color=("#f9f9fa", "#343638")))
            return

    # Überprüfe die höchste vorhandene Nummer in der JSON-Datei
    max_number = 0
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as file:
            entries = json.load(file)
            if entries:
                max_number = max(map(int, entries.keys()))

    # Erstelle ein Dictionary mit den ausgelesenen Werten und der nächsten Nummer
    entry_number = str(max_number + 1)
    entry = {
        'name': name,
        'ip_address': ip_address,
        'subnet_mask': subnet_mask,
        'gateway': gateway,
        'dns': dns,
        'dns2': dns2
    }
    entries = {entry_number: entry}

    # Füge den neuen Eintrag zur JSON-Datei hinzu
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as file:
            existing_entries = json.load(file)
            existing_entries.update(entries)
            entries = existing_entries

    # Schreibe die Einträge in die JSON-Datei
    with open(CONFIG_FILE, 'w') as file:
        json.dump(entries, file, indent=4)

    print("Einträge wurden in die JSON-Datei geschrieben.")
    window.destroy()

    update_entry_numbers()


def create_buttons_from_entries(window, selected_adapter):
    # Pfad zur JSON-Datei
    CONFIG_DIR = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    CONFIG_FILE = os.path.join(CONFIG_DIR, 'shortcuts.json')

    # Überprüfe, ob die Datei shortcuts.json existiert
    if os.path.exists(CONFIG_FILE):
        # Lade die Einträge aus der JSON-Datei
        with open(CONFIG_FILE, 'r') as file:
            entries = json.load(file)

        # Definiere den Startwert für die row- und column-Position
        start_row = 3
        start_column = 0

        # Entferne alle vorhandenen Buttons im network_shortcut_frame
        for widget in window.network_shortcut_frame.grid_slaves():
            widget.grid_forget()

        # Add Buttons to Add, Delete and Refresh the Network Shortcuts
        window.network_shortcut_add_button = customtkinter.CTkButton(window.network_shortcut_frame, text="Add Shortcut", width=150, hover_color=("gray70", "gray30"), fg_color=("gray75", "gray25"), image=window.add_box_image, command=window.open_shortcut_add_window)
        window.network_shortcut_add_button.grid(row=1, column=0, padx=20, pady=5)

        window.network_shortcut_remove_button = customtkinter.CTkButton(window.network_shortcut_frame, text="Remove", width=150, hover_color=("gray70", "gray30"), fg_color=("gray75", "gray25"), image=window.remove_image, command=window.open_shortcut_delete_window)
        window.network_shortcut_remove_button.grid(row=1, column=1, padx=20, pady=5)

        window.network_shortcut_reload_button = customtkinter.CTkButton(window.network_shortcut_frame, text="Reload", width=355, hover_color=("gray70", "gray30"), fg_color=("gray75", "gray25"), image=window.refresh_image, command=lambda: create_buttons_from_entries(window, window.network_adapter_select.get()))
        window.network_shortcut_reload_button.grid(row=2, column=0, padx=20, pady=5, columnspan=2, sticky="w")

        # Iteriere über die Einträge und erstelle Buttons
        for index, entry in enumerate(entries.values()):
            # Extrahiere den Namen des Eintrags
            name = entry.get('name')
            ip_address = entry.get('ip_address')
            subnet_mask = entry.get('subnet_mask')
            gateway = entry.get('gateway')
            dns = entry.get('dns')
            dns2 = entry.get('dns2')

            # Erstelle eine Funktion, die die Netzwerkeinstellungen mit den gegebenen Werten ändert
            # Obtain network adaptors configurations
            nic_configs = wmi.WMI().Win32_NetworkAdapterConfiguration(IPEnabled=True)
            def change_network_settings(ip, mask, gw, dns1, dns2, selected_adapter):
                if ctypes.windll.shell32.IsUserAnAdmin():
                    log_info("The Application already got admin privileges.")
                else:
                    # Überprüfen, ob die Anwendung mit Administratorrechten gestartet wurde
                    if ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1) != 42:
                        log_warning(
                            "The application needs to be run with administrator privileges. Restarting the application...")
                    window.destroy()

                adapter_name = window.network_adapter_select.get()
                log_info("The selected adapter in network tab is: " + adapter_name)

                if adapter_name != "Select Adapter":
                    ip = ip
                    subnetmask = mask
                    gateway = gw
                    dns1 = dns1
                    dns2 = dns2

                    if (ip and subnetmask and gateway) or dns1 or dns2:
                        if ip and subnetmask and gateway:
                            # Überprüfen, ob die anderen beiden Werte ebenfalls ausgefüllt sind
                            if not (subnetmask and gateway) or not (ip and gateway) or not (ip and subnetmask):
                                print("One or more input fields are missing!")
                                log_error("One or more input fields are missing!")
                                return

                            # Überprüfen der IP-Adresse
                            try:
                                ipaddress.ip_address(ip)
                            except ValueError:
                                print("Invalid IP Address!")
                                log_error("Invalid IP Address!")
                                return

                            # Überprüfen der Subnetzmaske
                            try:
                                ipaddress.ip_network(ip + "/" + subnetmask, strict=False)
                            except ValueError:
                                print("Invalid Subnet Mask!")
                                log_error("Invalid Subnet Mask!")
                                return

                            # Überprüfen des Gateways
                            try:
                                ipaddress.ip_address(gateway)
                            except ValueError:
                                print("Invalid Gateway!")
                                log_error("Invalid Gateway!")

                            try:
                                ipaddress.ip_address(gateway)
                            except ValueError:
                                print("Invalid Gateway!")
                                log_error("Invalid Gateway!")
                                return

                        # Überprüfen der DNS-Server
                        dns_servers = []
                        if dns1:
                            try:
                                ipaddress.ip_address(dns1)
                                dns_servers.append(dns1)
                            except ValueError:
                                print("Invalid DNS Server!")
                                log_error("Invalid DNS Server!")
                                return

                        if dns2:
                            try:
                                ipaddress.ip_address(dns2)
                                dns_servers.append(dns2)
                            except ValueError:
                                print("Invalid DNS Server!")
                                log_error("Invalid DNS Server!")
                                return

                        json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator',
                                                      'network_adapters.json')
                        adapter_index = get_adapter_index_from_json(adapter_name, json_file_path)
                        log_info("The adapter index from the selected adapter is: " + str(adapter_index))

                        if adapter_index is not None:
                            # Adapterindex gefunden
                            nic = nic_configs[adapter_index]

                            nic.EnableStatic(IPAddress=[ip], SubnetMask=[subnetmask])
                            nic.SetDNSServerSearchOrder(DNSServerSearchOrder=dns_servers)

                            get_network_adapters_info()  # Reload the Json file with the Adapter Information
                            network_adapter_select_event(window,
                                                         selected_adapter)  # Get the new Adapter Information from the Json
                            log_success("The network adapter was successfully configured")
                        else:
                            # Adapterindex nicht gefunden
                            log_error("The adapter " + adapter_name + " was not found.")
                    else:
                        # Ungültige Eingabe
                        log_error(
                            "Invalid input! Please enter at least one of the following: IP Address, Subnet Mask, Gateway, or DNS.")

                    # Ungültiger Adaptername ausgewählt
                    log_warning("You have not selected a network adapter yet!")


            # Erstelle einen benutzerdefinierten Button mit dem Platzhaltertext
            button = customtkinter.CTkButton(window.network_shortcut_frame, text=(name + "\n" + ip_address + "\n" + subnet_mask + "\n" + gateway + "\n" + dns + "\n" + dns2), height=100, width=150, command=lambda ip=ip_address, mask=subnet_mask, gw=gateway, dns1=dns, dns2=dns2: change_network_settings(ip, mask, gw, dns1, dns2, selected_adapter))
            button.grid(row=index // 2 + start_row, column=start_column, padx=20, pady=10)

            # Überprüfe, ob die row-Position erhöht werden muss
            if index % 2 != 0:
                start_row += 1

            # Überprüfe, ob die column-Position erhöht werden muss
            if start_column == 0:
                start_column = 1
            else:
                start_column = 0
                start_row += 1

        # Aktualisiere das Layout des network_shortcut_frame
        window.network_shortcut_frame.update()
    else:
        print("Es gibt derzeit keine Shortcuts.")


def get_shortcut_names_from_json():
    CONFIG_DIR = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    CONFIG_FILE = os.path.join(CONFIG_DIR, 'shortcuts.json')

    with open(CONFIG_FILE, 'r') as file:
        data = json.load(file)

    names = [data[key]['name'] for key in data]

    return names

def delete_shortcut_by_name(window):
    CONFIG_DIR = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    CONFIG_FILE = os.path.join(CONFIG_DIR, 'shortcuts.json')

    shortcut_name = window.shortcut_name_menu.get()

    with open(CONFIG_FILE, 'r') as file:
        data = json.load(file)

    # Durchsuche den Inhalt der JSON-Datei nach dem Namen
    keys_to_delete = []
    for key in data:
        if data[key]['name'] == shortcut_name:
            keys_to_delete.append(key)

    # Lösche die entsprechenden Einträge aus dem Datenobjekt
    for key in keys_to_delete:
        del data[key]

    # Speichere die aktualisierten Daten in der JSON-Datei
    with open(CONFIG_FILE, 'w') as file:
        json.dump(data, file, indent=4)

    update_entry_numbers()
    window.destroy()
