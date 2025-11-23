import requests
import time

# Kali machine IP address
url_base = "http://192.168.0.10:8000"

def send_requests():
    while True:
        try:
            payload = {
                "username": "test",
                "password": "1234",
                "flag": "CTF{I am the ghost}"
            }

            r1 = requests.post(f"{url_base}/api/login", json=payload)
            print("POST /api/login ->", r1.status_code)

            r2 = requests.get(f"{url_base}/secret.txt")
            print("GET /secret.txt ->", r2.status_code)

        except Exception as e:
            print("Error:", e)

        time.sleep(5)

if __name__ == "__main__":
    send_requests()
