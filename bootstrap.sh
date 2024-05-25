#!/bin/bash

bootstrap() {
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

  script_root="$(realpath "$(dirname "$0")")"
  init_sh_path=$(realpath --relative-to="." "${script_root}/init.sh")

  # Ensure the relative path is correctly prefixed
  if [[ "$init_sh_path" != /* && "$init_sh_path" != .* ]]; then
      init_sh_path="./$init_sh_path"
  fi

  echo ""
  echo "Bootstrap complete."
  echo ""
  echo "Run ${init_sh_path} to initialize the automation."
  echo ""
}
