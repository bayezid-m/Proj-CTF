#!/usr/bin/env bash
set -e

cd /home/vagrant/project

# Check if .git exists in the project root
if [ -d ".git" ]; then
  rm -rf .git
fi
if [ -f ".env" ]; then
    rm -f .env
fi
if [ -f ".gitignore" ]; then
  rm -f .gitignore
fi

# Initialize a new Git repository
git init

# Configure Git username
git config user.name "Kalma Vakinen"

git add app.py
git commit -m "Initial commit"

# Create .env file with the given content
echo "APIKEY=1s33de4dpeople" > .env

# Stage and commit the .env file
git add .env
git commit -m "this is sin"
