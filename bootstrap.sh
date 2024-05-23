#!/bin/bash

echo "Installing git and pipx..."
sudo apt update && sudo apt install -y git pipx
if [ $? -ne 0 ]; then
    echo "Failed to install packages."
    exit 1
fi

echo ""
echo "Creating build directory..."
mkdir -p ~/build
if [ $? -ne 0 ]; then
    echo "Failed to create build directory."
    exit 1
fi

cd ~/build

echo ""
echo "Cloning the debian-workstation repository..."
git clone https://github.com/decoyjoe/debian-workstation.git
if [ $? -ne 0 ]; then
    echo "Failed to clone repository."
    exit 1
fi

cd debian-workstation

echo ""
echo "Setting up pipx and installing poetry..."
pipx ensurepath
if [ $? -ne 0 ]; then
    echo "Failed to set up pipx path."
    exit 1
fi

pipx install poetry
if [ $? -ne 0 ]; then
    echo "Failed to install poetry."
    exit 1
fi

echo ""
echo "Sourcing .bash_profile to make poetry available..."
if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
else
    echo "Warning: .bash_profile not found. If pipx binaries are not available, please open a new terminal or source the appropriate profile file manually."
fi

echo ""
echo "Bootstrap complete."
echo ""
echo "Run $(realpath ~/build/debian-workstation/init.sh) to initialize the automation."
echo ""
