#!/bin/zsh
# Pull latest changes to avoid conflicts
git pull origin main

# Stage and commit all changes
git add .
git commit -m "Automated deploy: update site content"

# Build the Hugo site
hugo

# Go to the public directory
cd public

# Add and commit public/ changes
git add .
git commit -m "Automated deploy: update public site"

# Push to remote repo
git push origin main

# Return to project root
cd ..
