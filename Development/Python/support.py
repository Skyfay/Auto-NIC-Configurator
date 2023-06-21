import urllib.request
import socket
import requests
import customtkinter
import re
import os
import json
import datetime
from datetime import datetime

# Main Data safe file for some actions in the code, the path as "CONFIG_DIR" and the file as "CONFIG_File".
CONFIG_DIR = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
CONFIG_FILE = os.path.join(CONFIG_DIR, 'system.json')
WAIT_TIME_SECONDS = 60 # the time to wait before sending a new support message
timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S") # the timestamp for the log

# load the config file to get content from it
def load_config():
    os.makedirs(CONFIG_DIR, exist_ok=True)
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as file:
            config_data = json.load(file)
    else:
        config_data = {}
    return config_data

# save the config file to save content in it
def save_config(config_data):
    with open(CONFIG_FILE, 'w') as file:
        json.dump(config_data, file)

# Check the internet connection with a timeout of 1 second
def check_internet_connection():
    try:
        # Try to connect to google.com
        urllib.request.urlopen('https://www.google.com', timeout=1)
        return True
    except (urllib.error.URLError, socket.timeout):
        return False
# Console output if there is an internet connection or not (use to debug)
if check_internet_connection():
    print(f"Log: [{timestamp}] - There is an Internet connection.")
else:
    print(f"Log: [{timestamp}] - There is no internet connection.")

# Check if the user has entered a valid email address (support entry
def is_valid_email(email):
    email_pattern = r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$"
    return re.match(email_pattern, email)

# Send the support message to the discord webhook
def send_discord_webhook(webhook_url, name, email, subject, message):
    timestamp = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.%fZ")
    embed = {
        "title": f"Neue Nachricht von {name}",
        "color": 0x1f6aa5,
        "fields": [
            {"name": "Name", "value": name},
            {"name": "E-Mail", "value": email},
            {"name": "Betreff", "value": subject},
            {"name": "Nachricht", "value": message}
        ],
        "timestamp": timestamp  # Füge den Timestamp hinzu
    }
    data = {
        "embeds": [embed]
    }
    response = requests.post(webhook_url, json=data)
    if response.status_code == 204:
        print(f"Log: [{timestamp}] - Webhook message sent successfully.")
    else:
        print(f"Log: [{timestamp}] - Error sending the webhook message.")

# Code that runs when the user clicks the "Send" button
def send_message_to_webhook(window):
    # Check if the user has an internet connection if not then display an error message (check 1/4)
    if not check_internet_connection():
        error_label = customtkinter.CTkLabel(window.settings_frame, text="No internet connection.", text_color="#ff4155")
        error_label.grid(row=6, column=0, padx=20, pady=5)

        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        return

    # The discord webhook url the message will be sent to
    webhook_url = "https://discord.com/api/webhooks/1120714355261067346/HtIrVWGpdeAwMu9OQ002kWw7QlKO3Zr-tGzDvD0aeFuYpTXwXnw6zHYAQEGKJ4PEaGo5"

    # Get the user input from the entry fields
    name = window.name_entry.get()
    email = window.email_entry.get()
    subject = window.subject_entry.get()
    message = window.message_textbox.get("1.0", "end-1c")

    # Check if the user has filled in all fields if not then display an error message (check 2/4)
    if not name or not email or not subject or not message:
        error_label = customtkinter.CTkLabel(window.settings_frame, text="Please fill in all fields.", text_color="#ff4155")
        error_label.grid(row=6, column=0, padx=20, pady=5)

        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        return

    # Check if the user has entered a valid email address if not then display an error message (check 3/4)
    if not is_valid_email(email):
        error_label = customtkinter.CTkLabel(window.settings_frame, text="Bitte gib eine richtige E-Mail Adresse an.", text_color="#ff4155")
        error_label.grid(row=6, column=0, padx=20, pady=5)
        window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
        return

    # Load the config file to get the last timestamp the user sent a message
    config_data = load_config()
    last_timestamp = config_data.get("support", {}).get("timestamp")
    # Check if the user has already sent a message in the last 60 seconds if so then display an error message (check 4/4)
    if last_timestamp:
        current_timestamp = datetime.utcnow().timestamp()
        time_diff = current_timestamp - last_timestamp
        if time_diff < WAIT_TIME_SECONDS:
            wait_time = WAIT_TIME_SECONDS - time_diff
            error_label = customtkinter.CTkLabel(window.settings_frame,
                                                 text=f"Please wait {int(wait_time)} seconds before sending another message.",
                                                 text_color="#ff4155")
            error_label.grid(row=6, column=0, padx=20, pady=5)

            window.after(3000, error_label.destroy)  # Remove the error message after 3 seconds
            return

    # Send the message to the discord webhook
    send_discord_webhook(webhook_url, name, email, subject, message)

    # Save the current timestamp to the config file
    config_data.setdefault("support", {})["timestamp"] = datetime.utcnow().timestamp()
    save_config(config_data)

    # Success message (displayed if the message was sent successfully)
    success_label = customtkinter.CTkLabel(window.settings_frame, text="Support message sent successfully.", text_color="#44ff41",
                                           font=("TkDefaultFont", 12, "bold"))
    success_label.grid(row=6, column=0, padx=20, pady=5)
    window.after(3000, success_label.destroy) # Remove the success message after 3 seconds

    # Clear the entry fields
    window.name_entry.delete(0, "end")
    window.email_entry.delete(0, "end")
    window.subject_entry.delete(0, "end")
    window.message_textbox.delete("1.0", "end")