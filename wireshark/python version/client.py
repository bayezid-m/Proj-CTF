import requests
import time

url_base = "http://127.0.0.1:8000"

def send_requests():
    while True:
        try:
            # POST request with username, password, and flag
            payload = {
                "username": "test",
                "password": "1234",
                "flag": "CTF{I am the ghost}"
            }
            r1 = requests.post(f"{url_base}/api/login", json=payload)
            print("POST /api/login ->", r1.status_code)

            # GET request
            r2 = requests.get(f"{url_base}/secret.txt")
            print("GET /secret.txt ->", r2.status_code)

        except Exception as e:
            print("Error:", e)

        time.sleep(5)

if __name__ == "__main__":
    send_requests()
