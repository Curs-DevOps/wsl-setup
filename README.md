# Ubuntu 24.04 Automated Setup Scripts

Complete automated setup for Ubuntu 24.04 with developer tools and configurations.

## What Gets Installed

- **SSH Key for GitHub** - Automatically generated, copied to clipboard, and configured
- **0xProto Nerd Font** - Beautiful coding font with icons
- **Zsh + Starship** - Modern shell with beautiful prompt
- **Zsh Plugins** - autosuggestions and syntax highlighting
- **Docker & Docker Compose** - Container platform
- **Terraform** - Infrastructure as code tool
- **Railway CLI** - Deployment platform CLI

## Prerequisites

Before running the scripts, ensure you have:

- Ubuntu 24.04 (native or WSL2)
- `sudo` access
- Internet connection
- GitHub account (for SSH key setup)

## Installation Steps

### 1. Download the Scripts

Clone or download all the scripts into a directory:

```bash
mkdir ~/ubuntu-setup
cd ~/ubuntu-setup
# Copy all the scripts here (main.sh, setup-*.sh)
```

### 2. Make Scripts Executable

```bash
chmod +x main.sh
chmod +x setup-*.sh
```

### 3. Run the Main Setup Script

```bash
./main.sh
```

The script will:
- Update your system packages
- Run each setup script in sequence
- Pause when you need to add SSH key to GitHub
- Show progress and completion status

### 4. During Installation

**SSH Key Setup:**
- The script will generate an SSH key and copy it to your clipboard
- You'll be prompted to add it to GitHub at https://github.com/settings/ssh/new
- Press ENTER after adding the key to continue
- The script will test the GitHub connection

## Post-Installation Steps

### 1. Restart Your Terminal

```bash
# Close and reopen your terminal, or run:
source ~/.zshrc
```

### 2. Activate Docker Group (Important!)

After Docker installation, you need to activate the docker group:

```bash
newgrp docker
```

Or log out and back in for the group change to take effect.

### 3. Test Docker

```bash
docker run hello-world
```

### 4. Configure Terminal Font (WSL Users)

If you're using WSL with Windows Terminal:

1. Open Windows Terminal Settings (Ctrl + ,)
2. Go to your Ubuntu profile
3. Appearance → Font face
4. Select "0xProto Nerd Font" or "0xProto Nerd Font Mono"
5. Save and restart terminal

For other terminals (native Linux):
- **GNOME Terminal:** Preferences → Profiles → Text → Custom font
- **Konsole:** Settings → Edit Current Profile → Appearance → Font
- **Alacritty:** Edit `~/.config/alacritty/alacritty.yml`:
  ```yaml
  font:
    normal:
      family: "0xProto Nerd Font Mono"
  ```

### 5. Login to Docker Hub (Optional)

If you need to push/pull private images:

```bash
docker login
```

Enter your Docker Hub username and password when prompted.

### 6. Login to Railway

```bash
railway login
```

This will open your browser for authentication.

### 7. Configure Git (If Not Already Done)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 8. Test Your SSH Connection to GitHub

```bash
ssh -T git@github.com
```

You should see: "Hi username! You've successfully authenticated..."

## Verify Installations

Run these commands to verify everything is installed:

```bash
# Check Zsh
zsh --version

# Check Starship
starship --version

# Check Docker
docker --version
docker compose version

# Check Terraform
terraform version

# Check Railway
railway --version

# Check font installation
fc-list | grep -i oxproto
```

## Customization

### Modify Zsh Configuration

Edit `~/.zshrc` to add your own aliases, functions, or configurations.

### Modify Starship Prompt

Create a custom Starship config:

```bash
mkdir -p ~/.config
starship preset nerd-font-symbols > ~/.config/starship.toml
```

Then edit `~/.config/starship.toml` to customize your prompt.

## Troubleshooting

### SSH Key Not Working

```bash
# Check if SSH agent is running
ssh-add -l

# If not, start it manually
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_ssh
```

### Docker Permission Denied

```bash
# Add yourself to docker group again
sudo usermod -aG docker $USER

# Then logout and login, or run:
newgrp docker
```

### Font Not Showing

- Make sure you selected the correct font in your terminal settings
- Try "0xProto Nerd Font Mono" if "0xProto Nerd Font" doesn't work
- Restart your terminal after changing font settings

### Zsh Not Default Shell

```bash
# Check current shell
echo $SHELL

# Change to Zsh manually
chsh -s $(which zsh)

# Logout and login for changes to take effect
```

### Railway CLI Not Found

```bash
# Add to PATH manually
export PATH="$HOME/.railway/bin:$PATH"

# Or restart your terminal
```

## Running Individual Scripts

You can run any setup script individually if needed:

```bash
./setup-ssh.sh      # Just setup SSH
./setup-fonts.sh    # Just install fonts
./setup-shell.sh    # Just setup Zsh/Starship
./setup-docker.sh   # Just install Docker
./setup-terraform.sh # Just install Terraform
./setup-railway.sh  # Just install Railway
```

## Uninstallation

To remove installed components:

```bash
# Remove Docker
sudo apt remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker /var/lib/containerd

# Remove Terraform
sudo apt remove terraform

# Remove Starship
rm ~/.local/bin/starship

# Remove Zsh plugins
rm -rf ~/.zsh

# Remove fonts
rm -rf ~/.local/share/fonts/0xProto*
fc-cache -f

# Change shell back to bash
chsh -s /bin/bash
```

## License

Feel free to modify and use these scripts as needed!
