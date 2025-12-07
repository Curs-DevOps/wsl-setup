#!/bin/bash
# setup-ssh.sh - Setup SSH key for GitHub

set -e

echo "=================================="
echo "Setting up SSH for GitHub"
echo "=================================="

SSH_KEY="$HOME/.ssh/github_ssh"

# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate SSH key if it doesn't exist
if [ -f "$SSH_KEY" ]; then
    echo "SSH key already exists at $SSH_KEY"
else
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "github_ssh"
    chmod 600 "$SSH_KEY"
    chmod 644 "$SSH_KEY.pub"
fi

# Start ssh-agent and add key
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

# Display the public key
echo ""
echo "Your public key:"
echo "---"
cat "$SSH_KEY.pub"
echo "---"

# Setup SSH agent to run at startup
echo ""
echo "Setting up SSH agent to run at startup..."

# Add to .bashrc
if ! grep -q "# SSH Agent Setup" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# SSH Agent Setup
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/github_ssh 2>/dev/null
fi
EOF
    echo "✓ Added SSH agent to .bashrc"
fi

# Add to .zshrc (will be created by setup-shell.sh)
if [ -f ~/.zshrc ] && ! grep -q "# SSH Agent Setup" ~/.zshrc; then
    cat >> ~/.zshrc << 'EOF'

# SSH Agent Setup
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/github_ssh 2>/dev/null
fi
EOF
    echo "✓ Added SSH agent to .zshrc"
fi

# Add GitHub to known hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null

# Configure SSH to use this key for GitHub
cat > ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile $SSH_KEY
    IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config

echo ""
echo "=================================="
echo "IMPORTANT: Add the SSH key to GitHub"
echo "=================================="
echo "1. Go to https://github.com/settings/ssh/new"
echo "2. Paste the key from your clipboard"
echo "3. Give it a title (e.g., 'WSL Ubuntu 24.04')"
echo "4. Click 'Add SSH key'"
echo ""
read -p "Press ENTER after you've added the key to GitHub..."

# Test connection
echo ""
echo "Testing GitHub connection..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✓ GitHub SSH connection successful!"
else
    echo "⚠ GitHub SSH connection test (this is expected on first try)"
    echo "Running test again..."
    ssh -T git@github.com || true
fi

echo ""
echo "✓ SSH setup complete"
