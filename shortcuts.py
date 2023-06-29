import customtkinter
import json
import os

import os
import json

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

    # Lese die Werte aus den Entry-Feldern aus
    ip_address = window.shortcut_ipadress_entry.get()
    subnet_mask = window.shortcut_subnetmask_entry.get()
    gateway = window.shortcut_Gateway_entry.get()
    dns = window.shortcut_DNS_entry.get()
    dns2 = window.shortcut_DNS2_entry.get()

    # Überprüfe die höchste vorhandene Nummer in der JSON-Datei
    max_number = 0
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as file:
            entries = json.load(file)
            max_number = max(map(int, entries.keys()))

    # Erstelle ein Dictionary mit den ausgelesenen Werten und der nächsten Nummer
    entry_number = str(max_number + 1)
    entry = {
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

