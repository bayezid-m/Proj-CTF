const http = require("http");
const fs = require("fs");
const path = require("path");

const port = 8000;
const ip = "192.168.0.107";

const server = http.createServer((req, res) => {
  if (req.method === "GET" && req.url === "/") {
    const filePath = path.join(__dirname, "/login.html");
    fs.readFile(filePath, (err, data) => {
      if (err) {
        res.writeHead(404, { "Content-Type": "text/plain" });
        res.end("File not found");
      } else {
        res.writeHead(200, { "Content-Type": "text/html" });
        res.end(data);
      }
    });
  }
  // Task 1: login POST 
  else if (req.method === "POST" && req.url === "/api/login") {
    let body = "";
    req.on("data", chunk => {
      body += chunk.toString();
    });
    req.on("end", () => {
      console.log("Received POST to /api/login");
      console.log("Body:", body);
      res.writeHead(200, { "Content-Type": "text/plain" });
      res.end("OK");
    });

  // Task 2: serve the file directly
  } else if (req.method === "GET" && req.url === "/secret.txt") {
    const filePath = path.join(__dirname, "secret.txt");
    fs.readFile(filePath, (err, data) => {
      if (err) {
        res.writeHead(404, { "Content-Type": "text/plain" });
        res.end("File not found");
      } else {
        res.writeHead(200, { "Content-Type": "text/plain" });
        res.end(data);
      }
    });

  } else {
    res.writeHead(404, { "Content-Type": "text/plain" });
    res.end("Not Found");
  }
});

server.listen(port, ip, () => {
  console.log(`Server running at http://${ip}:${port}`);
});



//filter with
//task1: http.request.method == "POST"
//task2: http.request.uri contains "secret.txt"

