# in network_viewer.py:
def network_adapter_select_event(window, selected_adapter):
    # Set the path where the json file is located
    json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator', 'network_adapters.json')

    with open(json_file_path) as file:
        adapters = json.load(file)

    selected_adapter_info = None
    for adapter in adapters:
        if adapter['name'] == selected_adapter:
            selected_adapter_info = adapter
            break

    textbox_ip = getattr(window, "network_information_frame_ipadress_textbox")
    textbox_subnet = getattr(window, "network_information_frame_subnetmask_textbox")
    textbox_gateway = getattr(window, "network_information_frame_gateway_textbox")
    textbox_dns = getattr(window, "network_information_frame_dns_textbox")
    textbox_mac = getattr(window, "network_information_frame_mac_textbox")

    textbox_ip.configure(state="normal")
    textbox_ip.delete("1.0", "end")
    textbox_ip.insert("1.0", selected_adapter_info['ip'] if selected_adapter_info else "")
    textbox_ip.configure(state="disabled")

    textbox_subnet.configure(state="normal")
    textbox_subnet.delete("1.0", "end")
    textbox_subnet.insert("1.0", selected_adapter_info['subnet_mask'] if selected_adapter_info else "")
    textbox_subnet.configure(state="disabled")

    textbox_gateway.configure(state="normal")
    textbox_gateway.delete("1.0", "end")
    textbox_gateway.insert("1.0", selected_adapter_info['gateway'] if selected_adapter_info else "")
    textbox_gateway.configure(state="disabled")

    textbox_dns.configure(state="normal")
    textbox_dns.delete("1.0", "end")
    textbox_dns.insert("1.0", ', '.join(selected_adapter_info['dns_servers']) if selected_adapter_info else "")
    textbox_dns.configure(state="disabled")

    textbox_mac.configure(state="normal")
    textbox_mac.delete("1.0", "end")
    textbox_mac.insert("1.0", selected_adapter_info['mac'] if selected_adapter_info else "")
    textbox_mac.configure(state="disabled")


# in main.py:
window.network_information_frame_ipadress_textbox_description = customtkinter.CTkTextbox(
    window.network_information_frame, width=200, height=10, wrap="word", fg_color=("#f9f9fa", "#343638"),
    border_width=2, border_color=("#979da2", "#565b5e"), state="disabled")
window.network_information_frame_ipadress_textbox_description.grid(row=2, column=0, padx=20, pady=5)
window.network_information_frame_ipadress_textbox_description.configure(state="normal")
window.network_information_frame_ipadress_textbox_description.insert("1.0", "IP Address")
window.network_information_frame_ipadress_textbox_description.configure(state="disabled")

window.network_information_frame_ipadress_textbox = customtkinter.CTkTextbox(window.network_information_frame,
                                                                             width=200, height=10, wrap="word",
                                                                             fg_color=("#f9f9fa", "#343638"),
                                                                             border_width=2,
                                                                             border_color=("#979da2", "#565b5e"),
                                                                             state="disabled")
window.network_information_frame_ipadress_textbox.grid(row=2, column=1, padx=20, pady=5)
window.network_information_frame_ipadress_textbox.configure(state="normal")
window.network_information_frame_ipadress_textbox.configure(state="disabled")

window.network_information_frame_subnetmask_textbox_description = customtkinter.CTkTextbox(
    window.network_information_frame, width=200, height=10, wrap="word", fg_color=("#f9f9fa", "#343638"),
    border_width=2, border_color=("#979da2", "#565b5e"), state="disabled")
window.network_information_frame_subnetmask_textbox_description.grid(row=3, column=0, padx=20, pady=5)
window.network_information_frame_subnetmask_textbox_description.configure(state="normal")
window.network_information_frame_subnetmask_textbox_description.insert("1.0", "Subnet Mask")
window.network_information_frame_subnetmask_textbox_description.configure(state="disabled")

