import customtkinter
import os
import json
from PIL import Image
import requests

from network_collector import get_network_adapters_info
from network_viewer import network_adapter_select_event, initialize_adapter_select_placeholder, update_adapter_select_values
from network_edit import selected_adapter_set_custom_values
from support import send_message_to_webhook
from appearance import save_color_mode_support
from settings import delete_database_dir
from version import check_for_updates, download_and_install, show_download_button
from log import display_log_in_frame, update_log_display, delete_log_file, check_create_log_file, count_log_entries, log_info
from shortcuts import write_entries_to_json, create_buttons_from_entries, get_shortcut_names_from_json, delete_shortcut_by_name

# Aufruf der Funktion, um die Informationen der Netzwerk Adapter zu aktuallisieren abzurufen
get_network_adapters_info()
#test

# initalize the network adapter select placeholder
def initialize_adapter_select_placeholder(window):
    placeholder_text = "Select Adapter"
    window.network_adapter_select.set(placeholder_text)
    window.network_adapter_select.configure(state="readonly")

class ShortcutDeleteToplevelWindow(customtkinter.CTkToplevel):
    def __init__(window, *args, **kwargs):
        super().__init__(*args, **kwargs)
        window.attributes("-topmost", True) # set the window always on top

        # Gui
        window.title("Delete Shortcut") # Windows titel
        window.minsize(300, 250) # minimum size from the window length, height
        window.geometry("300x300") # startup size from the window
        #window.iconbitmap("assets/icon/ethernet.ico") # set the icon from the window
        #customtkinter.set_default_color_theme("blue") # set default color theme

        # set main grid layout 1x2
        window.grid_rowconfigure(4, weight=1)
        window.grid_columnconfigure(0, weight=1)

        window.shortcut_description_label = customtkinter.CTkLabel(window, text="Here you can delete your shortcuts")
        window.shortcut_description_label.grid(row=1, column=0, padx=20, pady=5)

        shortcut_names = get_shortcut_names_from_json()

        window.shortcut_name_menu = customtkinter.CTkOptionMenu(window, width=200, values=shortcut_names)
        window.shortcut_name_menu.grid(row=2, column=0, padx=20, pady=5)

        window.shortcut_delete_button = customtkinter.CTkButton(window, text="Delete Shortcut", command=lambda: delete_shortcut_by_name(window))
        window.shortcut_delete_button.grid(row=3, column=0, padx=20, pady=10)

class ShortcutAddToplevelWindow(customtkinter.CTkToplevel):
    def __init__(window, *args, **kwargs):
        super().__init__(*args, **kwargs)
        window.attributes("-topmost", True) # set the window always on top

        # Gui
        window.title("Add Shortcut") # Windows titel
        window.minsize(300, 350) # minimum size from the window length, height
        window.geometry("300x300") # startup size from the window
        #window.iconbitmap("assets/icon/ethernet.ico") # set the icon from the window
        #customtkinter.set_default_color_theme("blue") # set default color theme

        # set main grid layout 1x2
        window.grid_rowconfigure(0, weight=1)
        window.grid_columnconfigure(0, weight=1)

        window.shortcut_description_label = customtkinter.CTkLabel(window, text="Here you can add your network adapter\n info for your shortcut")
        window.shortcut_description_label.grid(row=0, column=0, padx=20, pady=5)

        window.shortcut_name_entry = customtkinter.CTkEntry(window, width=200, placeholder_text="Shortcut Name")
        window.shortcut_name_entry.grid(row=1, column=0, padx=20, pady=5)

        window.shortcut_ipadress_entry = customtkinter.CTkEntry(window, width=200, placeholder_text="IP Address (192.168.1.2)")
        window.shortcut_ipadress_entry.grid(row=2, column=0, padx=20, pady=5)

        window.shortcut_subnetmask_entry = customtkinter.CTkEntry(window, width=200, placeholder_text="Subnet Mask (255.255.255.0)")
        window.shortcut_subnetmask_entry.grid(row=3, column=0, padx=20, pady=5)

        window.shortcut_Gateway_entry = customtkinter.CTkEntry(window, width=200, placeholder_text="Gateway (192.168.1.1)")
        window.shortcut_Gateway_entry.grid(row=4, column=0, padx=20, pady=5)

        window.shortcut_DNS_entry = customtkinter.CTkEntry(window, width=200, placeholder_text="DNS (1.1.1.1)")
        window.shortcut_DNS_entry.grid(row=5, column=0, padx=20, pady=5)

        window.shortcut_DNS2_entry = customtkinter.CTkEntry(window, width=200, placeholder_text="DNS (8.8.8.8)")
        window.shortcut_DNS2_entry.grid(row=6, column=0, padx=20, pady=5)

        window.shortcut_entry_button = customtkinter.CTkButton(window, text="Add Shortcut", command=lambda: write_entries_to_json(window))
        window.shortcut_entry_button.grid(row=7, column=0, padx=20, pady=10)



