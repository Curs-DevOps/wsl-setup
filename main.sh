#!/bin/bash
# main.sh - Main setup script for Ubuntu 24.04

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=================================="
echo "Ubuntu 24.04 Setup Script"
echo "=================================="

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Run individual setup scripts
echo ""
echo "Running individual setup scripts..."

bash "$SCRIPT_DIR/setup-ssh.sh"
bash "$SCRIPT_DIR/setup-fonts.sh"
bash "$SCRIPT_DIR/setup-shell.sh"
bash "$SCRIPT_DIR/setup-docker.sh"
bash "$SCRIPT_DIR/setup-terraform.sh"
bash "$SCRIPT_DIR/setup-railway.sh"

echo ""
echo "=================================="
echo "Setup complete!"
echo "=================================="
echo ""
echo "NEXT STEPS:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Activate Docker group: newgrp docker"
echo "3. Configure your terminal font to '0xProto Nerd Font'"
echo "4. Login to Railway: railway login"
echo "5. (Optional) Login to Docker Hub: docker login"
echo ""
echo "See README.md for detailed post-installation steps!"