window.network_information_frame_subnetmask_textbox = customtkinter.CTkTextbox(window.network_information_frame,
                                                                               width=200, height=10, wrap="word",
                                                                               fg_color=("#f9f9fa", "#343638"),
                                                                               border_width=2,
                                                                               border_color=("#979da2", "#565b5e"),
                                                                               state="disabled")
window.network_information_frame_subnetmask_textbox.grid(row=3, column=1, padx=20, pady=5)
window.network_information_frame_subnetmask_textbox.configure(state="normal")
window.network_information_frame_subnetmask_textbox.configure(state="disabled")

window.network_information_frame_gateway_textbox_description = customtkinter.CTkTextbox(
    window.network_information_frame, width=200, height=10, wrap="word", fg_color=("#f9f9fa", "#343638"),
    border_width=2, border_color=("#979da2", "#565b5e"), state="disabled")
window.network_information_frame_gateway_textbox_description.grid(row=4, column=0, padx=20, pady=5)
window.network_information_frame_gateway_textbox_description.configure(state="normal")
window.network_information_frame_gateway_textbox_description.insert("1.0", "Default Gateway")
window.network_information_frame_gateway_textbox_description.configure(state="disabled")

window.network_information_frame_gateway_textbox = customtkinter.CTkTextbox(window.network_information_frame, width=200,
                                                                            height=10, wrap="word",
                                                                            fg_color=("#f9f9fa", "#343638"),
                                                                            border_width=2,
                                                                            border_color=("#979da2", "#565b5e"),
                                                                            state="disabled")
window.network_information_frame_gateway_textbox.grid(row=4, column=1, padx=20, pady=5)
window.network_information_frame_gateway_textbox.configure(state="normal")
window.network_information_frame_gateway_textbox.configure(state="disabled")

window.network_information_frame_dns_textbox_description = customtkinter.CTkTextbox(window.network_information_frame,
                                                                                    width=200, height=10, wrap="word",
                                                                                    fg_color=("#f9f9fa", "#343638"),
                                                                                    border_width=2,
                                                                                    border_color=("#979da2", "#565b5e"),
                                                                                    state="disabled")
window.network_information_frame_dns_textbox_description.grid(row=5, column=0, padx=20, pady=5)
window.network_information_frame_dns_textbox_description.configure(state="normal")
window.network_information_frame_dns_textbox_description.insert("1.0", "DNS Server")
window.network_information_frame_dns_textbox_description.configure(state="disabled")

window.network_information_frame_dns_textbox = customtkinter.CTkTextbox(window.network_information_frame, width=200,
                                                                        height=10, wrap="word",
                                                                        fg_color=("#f9f9fa", "#343638"), border_width=2,
                                                                        border_color=("#979da2", "#565b5e"),
                                                                        state="disabled")
window.network_information_frame_dns_textbox.grid(row=5, column=1, padx=20, pady=5)
window.network_information_frame_dns_textbox.configure(state="normal")
window.network_information_frame_dns_textbox.configure(state="disabled")

window.network_information_frame_mac_textbox_description = customtkinter.CTkTextbox(window.network_information_frame,
                                                                                    width=200, height=10, wrap="word",
                                                                                    fg_color=("#f9f9fa", "#343638"),
                                                                                    border_width=2,
                                                                                    border_color=("#979da2", "#565b5e"),
                                                                                    state="disabled")
window.network_information_frame_mac_textbox_description.grid(row=6, column=0, padx=20, pady=5)
window.network_information_frame_mac_textbox_description.configure(state="normal")
window.network_information_frame_mac_textbox_description.insert("1.0", "MAC Address")
window.network_information_frame_mac_textbox_description.configure(state="disabled")

window.network_information_frame_mac_textbox = customtkinter.CTkTextbox(window.network_information_frame, width=200,
                                                                        height=10, wrap="word",
                                                                        fg_color=("#f9f9fa", "#343638"), border_width=2,
                                                                        border_color=("#979da2", "#565b5e"),
                                                                        state="disabled")
window.network_information_frame_mac_textbox.grid(row=6, column=1, padx=20, pady=5)
window.network_information_frame_mac_textbox.configure(state="normal")
window.network_information_frame_mac_textbox.configure(state="disabled")