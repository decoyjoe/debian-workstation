#!/bin/bash

bootstrap() {
  echo "Installing git and pipx..."
  sudo apt update && sudo apt install -y git pipx python-is-python3
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
  echo ""

  cd ~/build

  echo "Cloning the debian-workstation repository..."
  git clone https://github.com/decoyjoe/debian-workstation.git
  if [ $? -ne 0 ]; then
      echo "Failed to clone repository."
      exit 1
  fi
  echo ""

  cd debian-workstation

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

  echo "Sourcing ~/.profile to make \"poetry\" available..."
  if [ -f ~/.profile ]; then
      source ~/.profile
  else
      echo "Warning: ~/.profile not found. If pipx binaries are not available, please open a new terminal or source the appropriate profile file manually."
  fi
  echo ""

  echo "Configuring Poetry to create all virtualenv's inside the project root, i.e. \"{project-dir}/.venv\"..."
  poetry config virtualenvs.in-project true

  echo ""
  echo "Bootstrap complete."
  echo ""
  echo "Run ./init.sh to initialize the automation."
  echo ""
}
