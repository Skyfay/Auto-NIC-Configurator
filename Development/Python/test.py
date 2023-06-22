import wmi

def get_network_adapters():
    c = wmi.WMI()
    adapters = c.Win32_NetworkAdapterConfiguration(IPEnabled=True)
    for idx, adapter in enumerate(adapters):
        print(f"Index: {idx}, Name: {adapter.Description}")

get_network_adapters()
