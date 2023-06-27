import os
import datetime
import customtkinter

support_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
support_file = os.path.join(support_dir, 'system.log')

selected_log_level = "all"

def log_success(message):
    log_entry('[SUCCESS]', message)

def log_info(message):
    log_entry('[INFO]', message)

def log_warning(message):
    log_entry('[WARNING]', message)

def log_error(message):
    log_entry('[ERROR]', message)

def log_critical(message):
    log_entry('[CRITICAL]', message)

def log_entry(level, message):
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log_line = f'{level} - {timestamp} - {message}\n'
    try:
        with open(support_file, 'a') as log_file:
            log_file.write(log_line)
    except Exception as e:
        print(f'Failed to write to log file: {e}')


def display_log_in_frame(window):
    with open(support_file, 'r') as log_file:
        logs = log_file.readlines()

    filtered_logs = []

    if selected_log_level == "all":
        filtered_logs = logs
    else:
        for log in logs:
            if log.startswith(selected_log_level):
                filtered_logs.append(log)

    # Zuerst alle Log-Einträge entfernen
    for widget in window.log_frame.winfo_children():
        widget.grid_forget()

    # Überprüfen, ob Einträge vorhanden sind
    if len(filtered_logs) == 0:
        no_logs_label = customtkinter.CTkLabel(window.log_frame, text="There is no entry available.")
        no_logs_label.grid(row=0, column=0, padx=2, pady=2, sticky='we')
    else:
        # Neue Log-Einträge anzeigen
        for row_num, log in enumerate(filtered_logs):
            log_label = customtkinter.CTkLabel(window.log_frame, text=log)
            log_label.grid(row=row_num, column=0, padx=2, pady=2, sticky='we')

def update_log_display(window, log_level):
    global selected_log_level
    selected_log_level = log_level
    display_log_in_frame(window)


def delete_log_file(window):
    try:
        os.remove(support_file)
    except Exception as e:
        print(f'Failed to delete log file: {e}')

    # Beenden des Programms
    window.destroy()


def check_create_log_file():
    if not os.path.exists(support_file):
        try:
            os.makedirs(support_dir, exist_ok=True)
            with open(support_file, 'w') as log_file:
                log_file.write('')  # Leere Datei erstellen
        except Exception as e:
            print(f'Failed to create log file: {e}')

def count_log_entries():
    try:
        with open(support_file, 'r') as log_file:
            log_entries = log_file.readlines()
            return len(log_entries)
    except Exception as e:
        print(f'Failed to read log file: {e}')
        return 0