class LogToplevelWindow(customtkinter.CTkToplevel):
    def __init__(window, *args, **kwargs):
        super().__init__(*args, **kwargs)
        window.attributes("-topmost", True) # set the window always on top

        check_create_log_file() # check if the log file exists and create it if not


        # Gui
        window.title("Logs") # Windows titel
        window.minsize(750, 475) # minimum size from the window
        window.geometry("750x475") # startup size from the window
        #window.iconbitmap("assets/icon/ethernet.ico") # set the icon from the window
        #customtkinter.set_default_color_theme("blue") # set default color theme

        # set main grid layout 1x2
        window.grid_rowconfigure(0, weight=1)
        window.grid_columnconfigure(1, weight=1)

        window.log_lvl_frame = customtkinter.CTkFrame(window, corner_radius=0)
        window.log_lvl_frame.grid(row=0, column=0, sticky="nsew")
        window.log_lvl_frame.grid_rowconfigure(6, weight=1)

        window.log_lvl_frame_button_all = customtkinter.CTkButton(window.log_lvl_frame, corner_radius=5, height=40,
                                                                  border_spacing=10, text="All logs",
                                                                  fg_color="#363636", text_color=("gray90"),
                                                                  hover_color=("gray70", "gray30"),
                                                                  anchor="center",
                                                                  command=lambda: update_log_display(window, "all"))
        window.log_lvl_frame_button_all.grid(row=1, column=0, padx=15, pady=5, sticky="ew")

        window.log_lvl_frame_button_info = customtkinter.CTkButton(window.log_lvl_frame, corner_radius=5, height=40,
                                                                   border_spacing=10, text="Information",
                                                                   fg_color="#88abc7", text_color=("gray10"),
                                                                   hover_color="#6f8ca3",
                                                                   anchor="center",
                                                                   command=lambda: update_log_display(window, "[INFO]"))
        window.log_lvl_frame_button_info.grid(row=2, column=0, padx=15, pady=5, sticky="ew")

        window.log_lvl_frame_button_success = customtkinter.CTkButton(window.log_lvl_frame, corner_radius=5, height=40,
                                                                      border_spacing=10, text="Success",
                                                                      fg_color="#b4c76e", text_color=("gray10"),
                                                                      hover_color="#94a35a",
                                                                      anchor="center",
                                                                      command=lambda: update_log_display(window,
                                                                                                         "[SUCCESS]"))
        window.log_lvl_frame_button_success.grid(row=3, column=0, padx=15, pady=5, sticky="ew")

        window.log_lvl_frame_button_warning = customtkinter.CTkButton(window.log_lvl_frame, corner_radius=5, height=40,
                                                                      border_spacing=10, text="Warning",
                                                                      fg_color="#e6c97b", text_color=("gray10"),
                                                                      hover_color="#bda564",
                                                                      anchor="center",
                                                                      command=lambda: update_log_display(window,
                                                                                                         "[WARNING]"))
        window.log_lvl_frame_button_warning.grid(row=4, column=0, padx=15, pady=5, sticky="ew")

        window.log_lvl_frame_button_error = customtkinter.CTkButton(window.log_lvl_frame, corner_radius=5, height=40,
                                                                    border_spacing=10, text="Error",
                                                                    fg_color="#d69488", text_color=("gray10"),
                                                                    hover_color="#ad776d",
                                                                    anchor="center",
                                                                    command=lambda: update_log_display(window,
                                                                                                       "[ERROR]"))
        window.log_lvl_frame_button_error.grid(row=5, column=0, padx=15, pady=5, sticky="ew")

        num_entries = count_log_entries()  # Anzahl der Log-Einträge abrufen
        window.log_lines_counter_label = customtkinter.CTkLabel(window.log_lvl_frame, corner_radius=5, height=25, text=f"Number of log entries is: {num_entries}", fg_color=("#f9f9fa", "#343638"))
        window.log_lines_counter_label.grid(row=6, column=0, padx=15, pady=5, sticky="ew")

        window.log_delete_log_button = customtkinter.CTkButton(window.log_lvl_frame, corner_radius=5, height=40, border_spacing=10, text="Delete Log File",
                                                      fg_color="#d63e3e", text_color=("gray10"), hover_color="#a63e3e",
                                                      anchor="center", command=lambda: delete_log_file(window))
        window.log_delete_log_button.grid(row=6, column=0, padx=15, pady=15, sticky="ews")

        window.log_frame = customtkinter.CTkScrollableFrame(window, corner_radius=5, fg_color="transparent")
        window.log_frame.grid_columnconfigure(0, weight=1)
        window.log_frame.grid_rowconfigure(0, weight=1)  # Höhe anpassen
        window.log_frame.grid(row=0, column=1, padx=10, pady=10, sticky="nsew")

        display_log_in_frame(window)






