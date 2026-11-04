#!/bin/bash
set -e

echo "📋 Running pre-deployment checks..."

if [ -e "static/CNAME" ]; then
    echo "❌ Remove static/CNAME when deploying to the default GitHub Pages URL"
    exit 1
fi
echo "✅ No custom domain configured"

# Check no accidental issues in front matter
echo "🔍 Checking post front matter..."
for file in content/posts/*.md; do
    if ! grep -q "^title:" "$file"; then
        echo "⚠️  Warning: $file missing title"
    fi
done

# Validate Hugo build
echo "🔨 Building site with Hugo..."
if ! hugo --cleanDestinationDir; then
    echo "❌ Hugo build failed"
    exit 1
fi
echo "✅ Hugo build successful"

# Check public directory is not empty
if [ ! -d "public" ] || [ -z "$(ls -A public)" ]; then
    echo "❌ Build produced empty public directory"
    exit 1
fi
echo "✅ Public directory populated"

if [ -e "public/CNAME" ]; then
    echo "❌ Build output contains an unexpected CNAME file"
    exit 1
fi

echo ""
echo "✅ All pre-deployment checks passed!"
echo "Ready to deploy with: ./deploy.sh"
