import urllib.request
import socket
import requests
import customtkinter

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
    content = f"**Name:** {name}\n**E-Mail:** {email}\n**Betreff:** {subject}\n**Nachricht:**\n{message}"
    data = {
        "content": content
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
    send_discord_webhook(webhook_url, name, email, subject, message)