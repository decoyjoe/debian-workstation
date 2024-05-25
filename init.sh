#!/bin/bash

script_root="$(realpath "$(dirname "$0")")"
pushd $script_root > /dev/null

poetry install

# Install necessary collections and roles from the requirements file
poetry run ansible-galaxy install -r "${script_root}/requirements.yml" --force

popd > /dev/null

vars_file="${script_root}/vars.yml"

if [[ ! -f "${vars_file}" ]]; then
    echo "Select the Environment for the workstation (enter the number):"
    options=("Desktop" "CLI")
    select env_option in "${options[@]}"; do
        case $REPLY in
            1) workstation_environment="Desktop"; break;;
            2) workstation_environment="CLI"; break;;
            *) echo "Invalid option, please choose a number from the list."; continue;;
        esac
    done

    current_hostname=$(hostname)
    read -p "System hostname [$current_hostname]: " workstation_hostname
    workstation_hostname=${workstation_hostname:-$current_hostname}

    cat << EOF > "${vars_file}"
---
workstation_environment: ${workstation_environment}
workstation_hostname: ${workstation_hostname}
EOF

    echo "Created ${vars_file} with workstation_environment set to \"${workstation_environment}\" and hostname set to \"${workstation_hostname}\"."
else
    echo "$(realpath ${vars_file}) already exists. Please update it manually if necessary."
fi

install_sh_path=$(realpath --relative-to="." "${script_root}/install.sh")

# Ensure the relative path is correctly prefixed
if [[ "$install_sh_path" != /* && "$install_sh_path" != .* ]]; then
    install_sh_path="./$install_sh_path"
fi

echo ""
echo "Run ${install_sh_path} to execute the debian-workstation automation."
echo ""
