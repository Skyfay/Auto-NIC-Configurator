import json
import os
import wmi


def get_network_adapters_info():
    wmi_interface = wmi.WMI()
    adapters = []

    for index, nic in enumerate(wmi_interface.Win32_NetworkAdapterConfiguration(IPEnabled=True)):
        adapter_info = {}
        adapter_info['AdapterIndex'] = index
        adapter_info['name'] = nic.Description
        adapter_info['ip'] = nic.IPAddress[0] if nic.IPAddress else '-'
        adapter_info['subnet_mask'] = nic.IPSubnet[0] if nic.IPSubnet else '-'
        adapter_info['gateway'] = nic.DefaultIPGateway[0] if nic.DefaultIPGateway else '-'
        adapter_info['dns_servers'] = nic.DNSServerSearchOrder if nic.DNSServerSearchOrder else '-'
        adapter_info['mac'] = nic.MACAddress if nic.DNSServerSearchOrder else '-'

        adapters.append(adapter_info)

    output_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    os.makedirs(output_dir, exist_ok=True)

    output_file = os.path.join(output_dir, 'network_adapters.json')
    with open(output_file, 'w') as file:
        json.dump(adapters, file, indent=4)


get_network_adapters_info()
