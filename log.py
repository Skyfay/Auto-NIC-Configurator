import os
import datetime
import customtkinter

support_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
support_file = os.path.join(support_dir, 'system.log')

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

    for row_num, log in enumerate(logs):
        log_label = customtkinter.CTkLabel(window.log_frame, text=log)
        log_label.grid(row=row_num, column=0, padx=2, pady=2, sticky='we')



