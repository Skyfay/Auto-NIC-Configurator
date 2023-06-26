import customtkinter
import os
import json

# Write color settings to the json file.
def save_color_mode_support(window, color_mode):
    settings_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    os.makedirs(settings_dir, exist_ok=True)
    settings_file = os.path.join(settings_dir, 'system.json')

    # Speichern der Farbeinstellungen
    settings_data = {'color_mode': color_mode}
    with open(settings_file, 'w') as file:
        json.dump(settings_data, file)