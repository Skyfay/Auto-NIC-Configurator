import ctypes

# Lock Windows Function
def lock_pc():
    ctypes.windll.user32.LockWorkStation()
