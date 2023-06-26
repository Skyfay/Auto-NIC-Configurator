import json
import os
import wmi

# Get the network adapters information and save it to a json file
def get_network_adapters_info():
    wmi_interface = wmi.WMI()
    adapters = []

    for index, nic in enumerate(wmi_interface.Win32_NetworkAdapterConfiguration(IPEnabled=True)): # Only get the enabled adapters
        adapter_info = {}
        adapter_info['AdapterIndex'] = index # This is the index of the adapter in the list of adapters
        adapter_info['name'] = nic.Description # The name of the adapter
        adapter_info['ip'] = nic.IPAddress[0] if nic.IPAddress else '-' # The IP address of the adapter
        adapter_info['subnet_mask'] = nic.IPSubnet[0] if nic.IPSubnet else '-' # The subnet mask of the adapter
        adapter_info['gateway'] = nic.DefaultIPGateway[0] if nic.DefaultIPGateway else '-' # The gateway of the adapter
        adapter_info['dns_servers'] = nic.DNSServerSearchOrder if nic.DNSServerSearchOrder else '-' # The DNS servers of the adapter
        adapter_info['mac'] = nic.MACAddress if nic.DNSServerSearchOrder else '-' # The MAC address of the adapter

        adapters.append(adapter_info) # Add the adapter info to the list of adapters

    # Set the path from the output file
    output_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
    os.makedirs(output_dir, exist_ok=True)

    output_file = os.path.join(output_dir, 'network_adapters.json')
    with open(output_file, 'w') as file:
        json.dump(adapters, file, indent=4)

# Run the function
get_network_adapters_info()
