import customtkinter
import requests
import json
# test check for updates:
# GitHub Repository-Informationen
repo_owner = "Skyfay"
repo_name = "Auto-NIC-Configurator"

# Aktuelle Version des Programms
current_version = "6.0"


def check_for_updates(window):
    # GitHub API-Endpunkt für Releases
    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/releases/latest"

    try:
        # API-Anfrage an GitHub senden
        response = requests.get(url)
        response.raise_for_status()

        # JSON-Daten aus der API-Antwort extrahieren
        release_info = json.loads(response.text)
        latest_version = release_info["tag_name"]

        # Überprüfen, ob die neueste Version größer als die aktuelle Version ist
        if latest_version > current_version:
            # Es gibt eine neuere Version verfügbar
            window.update_button = customtkinter.CTkButton(window.navigation_frame, hover_color=("gray70", "gray30"),
                                                           corner_radius=5, width=200, height=50,
                                                           border_spacing=10, text=("A new version " + latest_version + " is available"),
                                                           command=download_and_install)
            window.update_button.grid(row=6, column=0, padx=20, pady=20, sticky="s")
        else:
            # Die aktuelle Version ist aktuell
            window.update_check_menu = customtkinter.CTkTextbox(window.navigation_frame, width=200, height=25, wrap="word", fg_color=("#f9f9fa", "#242424"), text_color=("#f9f9fa", "#c7c7c7"))
            window.update_check_menu.grid(row=6, column=0, padx=20, pady=20, sticky="s")
            window.update_check_menu.insert("1.0", "You use the latest version " + current_version)
            window.update_check_menu.configure(state="disabled")
    except requests.exceptions.RequestException as e:
        # Bei Fehlern bei der Anfrage an die GitHub API
        window.update_check_menu = customtkinter.CTkTextbox(window.navigation_frame, width=200, height=50, wrap="word") #fg_color=("#f9f9fa", "#343638"), border_width=2, border_color=("#979da2", "#565b5e")
        window.update_check_menu.grid(row=4, column=0, padx=20, pady=20, sticky="s")
        window.update_check_menu.insert("1.0", "Error connecting to the GitHub API:\n" + str(e))
        window.update_check_menu.configure(state="disabled")


def download_and_install():
    # Funktion zum Herunterladen und Installieren der neuen Version
    # Hier kannst du deinen eigenen Code einfügen, um die Installation durchzuführen
    pass