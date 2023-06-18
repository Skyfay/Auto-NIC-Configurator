import customtkinter
import os
import json
from PIL import Image

from network import get_network_adapters_info # import the network funktion

# Aufruf der Funktion, um die Informationen abzurufen
get_network_adapters_info()

class App(customtkinter.CTk):
    def __init__(window):
        super().__init__()

        # Get Network Adapter for dropdown menu to select
        def get_network_adapter_names(window):
            # Load network adapters from JSON file
            with open(json_file_path) as file:
                adapters = json.load(file)

            # Extract adapter names
            adapter_names = [adapter['name'] for adapter in adapters]

            return adapter_names

        # Definiere den Pfad zur network_adapters.json-Datei
        json_file_path = os.path.join(os.environ['LOCALAPPDATA'], 'Skyfay', 'AutoNicConfigurator',
                                      'network_adapters.json')

        adapter_names = get_network_adapter_names(window)

        # Gui
        window.title("") # Windows titel
        window.minsize(700, 450) # minimum size from the window
        window.geometry("750x450") # startup size from the window
        window.iconbitmap("assets/icon/transparent.ico") # header icon

        # set grid layout 1x2
        window.grid_rowconfigure(0, weight=1)
        window.grid_columnconfigure(1, weight=1)

        # load images with light and dark mode image
        image_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "assets/icon")
        window.logo_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "ethernet.png")), size=(26, 26))
        window.large_test_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "large_test_image.png")), size=(500, 150))
        window.image_icon_image = customtkinter.CTkImage(Image.open(os.path.join(image_path, "image_icon_light.png")), size=(20, 20))
        window.home_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "home_dark.png")),
                                                 dark_image=Image.open(os.path.join(image_path, "home_light.png")), size=(20, 20))
        window.chat_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "chat_dark.png")),
                                                 dark_image=Image.open(os.path.join(image_path, "chat_light.png")), size=(20, 20))
        window.add_user_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "add_user_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "add_user_light.png")), size=(20, 20))
        window.settings_image = customtkinter.CTkImage(light_image=Image.open(os.path.join(image_path, "settings_dark.png")),
                                                     dark_image=Image.open(os.path.join(image_path, "settings_light.png")), size=(20, 20))

        # create navigation frame left side
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

        window.frame_3_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Frame 3",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=window.add_user_image, anchor="w", command=window.frame_3_button_event)
        window.frame_3_button.grid(row=3, column=0, sticky="ew")

        window.settings_frame_button = customtkinter.CTkButton(window.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Settings",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                      image=window.settings_image, anchor="w", command=window.settings_frame_button_event)
        window.settings_frame_button.grid(row=4, column=0, sticky="ew")

        window.appearance_mode_menu = customtkinter.CTkOptionMenu(window.navigation_frame, values=["Light", "Dark", "System"],
                                                                command=window.change_appearance_mode_event)
        window.appearance_mode_menu.grid(row=6, column=0, padx=20, pady=20, sticky="s")

        # create home frame
        window.home_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")
        window.home_frame.grid_columnconfigure(0, weight=1)

        window.home_frame_large_image_label = customtkinter.CTkLabel(window.home_frame, text="", image=window.large_test_image)
        window.home_frame_large_image_label.grid(row=0, column=0, padx=20, pady=10)

        window.home_frame_adapter_select = customtkinter.CTkOptionMenu(window.home_frame, values=adapter_names,
                                                                       command=window.change_appearance_mode_event)
        window.home_frame_adapter_select.grid(row=1, column=0, padx=20, pady=10)
        window.home_frame_button_2 = customtkinter.CTkButton(window.home_frame, text="CTkButton", image=window.image_icon_image, compound="right")
        window.home_frame_button_2.grid(row=2, column=0, padx=20, pady=10)
        window.home_frame_button_3 = customtkinter.CTkButton(window.home_frame, text="CTkButton", image=window.image_icon_image, compound="top")
        window.home_frame_button_3.grid(row=3, column=0, padx=20, pady=10)

        # create second frame
        window.second_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")

        # create third frame
        window.third_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")

        # create settings frame
        window.settings_frame = customtkinter.CTkFrame(window, corner_radius=0, fg_color="transparent")

        # select default frame
        window.select_frame_by_name("home")

    def select_frame_by_name(window, name):
        # set button color for selected button
        window.home_button.configure(fg_color=("gray75", "gray25") if name == "home" else "transparent")
        window.frame_2_button.configure(fg_color=("gray75", "gray25") if name == "frame_2" else "transparent")
        window.frame_3_button.configure(fg_color=("gray75", "gray25") if name == "frame_3" else "transparent")
        window.settings_frame_button.configure(fg_color=("gray75", "gray25") if name == "settings_frame" else "transparent")

        # show selected frame
        if name == "home":
            window.home_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.home_frame.grid_forget()
        if name == "frame_2":
            window.second_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.second_frame.grid_forget()
        if name == "frame_3":
            window.third_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.third_frame.grid_forget()
        if name == "settings_frame":
            window.settings_frame.grid(row=0, column=1, sticky="nsew")
        else:
            window.settings_frame.grid_forget()
    def home_button_event(window):
        window.select_frame_by_name("home")

    def frame_2_button_event(window):
        window.select_frame_by_name("frame_2")

    def frame_3_button_event(window):
        window.select_frame_by_name("frame_3")

    def settings_frame_button_event(window):
        window.select_frame_by_name("settings_frame")

    def change_appearance_mode_event(window, new_appearance_mode):
        customtkinter.set_appearance_mode(new_appearance_mode)

if __name__ == "__main__":
    app = App()
    app.mainloop()
