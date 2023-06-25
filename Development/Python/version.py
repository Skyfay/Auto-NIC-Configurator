import customtkinter
import requests
import json
import shutil
import os
import urllib.request
import subprocess
from pathlib import Path
import time
# test check for updates:
# GitHub Repository-Informationen
repo_owner = "Skyfay"
repo_name = "Auto-NIC-Configurator"

# Aktuelle Version des Programms
current_version = "0.7.0"


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
            window.update_button = customtkinter.CTkButton(window.navigation_frame, hover_color="#8f3840",
                                                           corner_radius=5, width=200, height=50, fg_color="#a13f48",
                                                           border_spacing=10, text=("A new version " + latest_version + " is available"),
                                                           command=lambda: download_and_install(window))
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


def show_download_button(window):
    # GitHub API-Endpunkt für Releases
    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/releases/latest"
    response = requests.get(url)
    response.raise_for_status()
    release_info = json.loads(response.text)
    latest_version = release_info["tag_name"]

    window.update_error_label.destroy()
    window.update_button = customtkinter.CTkButton(window.navigation_frame, hover_color="#8f3840",
                                                   corner_radius=5, width=200, height=50, fg_color="#a13f48",
                                                   border_spacing=10, text=("A new version " + latest_version + " is available"),
                                                   command=lambda: download_and_install(window))
    window.update_button.grid(row=6, column=0, padx=20, pady=20, sticky="s")


def download_and_install(window):
    window.update_button.destroy()
    window.update_progress = customtkinter.CTkProgressBar(window.navigation_frame, width=200, height=25,
                                                          fg_color="#57965c", progress_color="#83e28a")
    window.update_progress.grid(row=6, column=0, padx=20, pady=20, sticky="s")

    # GitHub Repository-Informationen
    repo_owner = "Skyfay"
    repo_name = "Auto-NIC-Configurator"

    # GitHub API-Endpunkt für Releases
    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/releases/latest"

    try:
        # API-Anfrage an GitHub senden
        response = requests.get(url)
        response.raise_for_status()

        # JSON-Daten aus der API-Antwort extrahieren
        release_info = json.loads(response.text)
        assets = release_info["assets"]

        if len(assets) == 0:
            # Es sind keine Assets (Dateien) für die neueste Version verfügbar
            print("No assets found for the latest version.")
            return

            # Fehlermeldung anzeigen
            window.update_progress.destroy()
            window.update_error_label = customtkinter.CTkLabel(window.navigation_frame,
                                                               text="Error occurred during the process.",
                                                               fg_color="#a13f48")
            window.update_error_label.grid(row=6, column=0, padx=20, pady=20, sticky="s")
            # Nach 3 Sekunden Fehlermeldung entfernen und Download-Button anzeigen
            window.after(3000, lambda: show_download_button(window))

        # Die URL der ersten ausführbaren Datei (Annahme: .exe-Datei)
        download_url = None
        for asset in assets:
            if asset["name"].endswith(".exe"):
                download_url = asset["browser_download_url"]
                break

        if not download_url:
            # Es wurde keine ausführbare Datei (.exe) gefunden
            print("No executable file found for the latest version.")
            return

        # Ermitteln des Versionsnamens
        latest_version = release_info["tag_name"]
        # Herunterladen der ausführbaren Datei in den Download-Ordner des Benutzers
        download_path = Path.home() / "Downloads" / f"auto-nic-configurator_{latest_version}.exe"
        print("Downloading the latest version...")
        urllib.request.urlretrieve(download_url, download_path)

        # Ersetzen der aktuellen ausführbaren Datei mit der heruntergeladenen Datei
        if os.path.exists(download_path):
            print("Download completed successfully!")

            # Ausführen der heruntergeladenen Datei
            subprocess.Popen([download_path], shell=True)

            # Beenden des Programms
            window.destroy()

        else:
            print("Current executable file not found.")

            # Fehlermeldung anzeigen
            window.update_progress.destroy()
            window.update_error_label = customtkinter.CTkLabel(window.navigation_frame,
                                                               text="Error occurred during the process.",
                                                               fg_color="#a13f48")
            window.update_error_label.grid(row=6, column=0, padx=20, pady=20, sticky="s")
            # Nach 3 Sekunden Fehlermeldung entfernen und Download-Button anzeigen
            window.after(3000, lambda: show_download_button(window))

    except requests.exceptions.RequestException as e:
        # Bei Fehlern bei der Anfrage an die GitHub API
        print("Error connecting to the GitHub API:", e)
        # Fehlermeldung anzeigen
        window.update_progress.destroy()
        window.update_error_label = customtkinter.CTkLabel(window.navigation_frame,
                                                           text="Error occurred during the process.",
                                                           fg_color="#a13f48")
        window.update_error_label.grid(row=6, column=0, padx=20, pady=20, sticky="s")
        # Nach 3 Sekunden Fehlermeldung entfernen und Download-Button anzeigen
        window.after(3000, lambda: show_download_button(window))
