import wmi

def get_network_adapters():
    c = wmi.WMI()
    adapters = c.Win32_NetworkAdapterConfiguration(IPEnabled=True)
    for idx, adapter in enumerate(adapters):
        print(f"Index: {idx}, Name: {adapter.Description}")

#get_network_adapters()


#List NICs by Index and Description
def test2():
    c = wmi.WMI()
    for nic in c.Win32_NetworkAdapterConfiguration(IPEnabled=True):
        print(nic.Index, nic.Description)

nic_configs = wmi.WMI().Win32_NetworkAdapterConfiguration(IPEnabled=True)
nic = nic_configs[0]
print(nic)