#!/bin/bash
# setup-check.sh - Verify Ubuntu setup (like flutter doctor)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Symbols
CHECK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
WARN="${YELLOW}!${NC}"
INFO="${BLUE}ℹ${NC}"

echo "=================================="
echo "Setup Doctor - Verifying Installation"
echo "=================================="
echo ""

ISSUES=0
WARNINGS=0

# Function to check if command exists
check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check file exists
check_file() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

# SSH Setup Check
echo "[SSH Configuration]"
if check_file ~/.ssh/github_ssh; then
    echo -e "$CHECK SSH key exists (~/.ssh/github_ssh)"
    
    # Check if key is added to SSH config
    if check_file ~/.ssh/config && grep -q "github.com" ~/.ssh/config; then
        echo -e "$CHECK SSH config for GitHub exists"
    else
        echo -e "$WARN SSH config for GitHub not found"
        ((WARNINGS++))
    fi
    
    # Check SSH connection to GitHub
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo -e "$CHECK GitHub SSH connection works"
    else
        echo -e "$CROSS GitHub SSH connection failed"
        echo -e "  ${YELLOW}Run: ssh -T git@github.com${NC}"
        echo -e "  ${YELLOW}Make sure you've added the key to GitHub${NC}"
        ((ISSUES++))
    fi
    
    # Check if SSH agent setup is in shell config
    if [ -f ~/.zshrc ] && grep -q "ssh-agent" ~/.zshrc; then
        echo -e "$CHECK SSH agent configured in .zshrc"
    else
        echo -e "$WARN SSH agent not configured in .zshrc"
        ((WARNINGS++))
    fi
else
    echo -e "$CROSS SSH key not found"
    echo -e "  ${YELLOW}Run: ./setup-ssh.sh${NC}"
    ((ISSUES++))
fi
echo ""

# Font Check
echo "[Fonts]"
if fc-list | grep -qi "0xProto"; then
    FONT_COUNT=$(fc-list | grep -i "0xProto" | wc -l)
    echo -e "$CHECK 0xProto Nerd Font installed ($FONT_COUNT variants)"
    
    # Check if font is being used (basic heuristic)
    echo -e "$INFO Remember to set '0xProto Nerd Font' in your terminal settings"
else
    echo -e "$CROSS 0xProto Nerd Font not found"
    echo -e "  ${YELLOW}Run: ./setup-fonts.sh${NC}"
    ((ISSUES++))
fi
echo ""

# Shell Check
echo "[Shell Configuration]"
if check_command zsh; then
    ZSH_VERSION_NUM=$(zsh --version | awk '{print $2}')
    echo -e "$CHECK Zsh installed (version $ZSH_VERSION_NUM)"
    
    # Check if Zsh is default shell
    if [ "$SHELL" = "$(which zsh)" ]; then
        echo -e "$CHECK Zsh is default shell"
    else
        echo -e "$WARN Zsh is not default shell (current: $SHELL)"
        echo -e "  ${YELLOW}Run: chsh -s \$(which zsh)${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "$CROSS Zsh not installed"
    ((ISSUES++))
fi

if check_command starship; then
    STARSHIP_VERSION=$(starship --version | awk '{print $2}')
    echo -e "$CHECK Starship installed (version $STARSHIP_VERSION)"
else
    echo -e "$CROSS Starship not installed"
    ((ISSUES++))
fi

if [ -d ~/.zsh/zsh-autosuggestions ]; then
    echo -e "$CHECK zsh-autosuggestions installed"
else
    echo -e "$CROSS zsh-autosuggestions not found"
    ((ISSUES++))
fi

if [ -d ~/.zsh/zsh-syntax-highlighting ]; then
    echo -e "$CHECK zsh-syntax-highlighting installed"
else
    echo -e "$CROSS zsh-syntax-highlighting not found"
    ((ISSUES++))
fi

if check_file ~/.zshrc; then
    echo -e "$CHECK .zshrc exists"
else
    echo -e "$CROSS .zshrc not found"
    echo -e "  ${YELLOW}Run: ./setup-shell.sh${NC}"
    ((ISSUES++))
fi
echo ""

# Docker Check
echo "[Docker]"
if check_command docker; then
    DOCKER_VERSION=$(docker --version | awk '{print $3}' | tr -d ',')
    echo -e "$CHECK Docker installed (version $DOCKER_VERSION)"
    
    # Check if Docker daemon is running
    if docker ps &> /dev/null; then
        echo -e "$CHECK Docker daemon is running"
        
        # Check if user can run docker without sudo
        if docker ps &> /dev/null; then
            echo -e "$CHECK Docker works without sudo"
        else
            echo -e "$WARN Cannot run Docker without sudo"
            echo -e "  ${YELLOW}Run: newgrp docker${NC}"
            echo -e "  ${YELLOW}Or logout and login again${NC}"
            ((WARNINGS++))
        fi
    else
        echo -e "$CROSS Docker daemon is not running"
        echo -e "  ${YELLOW}Run: sudo systemctl start docker${NC}"
        ((ISSUES++))
    fi
    
    # Check if user is in docker group
    if groups | grep -q docker; then
        echo -e "$CHECK User is in docker group"
    else
        echo -e "$WARN User is not in docker group"
        echo -e "  ${YELLOW}Run: sudo usermod -aG docker \$USER${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "$CROSS Docker not installed"
    echo -e "  ${YELLOW}Run: ./setup-docker.sh${NC}"
    ((ISSUES++))
