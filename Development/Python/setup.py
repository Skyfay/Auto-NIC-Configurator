from cx_Freeze import setup, Executable

# Liste der Dateien und Verzeichnisse, die in die ausführbare Datei aufgenommen werden sollen
include_files = [
    "assets/"
]

setup(
    name="Auto Nic Configurator",
    version="1.0",
    description="Automatic Network Configurator",
    executables=[Executable("main.py", base="Win32GUI", icon="assets/icon/ethernet.ico")], #base="Win32GUI"
    options={
        "build_exe": {
            "include_files": include_files,
            "packages": ["setuptools", "customtkinter", "darkdetect", "psutil", "requests"],
            "includes": ["setuptools", "customtkinter", "darkdetect", "psutil", "requests"],
        },
    },
)

# C:\Users\Skyfay\AppData\Local\Programs\Python\Python39\python.exe setup.py build (execute with python)
