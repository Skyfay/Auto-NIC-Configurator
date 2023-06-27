import os
import datetime

support_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
support_file = os.path.join(support_dir, 'system.log')

def log_success(message):
    log_success('[SUCCESS]', message)

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


