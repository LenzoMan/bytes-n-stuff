#!/bin/zsh
# Build the Hugo site
hugo

# Go to the public directory
cd public

# Add and commit changes
# (If this is the first time, you may need to run 'git init' and set the remote)
git add .
git commit -m "Automated site build and deploy"

git push origin main

# Return to project root
dcd ..
