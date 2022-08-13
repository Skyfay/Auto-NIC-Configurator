# Auto-NIC-Configurator (Jetzt auch mit GUI)
Mit diesem Script kannst du ganz einfach deine Netzwerk Schnittstelle auf einen bestimmten Wert setzen!
Jetzt auch neu mit GUI!
----------------------------------------------------------------------------------------------
**Vorschau:**
![Shortcut-5 0-Blue](https://user-images.githubusercontent.com/76796007/182177099-8a5307e1-0fab-4fa8-801a-a928fc968234.png)
![Custom-5 0-Red](https://user-images.githubusercontent.com/76796007/182177066-602a68ed-a21d-442d-aac3-b630f104e915.png)
![Nic-Team-5 0-Green](https://user-images.githubusercontent.com/76796007/182177090-c3ea8667-5c9b-4288-bb3d-fbe4f2b87776.png)
----------------------------------------------------------------------------------------------
**Voraussetzung:**
- Du brauchst ein Windows System mit einem Admin berechteten User.
- Falls dein Gerät das Ausführen von Scripts verhindert, führe in Powershell (Als Admin) folgenden Befehl aus:<br/>
```Set-ExecutionPolicy RemoteSigned -Scope CurrentUser```
----------------------------------------------------------------------------------------------
**How to use? / Shell Version:**<br/>
1. Lade den letzen Release herunter. 
2. Entpacke die Dateien und lege diese an einem gewünschten Ort ab.
3. Wichtig: Die Datei "Shell NIC Configurator.bat" muss sich immer am gleichen Ort befinden wie die
"Auto-NIC-Configurator.ps1" datei, ansonsten funktioniert es nicht!
4. Starte die Datei "NIC Configurator.bat" und beginne mit dem Script.
----------------------------------------------------------------------------------------------
**How to use? / GUI Version:**<br/>
1. Lade den letzen Release herunter. (Du kannst auch direkt das Script herunterladen es ist Attached)
2. Entpacke die Dateien und lege diese an einem gewünschten Ort ab.
4. Klicke mit einem Rechten Mausklick auf "GUI-Auto-NIC-Configurator.ps1" und klicke auf "Mit Powershell Ausführen".
5. Das Powershell Script startet nun und geht automatisch in den Administrator Modus. Klicke auf "Ja".<br/>

**Debugging:**<br/>

- Wenn nach dem Ausführen und dem bestätigen mit "Ja" kein Fenster erscheint, liegt das ev. an den Berechtigungen. Öffne dafür eine Powershell Instanze (Als Administrator) und führe folgenden Befehl aus: ```Set-ExecutionPolicy RemoteSigned -Scope CurrentUser``` versuche es dann erneut!
----------------------------------------------------------------------------------------------
**Was kann das Script?**
- Es gibt ein Grafisches Interface um die Netzwerk Schnittstellen zu konfigurieren!
- Du kannst Informationen über die einzelnen Schnittstellen abrufen.
- Das Script kann vordefinierte Einstellungen auf deine Netzwerk Karte laden oder du kannst selber welche in einem Guide bestimmen.
- Du kannst die Netzwerk Karte auf "DHCP" stellen, also den Standard Wert.
- Nun ist es auch möglich NIC-Teaming für Hyper-V zu erstellen und zu löschen.
- Du bekommst Benachrichtigungen ob ein Befehl funktioniert hat oder nicht.
----------------------------------------------------------------------------------------------
**Einschränkungen?**
- Beim NIC-Teaming kann man nur bis zu 4 Adapter zusammenschliessen.
----------------------------------------------------------------------------------------------
**Kontakt & Hilfe**
- Wenn du Probleme mit dem Script hast oder gerne einen weiteren Shortcut einer anderen Firma hättest, kannst du gerne auf Github ein "Issues" erstellen.
