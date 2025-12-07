#!/bin/bash
# setup-shell.sh - Setup Zsh, Starship, and plugins

set -e

echo "=================================="
echo "Setting up Zsh and Starship"
echo "=================================="

# Install Zsh
echo "Installing Zsh..."
sudo apt install -y zsh

# Install Starship
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install zsh-autosuggestions
echo "Installing zsh-autosuggestions..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    mkdir -p ~/.zsh
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting
echo "Installing zsh-syntax-highlighting..."
if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

# Create .zshrc
echo "Configuring .zshrc..."
cat > ~/.zshrc << 'EOF'
# Zsh configuration

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship prompt
eval "$(starship init zsh)"

# Aliases
alias ll='ls -lah'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
EOF

# Add SSH agent setup to .zshrc
cat >> ~/.zshrc << 'EOF'

# SSH Agent Setup
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/github_ssh 2>/dev/null
fi
EOF

# Change default shell to Zsh
echo "Changing default shell to Zsh..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo "✓ Default shell changed to Zsh"
else
    echo "✓ Zsh is already the default shell"
fi

echo "✓ Shell setup complete"
