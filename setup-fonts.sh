#!/bin/bash
# setup-fonts.sh - Install 0xProto Nerd Font

set -e

echo "=================================="
echo "Installing 0xProto Nerd Font"
echo "=================================="

FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="0xProto"
TEMP_DIR=$(mktemp -d)

mkdir -p "$FONT_DIR"

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

