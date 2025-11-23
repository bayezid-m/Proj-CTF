from flask import Flask, request, Response
import requests

UBUNTU_FILE_URL = "http://192.168.0.20:9001/secret.txt"

app = Flask(__name__)

@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_data(as_text=True)
    print("Received POST to /api/login")
    print("Body:", data)
    return "OK", 200

@app.route('/secret.txt', methods=['GET'])
def secret_proxy():
    r = requests.get(UBUNTU_FILE_URL)
    return Response(r.content, mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