fi

if check_command docker && docker compose version &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version | awk '{print $4}' | tr -d 'v')
    echo -e "$CHECK Docker Compose installed (version $COMPOSE_VERSION)"
else
    echo -e "$CROSS Docker Compose not installed"
    ((ISSUES++))
fi
echo ""

# Terraform Check
echo "[Terraform]"
if check_command terraform; then
    TERRAFORM_VERSION=$(terraform version | head -n1 | awk '{print $2}' | tr -d 'v')
    echo -e "$CHECK Terraform installed (version $TERRAFORM_VERSION)"
else
    echo -e "$CROSS Terraform not installed"
    echo -e "  ${YELLOW}Run: ./setup-terraform.sh${NC}"
    ((ISSUES++))
fi
echo ""

# Railway Check
echo "[Railway]"
if check_command railway; then
    echo -e "$CHECK Railway CLI installed"
    
    # Check if user is logged in (this might fail if not logged in, which is fine)
    if railway whoami &> /dev/null; then
        RAILWAY_USER=$(railway whoami 2>/dev/null | head -n1)
        echo -e "$CHECK Railway authenticated (user: $RAILWAY_USER)"
    else
        echo -e "$INFO Railway not authenticated"
        echo -e "  ${BLUE}Run: railway login${NC}"
    fi
else
    echo -e "$CROSS Railway CLI not installed"
    echo -e "  ${YELLOW}Run: ./setup-railway.sh${NC}"
    ((ISSUES++))
fi
echo ""

# Git Configuration Check
echo "[Git Configuration]"
if check_command git; then
    echo -e "$CHECK Git installed (version $(git --version | awk '{print $3}'))"
    
    GIT_NAME=$(git config --global user.name 2>/dev/null)
    GIT_EMAIL=$(git config --global user.email 2>/dev/null)
    
    if [ -n "$GIT_NAME" ]; then
        echo -e "$CHECK Git user.name set: $GIT_NAME"
    else
        echo -e "$WARN Git user.name not set"
        echo -e "  ${YELLOW}Run: git config --global user.name \"Your Name\"${NC}"
        ((WARNINGS++))
    fi
    
    if [ -n "$GIT_EMAIL" ]; then
        echo -e "$CHECK Git user.email set: $GIT_EMAIL"
    else
        echo -e "$WARN Git user.email not set"
        echo -e "  ${YELLOW}Run: git config --global user.email \"you@example.com\"${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "$INFO Git not installed (usually pre-installed)"
fi
echo ""

# Environment Check
echo "[Environment]"
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo -e "$INFO Running on WSL"
    
    # Check for clip.exe (WSL clipboard)
    if check_command clip.exe; then
        echo -e "$CHECK WSL clipboard (clip.exe) available"
    else
        echo -e "$WARN WSL clipboard not available"
        ((WARNINGS++))
    fi
else
    echo -e "$INFO Running on native Linux"
    
    # Check for xclip (Linux clipboard)
    if check_command xclip; then
        echo -e "$CHECK xclip installed for clipboard support"
    else
        echo -e "$WARN xclip not installed"
        echo -e "  ${YELLOW}Run: sudo apt install xclip${NC}"
        ((WARNINGS++))
    fi
fi

# Check if running in Zsh
if [ -n "$ZSH_VERSION" ]; then
    echo -e "$CHECK Currently running in Zsh"
else
    echo -e "$INFO Currently running in ${SHELL##*/}"
    echo -e "  ${BLUE}Run 'zsh' to switch to Zsh${NC}"
fi
echo ""

# Summary
echo "=================================="
echo "Summary"
echo "=================================="

if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ Everything looks good! No issues found.${NC}"
elif [ $ISSUES -eq 0 ]; then
    echo -e "${YELLOW}! $WARNINGS warning(s) found, but all critical components are working.${NC}"
else
    echo -e "${RED}✗ $ISSUES issue(s) found that need attention.${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}! $WARNINGS warning(s) also found.${NC}"
    fi
fi

echo ""
echo "Legend:"
echo -e "  $CHECK = Working correctly"
echo -e "  $CROSS = Needs attention"
echo -e "  $WARN = Optional/Warning"
echo -e "  $INFO = Information"
echo ""

exit $ISSUES
