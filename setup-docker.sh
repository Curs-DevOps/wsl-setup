#!/bin/bash
# setup-docker.sh - Install Docker and Docker Compose

set -e

echo "=================================="
echo "Installing Docker"
echo "=================================="

# Remove old versions
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
echo "Adding Docker GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "Installing Docker Engine..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
echo "Adding user to docker group..."
sudo usermod -aG docker $USER

# Start and enable Docker
echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "✓ Docker installed successfully"
echo ""
echo "Note: You may need to log out and back in for group changes to take effect"
echo "      Or run: newgrp docker"
