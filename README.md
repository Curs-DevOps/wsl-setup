# Setup Guide

This guide outlines the steps to set up your development environment using the provided scripts.

## Table of Contents

- [Before You Begin](#before-you-begin)
- [Usage](#usage)
- [Individual Setup Scripts](#individual-setup-scripts)
- [Clearing Your Setup](#clearing-your-setup)

## Before You Begin

Before running the setup scripts, ensure you have:

1.  **Docker Hub Login:** If you plan to use Docker, ensure you are logged into Docker Hub.
    ```bash
    docker login
    ```
2.  **Railway Login:** If you plan to use Railway, ensure you are logged into Railway CLI.
    ```bash
    railway login
    ```
3.  **Terminal Font Setup:** Review `setup-fonts.sh` and ensure any necessary fonts are installed for your terminal emulator. You may need to manually configure your terminal to use the desired font after installation.

## Usage

To run the main setup script, execute:

```bash
./main.sh
```

This script will orchestrate the execution of other setup scripts.

## Individual Setup Scripts

You can also run individual setup scripts as needed:

*   `./setup-check.sh`: Checks for prerequisites.
*   `./setup-docker.sh`: Sets up Docker.
*   `./setup-fonts.sh`: Installs fonts.
*   `./setup-railway.sh`: Sets up Railway CLI.
*   `./setup-shell.sh`: Configures your shell.
*   `./setup-ssh.sh`: Sets up SSH.
*   `./setup-terraform.sh`: Sets up Terraform.

## Clearing Your Setup

To clear parts of your setup, you might need to:

*   **Docker:** Remove Docker images, containers, or volumes. Use `docker system prune` with caution.
*   **Fonts:** Manually uninstall fonts installed by `setup-fonts.sh`.
*   **Railway:** Log out from Railway CLI or remove Railway-related configuration files.
*   **Shell/SSH/Terraform:** Revert changes made by the respective setup scripts, which may involve editing dotfiles (e.g., `.bashrc`, `.zshrc`, `~/.ssh/config`) or removing installed tools/plugins.