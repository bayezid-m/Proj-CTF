from flask import Flask, request, Response
import requests
import threading
import shutil
import os
import time

UBUNTU_FILE_URL = "http://192.168.0.20:9001/secret.txt"
app = Flask(__name__)

ALLOWED_IP = "192.168.0.20"  # attacker IP
TIMEOUT = 10  # seconds
timer = None
timer_started = False  # <-- NEW: track if timer has started

def reset_timer():
    global timer, timer_started
    if timer:
        timer.cancel()
    timer = threading.Timer(TIMEOUT, send_flag)
    timer.start()
    timer_started = True
    print("Timer reset")

def send_flag():
    print("Blocked, sending flag!")
    desktop = os.path.join(os.path.expanduser("~"), "Desktop", "flag.txt")
    flag_src = "/home/kali/CTF/wireshark/flag.txt"
    try:
        shutil.copyfile(flag_src, desktop)
        print("Flag sent")
    except Exception as e:
        print("error:", e)

@app.route('/api/login', methods=['POST'])
def login():
    global timer_started

    data = request.get_data(as_text=True)
    print("Received POST to /api/login")
    print("Body:", data)

    client_ip = request.remote_addr
    print("Client IP:", client_ip)

    # ---- Only start/reset timer after first POST from attacker ----
    if client_ip == ALLOWED_IP:
        if not timer_started:
            print("Starting timer for first time")
        else:
            print("Resetting timer")
        reset_timer()
    else:
        print("Wrong IP — no reset")

    return "OK", 200

@app.route('/secret.txt', methods=['GET'])
def secret_proxy():
    r = requests.get(UBUNTU_FILE_URL)
    return Response(r.content, mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
