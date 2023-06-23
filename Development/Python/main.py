import customtkinter
import os
import json
from PIL import Image

from network_collector import get_network_adapters_info
from network_viewer import network_adapter_select_event, initialize_adapter_select_placeholder, update_adapter_select_values
from support import send_message_to_webhook
from appearance import change_appearance_mode_event_textbox_support, save_color_mode_support

# Aufruf der Funktion, um die Informationen der Netzwerk Adapter zu aktuallisieren abzurufen
get_network_adapters_info()
def initialize_adapter_select_placeholder(window):
    placeholder_text = "Select Adapter"
    window.home_frame_adapter_select.set(placeholder_text)
    window.home_frame_adapter_select.configure(state="readonly")

def update_adapter_select_values(window, adapter_names):
     window.home_frame_adapter_select.configure(values=adapter_names)

class App(customtkinter.CTk):
    def __init__(window):
        super().__init__()

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
        window.title("v.0.1.0 - alpha") # Windows titel
        window.minsize(750, 475) # minimum size from the window
        window.geometry("750x475") # startup size from the window
        window.iconbitmap("assets/icon/version.ico") # header icon

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
        window.chat_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "chat_dark.png")),
                                                 dark_image=Image.open(os.path.join(image_path, "chat_light.png")), size=(20, 20))
        window.add_user_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "add_user_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "add_user_light.png")), size=(20, 20))
        window.support_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "support_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "support_light.png")), size=(20, 20))
        window.settings_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "settings_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "settings_light.png")), size=(20, 20))

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

        window.frame_2_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Frame 2",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=window.chat_image, anchor="w", command=window.frame_2_button_event)
        window.frame_2_button.grid(row=2, column=0, sticky="ew")

        window.support_frame_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Support",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=window.support_image, anchor="w", command=window.support_frame_button_event)
        window.support_frame_button.grid(row=3, column=0, sticky="ew")

        window.settings_frame_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Settings",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=window.settings_image, anchor="w", command=window.settings_frame_button_event)
        window.settings_frame_button.grid(row=4, column=0, sticky="ew")

        window.appearance_mode_menu = customtkinter.CTkOptionMenu(window.navigation_frame, values=["Light", "Dark", "System"],
                                                                command=window.change_appearance_mode_event)
        window.appearance_mode_menu.set(appearance_mode)  # Set the initial value to the loaded appearance_mode
        window.appearance_mode_menu.grid(row=6, column=0, padx=20, pady=20, sticky="s")


        # create home frame
        window.home_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")
        window.home_frame.grid_columnconfigure(0, weight=1)

        window.home_frame_large_image_label = customtkinter.CTkLabel(window.home_frame, text="", image=window.large_test_image)
        window.home_frame_large_image_label.grid(row=0, column=0, padx=20, pady=10)

        window.home_frame_adapter_select = customtkinter.CTkOptionMenu(window.home_frame, values=adapter_names,
                                                                       command=lambda
                                                                           adapter: network_adapter_select_event(window,
                                                                                                                 adapter))
        window.home_frame_adapter_select.grid(row=1, column=0, padx=20, pady=10)

        # Aufruf der Funktion zum Initialisieren des Platzhalterss
        initialize_adapter_select_placeholder(window)

        window.adapter_info_label = customtkinter.CTkLabel(window.home_frame, text="", font=customtkinter.CTkFont(size=12))
        window.adapter_info_label.grid(row=2, column=0, padx=20, pady=10)

        # create second frame
        window.second_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")

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

        window.message_textbox = customtkinter.CTkTextbox(window.support_frame, width=200, height=200, wrap="word", fg_color="#343638", border_width=2, border_color="#565b5e")
        window.message_textbox.grid(row=4, column=0, padx=20, pady=5)
        # window.message_textbox.insert("1.0", text="Here you can write your message...", tags=None)

        window.message_entry = customtkinter.CTkButton(window.support_frame, text="Send", command=lambda: send_message_to_webhook(window))
        window.message_entry.grid(row=5, column=0, padx=20, pady=10)

        # create settings frame
        window.settings_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")
        window.settings_frame.grid_columnconfigure(1, weight=3) # 0, weight=1
        window.settings_pre_frame = customtkinter.CTkFrame(window.settings_frame, corner_radius=10, bg_color=("#ebebeb", "#242424"))
        window.settings_pre_frame.grid(row=0, column=0, padx=10, pady=5, sticky="we")
        window.settings_pre_frame1 = customtkinter.CTkFrame(window.settings_frame, corner_radius=10, bg_color=("#ebebeb", "#242424"))
        window.settings_pre_frame1.grid(row=1, column=0, padx=10, pady=5, sticky="we")
        # Text change the appearance mode
        window.settings_frame_appearance_label = customtkinter.CTkLabel(window.settings_pre_frame, text="App Appearance",
                                                                    font=customtkinter.CTkFont(size=12))
        window.settings_frame_appearance_label.grid(row=0, column=0, padx=10, pady=0)
        # Button to change the appearance mode
        window.settings_frame_appearance_mode_menu = customtkinter.CTkOptionMenu(window.settings_pre_frame,
                                                                values=["Light", "Dark", "System"],
                                                                command=window.change_appearance_mode_event,
                                                                button_color="#975730",
                                                                fg_color="#d07138",
                                                                button_hover_color="#603d28")
        window.settings_frame_appearance_mode_menu.set(appearance_mode)  # Set the initial value to the loaded appearance_mode
        window.settings_frame_appearance_mode_menu.grid(row=0, column=1, padx=20, pady=10, sticky="e", ipadx=0 )

        # Text change the appearance mode
        window.settings_frame_appearance_label1 = customtkinter.CTkLabel(window.settings_pre_frame1, text="App Appearance test youg adfsdafsdf asdfsaf",
                                                                    font=customtkinter.CTkFont(size=12))
        window.settings_frame_appearance_label1.grid(row=0, column=0, padx=10, pady=0)
        # Button to change the appearance mode
        window.settings_frame_appearance_mode_menu1 = customtkinter.CTkOptionMenu(window.settings_pre_frame1,
                                                                values=["Light", "Dark", "System"],
                                                                command=window.change_appearance_mode_event,
                                                                button_color="#975730",
                                                                fg_color="#d07138",
                                                                button_hover_color="#603d28")
        window.settings_frame_appearance_mode_menu1.set(appearance_mode)  # Set the initial value to the loaded appearance_mode
        window.settings_frame_appearance_mode_menu1.grid(row=0, column=1, padx=20, pady=10, sticky="e", ipadx=0)

        # select default frame
        window.select_frame_by_name("home")

        # select default frame
        window.select_frame_by_name("home")

    def select_frame_by_name(window, name):
        # set button color for selected button
        window.home_button.configure(fg_color=("gray75", "gray25") if name == "home" else "transparent")
        window.frame_2_button.configure(fg_color=("gray75", "gray25") if name == "frame_2" else "transparent")
        window.support_frame_button.configure(fg_color=("gray75", "gray25") if name == "support_frame" else "transparent")
        window.settings_frame_button.configure(
            fg_color=("gray75", "gray25") if name == "settings_frame" else "transparent")

        # show selected frame
        if name == "home":
            window.home_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.home_frame.grid_forget()
        if name == "frame_2":
            window.second_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.second_frame.grid_forget()
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

    def frame_2_button_event(window):
        window.select_frame_by_name("frame_2")

    def support_frame_button_event(window):
        window.select_frame_by_name("support_frame")

    def settings_frame_button_event(window):
        window.select_frame_by_name("settings_frame")

    def change_appearance_mode_event(window, new_appearance_mode):
        customtkinter.set_appearance_mode(new_appearance_mode)
        change_appearance_mode_event_textbox_support(window, new_appearance_mode)  # Change Text field color in support

        # Speichern des Farbmodus in den Einstellungen
        save_color_mode_support(window, new_appearance_mode)

if __name__ == "__main__":
    app = App()
    app.mainloop()
