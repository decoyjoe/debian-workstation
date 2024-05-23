#!/bin/bash

poetry install

script_root="$(realpath "$(dirname "$0")")"

# Install necessary collections and roles from the requirements file
poetry run ansible-galaxy install -r "$script_root/requirements.yml" --force

vars_file="$script_root/vars.yml"

if [[ ! -f "$vars_file" ]]; then
    echo "Select the Environment for the workstation (enter the number):"
    options=("Desktop" "CLI")
    select env_option in "${options[@]}"; do
        case $REPLY in
            1) workstation_environment="Desktop"; break;;
            2) workstation_environment="CLI"; break;;
            *) echo "Invalid option, please choose a number from the list."; continue;;
        esac
    done

    cat << EOF > "$vars_file"
---
workstation_environment: $workstation_environment
EOF

    echo "Created $vars_file with workstation_environment set to $workstation_environment."
fi

echo ""
echo "Run install.sh to execute the debian-workstation automation."
echo ""
