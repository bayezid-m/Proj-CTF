from flask import Flask, request, send_from_directory
import os

app = Flask(__name__)

# Task 1: Handle POST request
@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_data(as_text=True)
    print("Received POST to /api/login")
    print("Body:", data)
    return "OK", 200

# Task 2: Serve secret.txt
@app.route('/secret.txt', methods=['GET'])
def secret_file():
    directory = os.path.dirname(os.path.abspath(__file__))
    return send_from_directory(directory, 'secret.txt')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)


#filter with
#task1: http.request.method == "POST"
#task2: http && ip.addr == 192.168.33.10