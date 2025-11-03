const http = require("http");

function sendRequests() {
  // POST request
  const postData = JSON.stringify({ username: "test", password: "1234" });
  const postOptions = {
    hostname: "127.0.0.1",
    port: 8000,
    path: "/api/login",
    method: "POST",
    headers: { "Content-Type": "application/json" },
  };

  const postReq = http.request(postOptions, res => {
    console.log("POST /api/login ->", res.statusCode);
  });
  postReq.write(postData);
  postReq.end();

  // GET request
  http.get("http://127.0.0.1:8000/secret.txt", res => {
    console.log("GET /secret.txt ->", res.statusCode);
  });
}

setInterval(sendRequests, 5000);
