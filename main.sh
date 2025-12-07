#!/bin/bash
# main.sh - Main setup script for Ubuntu 24.04

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DONE_FILE="$SCRIPT_DIR/done.txt"

echo "=================================="
echo "Ubuntu 24.04 Setup Script"
echo "=================================="

# Function to check if a step is done
is_done() {
    grep -q "^$1$" "$DONE_FILE" 2>/dev/null
}

# Function to mark a step as done
mark_done() {
    echo "$1" >> "$DONE_FILE"
}

# Function to run a setup script if not done
run_setup() {
    local step_name="$1"
    local script_name="$2"
    
    if is_done "$step_name"; then
        echo "⊘ Skipping $step_name (already done)"
    else
        echo "→ Running $step_name..."
        if bash "$SCRIPT_DIR/$script_name"; then
            mark_done "$step_name"
            echo "✓ $step_name completed"
        else
            echo "✗ $step_name failed"
            exit 1
        fi
    fi
    echo ""
}

# Create done.txt if it doesn't exist
touch "$DONE_FILE"

# Update system (only if not done before)
if is_done "system-update"; then
    echo "⊘ Skipping system update (already done)"
else
    echo "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    mark_done "system-update"
    echo "✓ System update completed"
fi
echo ""

# Run individual setup scripts
echo "Running individual setup scripts..."
echo ""

run_setup "setup-ssh" "setup-ssh.sh"
run_setup "setup-fonts" "setup-fonts.sh"
run_setup "setup-shell" "setup-shell.sh"
run_setup "setup-docker" "setup-docker.sh"
run_setup "setup-terraform" "setup-terraform.sh"
run_setup "setup-railway" "setup-railway.sh"

echo "=================================="
echo "Setup complete!"
echo "=================================="
echo ""
echo "NEXT STEPS:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Run ./setup-check.sh"
echo "3. Configure your terminal font to '0xProto Nerd Font'"
echo "4. Login to Railway: railway login"
echo "5. (Optional) Login to Docker Hub: docker login"
echo ""
echo "Run './setup-check.sh' anytime to verify your setup!"
echo "Run 'rm done.txt' to reset and run all steps again"
echo "See README.md for detailed post-installation steps!"

