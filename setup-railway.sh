#!/bin/bash
# setup-railway.sh - Install Railway CLI

set -e

echo "=================================="
echo "Installing Railway CLI"
echo "=================================="

# Install Railway using official script
echo "Downloading and installing Railway..."
curl -fsSL https://railway.app/install.sh | sh

# Add Railway to PATH for current session if needed
if ! command -v railway &> /dev/null; then
    export PATH="$HOME/.railway/bin:$PATH"
fi

# Add to shell configs if not present
if ! grep -q ".railway/bin" ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.railway/bin:$PATH"' >> ~/.bashrc
fi

if ! grep -q ".railway/bin" ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/.railway/bin:$PATH"' >> ~/.zshrc
fi

# Verify installation
if command -v railway &> /dev/null; then
    RAILWAY_VERSION=$(railway --version 2>&1 || echo "installed")
    echo "✓ Railway CLI installed: $RAILWAY_VERSION"
else
    echo "✓ Railway CLI installed (restart terminal to use)"
fi

echo ""
echo "To login to Railway, run: railway login"

