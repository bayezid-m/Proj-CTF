#!/usr/bin/env bash
set -euo pipefail

# Path to the project
TARGET_DIR="/kali/home/projectX"

# Check node and npm
if ! command -v node >/dev/null 2>&1; then
  echo "Error: node not found in PATH. Please install Node.js before running the script." >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm not found in PATH. Please install npm before running the script." >&2
  exit 1
fi

# Remove existing folder if it exists
if [ -d "$TARGET_DIR" ]; then
  echo "Found $TARGET_DIR — removing..."
  rm -rf -- "$TARGET_DIR"
fi

# Create folder
echo "Creating folder $TARGET_DIR"
mkdir -p -- "$TARGET_DIR"
cd "$TARGET_DIR"

# Create a Vite React project (attempt to make it non-interactive)
# Using npm create command. If it happens to ask questions, try to accept defaults.
echo "Creating Vite + React project (non-interactive attempt)..."
# npx/npm create might sometimes prompt; try to avoid prompts by piping yes
if ! yes "" | npm create vite@latest . -- --template react >/dev/null 2>&1; then
  # If create fails, try a manual fallback initialization
  echo "npm create failed — performing fallback initialization."
  npm init -y >/dev/null
  npm install react react-dom vite >/dev/null
  # add scripts and basic index files if missing
  cat > package.json <<'JSON'
{
  "name": "projectx",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "vite": "^5.0.0"
  }
}
JSON
  # create a simple src folder if it doesn't exist
  mkdir -p src
  cat > index.html <<'HTML'
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>projectX</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
HTML
  cat > src/main.jsx <<'JSX'
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";

createRoot(document.getElementById("root")).render(<App />);
JSX
  cat > src/App.jsx <<'JSX'
import React from "react";
export default function App(){
  return <h1>projectX</h1>;
}
JSX
  # install dependencies
  npm install --silent >/dev/null
else
  # if npm create succeeded — install dependencies
  echo "Vite project created, installing dependencies..."
  npm install --silent
fi

# Create .env file
echo "Writing .env file"
cat > .env <<'ENV'
APIKEY=12345asdf
ENV

# Initialize git and make the first commit
echo "Initializing git and making the first commit"
git init >/dev/null
# Set local git user so commit doesn't fail if global config is missing
git config user.name "Automated Script"
git config user.email "script@example.com"

git add --all
git commit -m "Initial commit: scaffolded Vite React project and .env" >/dev/null

echo "Done. Project is located at: $TARGET_DIR"
echo "You can run the development server with: cd $TARGET_DIR && npm run dev"
