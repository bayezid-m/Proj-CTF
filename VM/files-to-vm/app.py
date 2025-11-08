from flask import Flask, request, jsonify

app = Flask(__name__)

#Todo: Add apikey

# Dummy weather data for demonstration
dummy_weather_data = {
    "Helsinki": {"temperature": -2, "condition": "Snowy"},
    "Tampere": {"temperature": -4, "condition": "Cloudy"},
    "Lisbon": {"temperature": 18, "condition": "Sunny"},
    "Tokyo": {"temperature": 10, "condition": "Rainy"},
}


@app.route("/weather", methods=["GET"])
def get_weather():
    city = request.args.get("city")
    api_key = request.args.get("api_key")

    # Check API key
    if api_key != API_KEY:
        return jsonify({"error": "Invalid API key"}), 403

    # Check if city exists in dummy data
    if not city or city not in dummy_weather_data:
        return jsonify({"error": "City not found"}), 404

    return jsonify({
        "city": city,
        "weather": dummy_weather_data[city]
    })


if __name__ == "__main__":
    app.run(debug=True)
