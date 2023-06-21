from cx_Freeze import setup, Executable

setup(
    name="Auto Nic Configurator",
    version="1.0",
    description="Automatic Network Configurator",
    executables=[Executable("main.py", icon="assets/icon/ethernet.ico")],
    options={
        "build_exe": {
            "include_files": [
                "assets/"
            ],
            "packages": ["setuptools", "customtkinter", "darkdetect", "psutil", "requests"],
            "includes": ["setuptools", "customtkinter", "darkdetect", "psutil", "requests"],
        },
    },
)

# setup.py build (execute with python)
