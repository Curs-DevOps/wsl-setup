#!/bin/bash
# setup-fonts.sh - Install 0xProto Nerd Font

set -e

echo "=================================="
echo "Installing 0xProto Nerd Font"
echo "=================================="

if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "⚠ WSL detected!"
    echo ""
    echo "Fonts need to be installed on Windows, not in WSL."
    echo ""
    echo "Please follow these steps:"
    echo ""
    echo "1. Download the font from:"
    echo "   https://github.com/ryanoasis/nerd-fonts/releases/latest/download/0xProto.zip"
    echo ""
    echo "2. Extract the ZIP file"
    echo ""
    echo "3. Select all .ttf files, right-click, and choose 'Install' or 'Install for all users'"
    echo ""
    echo "4. Restart Windows Terminal"
    echo ""
    echo "5. In Windows Terminal settings:"
    echo "   - Go to your Ubuntu profile"
    echo "   - Appearance → Font face"
    echo "   - Select '0xProto Nerd Font' or '0xProto Nerd Font Mono'"
    echo ""
    echo "Alternative: Use PowerShell to install (run as Administrator):"
    echo ""
    echo '  Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/0xProto.zip" -OutFile "$env:TEMP\0xProto.zip"'
    echo '  Expand-Archive -Path "$env:TEMP\0xProto.zip" -DestinationPath "$env:TEMP\0xProto" -Force'
    echo '  $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)'
    echo '  Get-ChildItem "$env:TEMP\0xProto\*.ttf" | ForEach-Object { $fonts.CopyHere($_.FullName) }'
    echo '  Remove-Item "$env:TEMP\0xProto.zip"'
    echo '  Remove-Item "$env:TEMP\0xProto" -Recurse'
    echo ""
    echo "⚠ Skipping font installation in WSL (not applicable)"
    exit 0
fi

FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="0xProto"
TEMP_DIR=$(mktemp -d)

mkdir -p "$FONT_DIR"

# Install unzip if not present
if ! command -v unzip &> /dev/null; then
    echo "Installing unzip..."
    sudo apt install -y unzip
fi

# Install wget if not present
if ! command -v wget &> /dev/null; then
    echo "Installing wget..."
    sudo apt install -y wget
fi

echo "Downloading 0xProto Nerd Font..."
cd "$TEMP_DIR"
wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/0xProto.zip

echo "Extracting fonts..."
unzip -q 0xProto.zip -d 0xProto

echo "Installing fonts..."
cp 0xProto/*.ttf "$FONT_DIR/"

echo "Updating font cache..."
fc-cache -f "$FONT_DIR"

# Cleanup
rm -rf "$TEMP_DIR"

echo "✓ 0xProto Nerd Font installed"
echo ""
echo "To use the font in your terminal:"
echo "  Set your terminal font to '0xProto Nerd Font'"

