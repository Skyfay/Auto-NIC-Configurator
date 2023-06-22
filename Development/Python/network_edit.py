import wmi

# This part need administrator privileges
# https://learn.microsoft.com/de-de/windows/win32/cimwin32prov/win32-networkadapterconfiguration?redirectedfrom=MSDN

# Obtain network adaptors configurations
nic_configs = wmi.WMI().Win32_NetworkAdapterConfiguration(IPEnabled=True)

# First network adaptor
nic = nic_configs[0]

# IP address, subnetmask and gateway values should be unicode objects
ip = u'192.168.0.11'
subnetmask = u'255.255.255.0'
gateway = u'192.168.0.1'

# DNS server addresses should be unicode objects
dns_servers = [u'8.8.8.8', u'8.8.4.4']  # Example DNS server addresses

# Set IP address, subnetmask and default gateway
# Note: EnableStatic() and SetGateways() methods require *lists* of values to be passed
# Set DNS server addresses
nic.EnableStatic(IPAddress=[ip],SubnetMask=[subnetmask])
nic.SetGateways(DefaultIPGateway=[gateway])
nic.SetDNSServerSearchOrder(DNSServerSearchOrder=dns_servers)

# Enable DHCP
nic.EnableDHCP()
# Reset DNS server to obtain automatically (DHCP)
nic.SetDNSServerSearchOrder(DNSServerSearchOrder=[])