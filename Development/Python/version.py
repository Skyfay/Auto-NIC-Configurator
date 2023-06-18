import requests


def is_application_up_to_date(owner, repo):
    # GitHub API-Endpunkt für das Repository
    url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"

    try:
        # GET-Anfrage an die API senden
        response = requests.get(url)
        response.raise_for_status()  # Fehler werfen, wenn die Anfrage nicht erfolgreich war
        release_data = response.json()

        # Aktuelle Version des Repositories abrufen
        latest_version = release_data["tag_name"]

        # Hier kannst du die Logik für den Vergleich der aktuellen Version mit der installierten Version implementieren
        # Zum Beispiel könntest du die installierte Version auslesen und sie mit latest_version vergleichen.
        # Je nachdem, wie deine Anwendung strukturiert ist, kann dies variieren.

        # Gib True zurück, wenn die Anwendung aktuell ist, andernfalls False
        return True

    except requests.exceptions.RequestException as e:
        # Fehlerbehandlung, wenn die Anfrage fehlschlägt
        print("Fehler bei der Verbindung zur GitHub API:", e)
        return False


# Beispielaufruf
owner = "openai"
repo = "gpt-3.5-turbo"
is_up_to_date = is_application_up_to_date(owner, repo)

if is_up_to_date:
    print("Die Anwendung ist aktuell.")
else:
    print("Die Anwendung ist nicht aktuell.")
