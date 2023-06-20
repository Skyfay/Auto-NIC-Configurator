import urllib.request
import socket
import requests
import customtkinter
import time

# Internet Test
def check_internet_connection():
    try:
        # Versuche, eine Verbindung zu einem bekannten Server herzustellen
        urllib.request.urlopen('https://www.google.com', timeout=1)
        return True
    except (urllib.error.URLError, socket.timeout):
        return False

if check_internet_connection():
    print("Es besteht eine Internetverbindung.")
else:
    print("Es besteht keine Internetverbindung.")

# Support

def send_discord_webhook(webhook_url, name, email, subject, message):
    embed = {
        "title": f"Neue Nachricht von {name}",
        "fields": [
            {"name": "Name", "value": name},
            {"name": "E-Mail", "value": email},
            {"name": "Betreff", "value": subject},
            {"name": "Nachricht", "value": message}
        ]
    }
    data = {
        "embeds": [embed]
    }
    response = requests.post(webhook_url, json=data)
    if response.status_code == 204:
        print("Webhook-Nachricht erfolgreich gesendet.")
    else:
        print("Fehler beim Senden der Webhook-Nachricht.")


def send_message_to_webhook(window):
    webhook_url = "https://discord.com/api/webhooks/1120714355261067346/HtIrVWGpdeAwMu9OQ002kWw7QlKO3Zr-tGzDvD0aeFuYpTXwXnw6zHYAQEGKJ4PEaGo5"

    name = window.name_entry.get()
    email = window.email_entry.get()
    subject = window.subject_entry.get()
    message = window.message_textbox.get("1.0", "end-1c")

    # Überprüfe, ob alle Felder ausgefüllt sind
    if not name or not email or not subject or not message:
        error_label = customtkinter.CTkLabel(window.settings_frame, text="Bitte füllen Sie alle Felder aus.", fg="red")
        error_label.grid(row=6, column=0, padx=20, pady=5)
        window.after(3000, error_label.destroy)  # Entferne die Fehlermeldung nach 3 Sekunden
        return

    send_discord_webhook(webhook_url, name, email, subject, message)

    # Success Label
    success_label = customtkinter.CTkLabel(window.settings_frame, text="Webhook-Nachricht erfolgreich gesendet.",
                                           font=("TkDefaultFont", 12, "bold"))
    success_label.grid(row=6, column=0, padx=20, pady=5)
    window.after(3000, success_label.destroy)  # Entferne die Erfolgsmeldung nach 3 Sekunden

    # Leere die Eingabefelder
    window.name_entry.delete(0, "end")
    window.email_entry.delete(0, "end")
    window.subject_entry.delete(0, "end")
    window.message_textbox.delete("1.0", "end")