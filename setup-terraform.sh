#!/bin/bash
# setup-terraform.sh - Install Terraform

set -e

echo "=================================="
echo "Installing Terraform"
echo "=================================="

# Install prerequisites
sudo apt install -y gnupg software-properties-common

# Add HashiCorp GPG key
echo "Adding HashiCorp GPG key..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Verify the key
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

# Add HashiCorp repository
echo "Adding HashiCorp repository..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
echo "Installing Terraform..."
sudo apt update
sudo apt install -y terraform

# Verify installation
TERRAFORM_VERSION=$(terraform version | head -n1)
echo "✓ Terraform installed: $TERRAFORM_VERSION"

