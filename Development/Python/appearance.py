import customtkinter
import os
import json

# Write color settings to the json file.
def save_color_mode_settings(window, color_mode):
    settings_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    os.makedirs(settings_dir, exist_ok=True)
    settings_file = os.path.join(settings_dir, 'system.json')

    # Speichern der Farbeinstellungen
    settings_data = {'color_mode': color_mode}
    with open(settings_file, 'w') as file:
        json.dump(settings_data, file)


def change_appearance_mode_event_textbox_support(window, new_appearance_mode):
    customtkinter.set_appearance_mode(new_appearance_mode)

    # Prüfe den aktuellen Erscheinungsmodus
    if new_appearance_mode == "Light":
        fg_color = "#f9f9fa"  # Farbe im Whitemode
        border_color = "#979da2"  # Farbe im Whitemode
    else:  # Darkmode
        fg_color = "#343638"  # Farbe im Darkmode
        border_color = "#565b5e"  # Farbe im Darkmode

    # Setze die Farben für das Textfeld
    window.message_textbox.configure(fg_color=fg_color, border_color=border_color)