class App(customtkinter.CTk):
    #test

    def __init__(window):
        super().__init__()

        log_info("Starting AutoNicConfigurator")

        # Load the latest color mode from the json file
        def load_color_mode_support(window):
            support_dir = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator')
            support_file = os.path.join(support_dir, 'system.json')

            # Laden der Farbeinstellungen
            try:
                with open(support_file) as file:
                    support_data = json.load(file)
                    color_mode = support_data.get('color_mode', 'Dark')

                    # Überprüfen, ob der geladene Wert von color_mode gültig ist
                    if color_mode not in ['Light', 'Dark', 'System']:
                        color_mode = 'Dark'
            except FileNotFoundError:
                color_mode = 'Dark'

            if color_mode == 'Light':
                appearance_mode = 'light'
            elif color_mode == 'Dark':
                appearance_mode = 'dark'
            else:
                appearance_mode = 'system'

            return appearance_mode

        # Laden der Farbeinstellungen
        appearance_mode = load_color_mode_support(window)
        customtkinter.set_appearance_mode(appearance_mode)

        # Get Network Adapter for dropdown menu to select
        def get_network_adapter_names():
            # Load network adapters from JSON file
            with open(json_file_path) as file:
                adapters = json.load(file)

            # Extract adapter names
            adapter_names = [adapter['name'] for adapter in adapters]

            return adapter_names

        # Definiere den Pfad zur network_adapters.json-Datei
        json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator',
                                      'network_adapters.json')

        adapter_names = get_network_adapter_names()


        # test to add UI elements
        def create_settings_pre_frame(parent_frame, row, column):
            pre_frame = customtkinter.CTkFrame(parent_frame, corner_radius=10, bg_color=("#ebebeb", "#242424"))
            pre_frame.grid(row=row, column=column, padx=10, pady=10, sticky="w")

            # Text change the appearance mode
            appearance_label = customtkinter.CTkLabel(pre_frame, text="App Appearance",
                                                      font=customtkinter.CTkFont(size=12))
            appearance_label.grid(row=0, column=0, padx=10, pady=0)

            # Button to change the appearance mode
            appearance_mode_menu = customtkinter.CTkOptionMenu(pre_frame, values=["Light", "Dark", "System"],
                                                               command=window.change_appearance_mode_event,
                                                               button_color="#975730", fg_color="#d07138",
                                                               button_hover_color="#603d28")
            appearance_mode_menu.set(appearance_mode)  # Set the initial value to the loaded appearance_mode
            appearance_mode_menu.grid(row=0, column=1, padx=20, pady=10)

            return pre_frame

        # Gui
        window.title("Auto Nic Configurator") # Windows titel
        window.minsize(750, 475) # minimum size from the window
        window.geometry("750x475") # startup size from the window
        window.iconbitmap("assets/icon/ethernet.ico") # header icon
        customtkinter.set_default_color_theme("blue") # set default color theme

        # set main grid layout 1x2
        window.grid_rowconfigure(0, weight=1)
        window.grid_columnconfigure(1, weight=1)


        # load images with light and dark mode image
        image_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "assets/icon")
        window.logo_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "ethernet.png")), size=(26, 26))
        window.insupport_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "support.png")), size=(26, 26))
        window.color_palette_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "color-palette.png")), size=(26, 26))
        window.large_test_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "large_test_image.png")), size=(500, 150))
        window.image_icon_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "image_icon_light.png")), size=(20, 20))
        window.home_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "home_dark.png")),
                                                 dark_image=Image.open(os.path.join(image_path, "home_light.png")), size=(20, 20))
        window.network_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "network_dark.png")),
                                                 dark_image=Image.open(os.path.join(image_path, "network_light.png")), size=(20, 20))
        window.add_user_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "add_user_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "add_user_light.png")), size=(20, 20))
        window.support_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "support_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "support_light.png")), size=(20, 20))
        window.settings_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "settings_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "settings_light.png")), size=(20, 20))
        window.information_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "information_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "information_light.png")), size=(20, 20))
        window.custom_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "custom_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "custom_light.png")), size=(20, 20))
        window.shortcut_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "shortcut_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "shortcut_light.png")), size=(20, 20))
        window.add_box_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "add_box_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "add_box_light.png")), size=(20, 20))
        window.remove_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "remove_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "remove_light.png")), size=(20, 20))

        # create left navigation frame
        window.navigation_frame = customtkinter.CTkFrame(window, corner_radius=0)
        window.navigation_frame.grid(row=0, column=0, sticky="nsew")
        window.navigation_frame.grid_rowconfigure(5, weight=1)

        window.navigation_frame_label = customtkinter.CTkLabel(window.navigation_frame, text="  Auto Nic Configurator", image=window.logo_image,
                                                             compound="left", font=customtkinter.CTkFont(size=15, weight="bold"))
        window.navigation_frame_label.grid(row=0, column=0, padx=20, pady=20)

        window.home_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Home",
                                                   fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                   image=window.home_image, anchor="w", command=window.home_button_event)
        window.home_button.grid(row=1, column=0, sticky="ew")

        window.network_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Network",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=window.network_image, anchor="w", command=window.network_button_event)
        window.network_button.grid(row=2, column=0, sticky="ew")

        window.support_frame_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Support",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=window.support_image, anchor="w", command=window.support_frame_button_event)
        window.support_frame_button.grid(row=3, column=0, sticky="ew")

        window.settings_frame_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Settings",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=window.settings_image, anchor="w", command=window.settings_frame_button_event)
        window.settings_frame_button.grid(row=4, column=0, sticky="ew")

        check_for_updates(window)

        # create home frame

        window.home_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")
        window.home_frame.grid_columnconfigure(0, weight=1)

        window.home_frame_large_image_label = customtkinter.CTkLabel(window.home_frame, text="", image=window.large_test_image)
        window.home_frame_large_image_label.grid(row=0, column=0, padx=20, pady=10)

        window.home_frame_network_button = customtkinter.CTkButton(window.home_frame, corner_radius=5, height=125, width=210, border_spacing=10, text="Network",
                                                   fg_color=("#f9f9fa", "#343638"), text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                   image=window.network_image, command=window.network_button_event)
        window.home_frame_network_button.grid(row=1, column=0, padx=30, pady=10, sticky="w")

        window.home_frame_support_button = customtkinter.CTkButton(window.home_frame, corner_radius=5, height=125, width=210, border_spacing=10, text="Support",
                                                   fg_color=("#f9f9fa", "#343638"), text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                   image=window.support_image, command=window.support_frame_button_event)
        window.home_frame_support_button.grid(row=1, column=0, padx=30, pady=10, sticky="e")

        window.home_frame_settings_button = customtkinter.CTkButton(window.home_frame, corner_radius=5, height=80, width=210, border_spacing=10, text="Settings",
                                                   fg_color=("#f9f9fa", "#343638"), text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                   image=window.settings_image, command=window.settings_frame_button_event)
        window.home_frame_settings_button.grid(row=2, column=0, padx=30, pady=10, sticky="we")

        # create network navigation frame

        window.network_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")
        window.network_frame.grid(row=0, column=0, sticky="nsew")
        window.network_frame.grid_rowconfigure(1, weight=1) # 1, 1
        window.network_frame.grid_columnconfigure(1, weight=1)

        window.network_adapter_select = customtkinter.CTkOptionMenu(window.network_frame,  corner_radius=5, values=adapter_names, anchor="w", command=lambda adapter: network_adapter_select_event(window, adapter))
        window.network_adapter_select.grid(row=0, column=1, padx=20, pady=20)

        window.network_information_button = customtkinter.CTkButton(window.network_frame, hover_color=("gray70", "gray30"), corner_radius=5, height=40, width=10, border_spacing=10, text="", image=window.information_image, anchor="w", command=window.information_button_event)
        window.network_information_button.grid(row=2, column=0, padx=20, pady=10)
        window.network_custom_button = customtkinter.CTkButton(window.network_frame,hover_color=("gray70", "gray30"), corner_radius=5, height=40, width=10, border_spacing=10, text="", image=window.custom_image, anchor="w", command=window.custom_button_event)
        window.network_custom_button.grid(row=3, column=0, padx=20, pady=10)
        window.network_shortcut_button = customtkinter.CTkButton(window.network_frame,hover_color=("gray70", "gray30"), corner_radius=5, height=40, width=10, border_spacing=10, text="", image=window.shortcut_image, anchor="w", command=window.shortcut_frame_button_event)
        window.network_shortcut_button.grid(row=4, column=0, padx=20, pady=10)

        # create network page frames
        # information frame
        window.network_information_frame = customtkinter.CTkFrame(window.network_frame, corner_radius=0, fg_color="transparent")
        window.network_information_frame.grid_columnconfigure(0, weight=1)

        textbox_properties = {
            "width": 200,
            "height": 10,
            "wrap": "word",
            "fg_color": ("#f9f9fa", "#343638"),
            "border_width": 2,
            "border_color": ("#979da2", "#565b5e"),
            "state": "disabled"
        }

        textbox_names = [
            "network_information_frame_ipadress_textbox",
            "network_information_frame_subnetmask_textbox",
            "network_information_frame_gateway_textbox",
            "network_information_frame_dns_textbox",
            "network_information_frame_mac_textbox"
        ]

        discription_names = [
            "IP Address",
            "Subnet Mask",
            "Default Gateway",
            "DNS Server",
            "MAC Address"
        ]

        for i, textbox_name in enumerate(textbox_names):
            textbox_description = customtkinter.CTkTextbox(window.network_information_frame, **textbox_properties)
            textbox_description.grid(row=i + 1, column=0, padx=20, pady=5)
            setattr(window, textbox_name + "_description", textbox_description)

            textbox_information = customtkinter.CTkTextbox(window.network_information_frame, **textbox_properties)
            textbox_information.grid(row=i + 1, column=1, padx=20, pady=5)
            setattr(window, textbox_name, textbox_information)

            textbox_description.configure(state="normal")
            textbox_description.insert("1.0", discription_names[i])
            textbox_description.configure(state="disabled")

            textbox_information.configure(state="normal")
            textbox_information.configure(state="disabled")



        # custom frame
        window.network_custom_frame = customtkinter.CTkFrame(window.network_frame, corner_radius=0, fg_color="transparent")
        window.network_custom_frame.grid_columnconfigure(0, weight=1)

        # create input boxes
        window.network_custom_ipadress_entry = customtkinter.CTkEntry(window.network_custom_frame, width=200, placeholder_text="IP Address (192.168.1.2)")
        window.network_custom_ipadress_entry.grid(row=1, column=0, padx=20, pady=5)

        window.network_custom_subnetmask_entry = customtkinter.CTkEntry(window.network_custom_frame, width=200, placeholder_text="Subnet Mask (255.255.255.0)")
        window.network_custom_subnetmask_entry.grid(row=2, column=0, padx=20, pady=5)

        window.network_custom_Gateway_entry = customtkinter.CTkEntry(window.network_custom_frame, width=200, placeholder_text="Gateway (192.168.1.1)")
        window.network_custom_Gateway_entry.grid(row=3, column=0, padx=20, pady=5)

        window.network_custom_DNS_entry = customtkinter.CTkEntry(window.network_custom_frame, width=200, placeholder_text="DNS (1.1.1.1)")
        window.network_custom_DNS_entry.grid(row=4, column=0, padx=20, pady=5)

        window.network_custom_DNS2_entry = customtkinter.CTkEntry(window.network_custom_frame, width=200, placeholder_text="DNS (8.8.8.8)")
        window.network_custom_DNS2_entry.grid(row=5, column=0, padx=20, pady=5)
        # window.message_textbox.insert("1.0", text="Here you can write your message...", tags=None)

        window.network_custom_message_entry = customtkinter.CTkButton(window.network_custom_frame, text="Save", command=lambda: selected_adapter_set_custom_values(window, window.network_adapter_select.get()))
        window.network_custom_message_entry.grid(row=6, column=0, padx=20, pady=10)

        # shortcut frame
        window.network_shortcut_frame = customtkinter.CTkScrollableFrame(window.network_frame, corner_radius=0, fg_color="transparent")
        window.network_shortcut_frame.grid_columnconfigure(1, weight=1)
        window.network_shortcut_frame.grid_rowconfigure(0, weight=1)

        create_buttons_from_entries(window, window.network_adapter_select.get())


        # Aufruf der Funktion zum Initialisieren des Platzhalterss
        initialize_adapter_select_placeholder(window)

        window.adapter_info_label = customtkinter.CTkLabel(window.home_frame, text="", font=customtkinter.CTkFont(size=12))
        window.adapter_info_label.grid(row=2, column=0, padx=20, pady=10)

        # create second frame
        window.support_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")

        # create support frame
        window.support_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")
        window.support_frame.grid_columnconfigure(0, weight=1)  # Zentriert die Spalte

        # create support frame support label
        window.support_frame_support_label = customtkinter.CTkLabel(window.support_frame, text="Support",
                                                                     image=window.insupport_image,
                                                                     compound="left",
                                                                     font=customtkinter.CTkFont(size=15, weight="bold"),
                                                                     padx=10) # Abstand zwischen Bild und Text
        window.support_frame_support_label.grid(row=0, column=0, padx=20, pady=10)


        # create input boxes
        window.name_entry = customtkinter.CTkEntry(window.support_frame, width=200, placeholder_text="Your Name")
        window.name_entry.grid(row=1, column=0, padx=20, pady=5)

        window.email_entry = customtkinter.CTkEntry(window.support_frame, width=200, placeholder_text="Email Adress")
        window.email_entry.grid(row=2, column=0, padx=20, pady=5)

        window.subject_entry = customtkinter.CTkEntry(window.support_frame, width=200, placeholder_text="Subject")
        window.subject_entry.grid(row=3, column=0, padx=20, pady=5)

        window.message_textbox = customtkinter.CTkTextbox(window.support_frame, width=200, height=200, wrap="word", fg_color=("#f9f9fa", "#343638"), border_width=2, border_color=("#979da2", "#565b5e"))
        window.message_textbox.grid(row=4, column=0, padx=20, pady=5)
        # window.message_textbox.insert("1.0", text="Here you can write your message...", tags=None)

        window.message_entry = customtkinter.CTkButton(window.support_frame, text="Send", command=lambda: send_message_to_webhook(window))
        window.message_entry.grid(row=5, column=0, padx=20, pady=10)

        # create settings frame
        window.settings_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")
        window.settings_frame.grid_columnconfigure(0, weight=1) # 0, weight=1
        window.settings_pre_frame = customtkinter.CTkFrame(window.settings_frame, corner_radius=10, bg_color=("#ebebeb", "#242424"), fg_color=("#f9f9fa", "#343638"), border_width=2, border_color=("#979da2", "#565b5e"))
        window.settings_pre_frame.grid(row=0, column=0, padx=10, pady=5, sticky="news")
        window.settings_pre_frame.grid_columnconfigure(0, weight=1) # 0, weight=1
        window.settings_pre_frame1 = customtkinter.CTkFrame(window.settings_frame, corner_radius=10, bg_color=("#ebebeb", "#242424"), fg_color=("#f9f9fa", "#343638"), border_width=2, border_color=("#979da2", "#565b5e"))
        window.settings_pre_frame1.grid(row=1, column=0, padx=10, pady=5, sticky="news")
        window.settings_pre_frame1.grid_columnconfigure(0, weight=1)  # 0, weight=1
        window.settings_pre_frame2 = customtkinter.CTkFrame(window.settings_frame, corner_radius=10, bg_color=("#ebebeb", "#242424"), fg_color=("#f9f9fa", "#343638"), border_width=2, border_color=("#979da2", "#565b5e"))
        window.settings_pre_frame2.grid(row=2, column=0, padx=10, pady=5, sticky="news")
        window.settings_pre_frame2.grid_columnconfigure(0, weight=1)  # 0, weight=1
        # Text change the appearance mode
        window.settings_frame_appearance_label = customtkinter.CTkLabel(window.settings_pre_frame, text="Set the App Appearance",
                                                                    font=customtkinter.CTkFont(size=12))
        window.settings_frame_appearance_label.grid(row=0, column=0, padx=10, pady=5)
        # Button to change the appearance mode
        window.settings_frame_appearance_mode_menu = customtkinter.CTkOptionMenu(window.settings_pre_frame,
                                                                values=["Light", "Dark", "System"],
                                                                command=window.change_appearance_mode_event)
        window.settings_frame_appearance_mode_menu.set(appearance_mode)  # Set the initial value to the loaded appearance_mode
        window.settings_frame_appearance_mode_menu.grid(row=1, column=0, padx=20, pady=10)

        # Clear the cache
        window.settings_frame_clear_cache_label = customtkinter.CTkLabel(window.settings_pre_frame1, text="In case of problems it may help to clear the cache",
                                                                    font=customtkinter.CTkFont(size=12))
        window.settings_frame_clear_cache_label.grid(row=0, column=0, padx=10, pady=5)
        # Button Clear the cache
        window.settings_frame_clear_cache = customtkinter.CTkButton(window.settings_pre_frame1,
                                                                text="Clear Cache",
                                                                command=delete_database_dir)
        window.settings_frame_clear_cache.grid(row=1, column=0, padx=20, pady=10)

        # Open log window
        window.settings_frame_open_logs_label = customtkinter.CTkLabel(window.settings_pre_frame2, text="Here you can open the logs if you have problems",
                                                                    font=customtkinter.CTkFont(size=12))
        window.settings_frame_open_logs_label.grid(row=0, column=0, padx=10, pady=5)
        # Button to Open log window
        window.settings_frame_open_logs = customtkinter.CTkButton(window.settings_pre_frame2,
                                                                text="Open Logs",
                                                                command=window.open_log_window)
        window.settings_frame_open_logs.grid(row=1, column=0, padx=20, pady=10)

        window.toplevel_window = None

        # select default frame
        window.select_frame_by_name("home")

        # select default frame
        window.select_network_by_name("network_information_frame")

    def open_log_window(window):
        if window.toplevel_window is None or not window.toplevel_window.winfo_exists():
            window.toplevel_window = LogToplevelWindow(window)  # create window if its None or destroyed
        else:
            window.toplevel_window.focus()  # if window exists focus it

    def open_shortcut_add_window(window):
        if window.toplevel_window is None or not window.toplevel_window.winfo_exists():
            window.toplevel_window = ShortcutAddToplevelWindow(window)  # create window if its None or destroyed
        else:
            window.toplevel_window.focus()  # if window exists focus it

    def open_shortcut_delete_window(window):
        if window.toplevel_window is None or not window.toplevel_window.winfo_exists():
            window.toplevel_window = ShortcutDeleteToplevelWindow(window)  # create window if its None or destroyed
        else:
            window.toplevel_window.focus()  # if window exists focus it

    # Select Frame "main frames" from navigation frame
    def select_frame_by_name(window, name):
        # set button color for selected button
        window.home_button.configure(fg_color=("gray75", "gray25") if name == "home" else "transparent")
        window.network_button.configure(fg_color=("gray75", "gray25") if name == "network_frame" else "transparent")
        window.support_frame_button.configure(fg_color=("gray75", "gray25") if name == "support_frame" else "transparent")
        window.settings_frame_button.configure(
            fg_color=("gray75", "gray25") if name == "settings_frame" else "transparent")

        # show selected frame
        if name == "home":
            window.home_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.home_frame.grid_forget()
        if name == "network_frame":
            window.network_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.network_frame.grid_forget()
        if name == "support_frame":
            window.support_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.support_frame.grid_forget()
        if name == "settings_frame":
            window.settings_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.settings_frame.grid_forget()
    def home_button_event(window):
        window.select_frame_by_name("home")

    def network_button_event(window):
        window.select_frame_by_name("network_frame")

    def support_frame_button_event(window):
        window.select_frame_by_name("support_frame")

    def settings_frame_button_event(window):
        window.select_frame_by_name("settings_frame")

    def change_appearance_mode_event(window, new_appearance_mode):
        customtkinter.set_appearance_mode(new_appearance_mode)

        # Speichern des Farbmodus in den Einstellungen
        save_color_mode_support(window, new_appearance_mode)

    # Select Frame "under frames" from network frame

    def select_network_by_name(window, name):
        # set button color for selected button
        window.network_information_button.configure(fg_color=("gray75", "gray25") if name == "network_information_frame" else "transparent")
        window.network_custom_button.configure(fg_color=("gray75", "gray25") if name == "network_custom_frame" else "transparent")
        window.network_shortcut_button.configure(fg_color=("gray75", "gray25") if name == "network_shortcut_frame" else "transparent")

        # show selected frame
        if name == "network_information_frame":
            window.network_information_frame.grid(row=1, column=1, sticky="nsew", rowspan=5)
        else:
            window.network_information_frame.grid_forget()
        if name == "network_custom_frame":
            window.network_custom_frame.grid(row=1, column=1, sticky="nsew", rowspan=5)
        else:
            window.network_custom_frame.grid_forget()
        if name == "network_shortcut_frame":
            window.network_shortcut_frame.grid(row=1, column=1, sticky="nsew", rowspan=5)
        else:
            window.network_shortcut_frame.grid_forget()

    def information_button_event(window):
        window.select_network_by_name("network_information_frame")

    def custom_button_event(window):
        window.select_network_by_name("network_custom_frame")

    def shortcut_frame_button_event(window):
        window.select_network_by_name("network_shortcut_frame")

if __name__ == "__main__":
    app = App()
    app.mainloop()
