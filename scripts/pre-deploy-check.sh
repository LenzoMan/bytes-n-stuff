#!/bin/bash
set -e

echo "📋 Running pre-deployment checks..."

# Check CNAME exists
if [ ! -f "static/CNAME" ]; then
    echo "❌ Missing static/CNAME file"
    exit 1
fi
echo "✅ CNAME file found"

# Check no accidental issues in front matter
echo "🔍 Checking post front matter..."
for file in content/posts/*.md; do
    if ! grep -q "^title:" "$file"; then
        echo "⚠️  Warning: $file missing title"
    fi
done

# Validate Hugo build
echo "🔨 Building site with Hugo..."
if ! hugo; then
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

echo ""
echo "✅ All pre-deployment checks passed!"
echo "Ready to deploy with: ./deploy.sh"
