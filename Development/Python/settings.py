import os
import shutil
from network_collector import get_network_adapters_info


def delete_database_dir():
    database_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    shutil.rmtree(database_dir)
    get_network_adapters_info()
