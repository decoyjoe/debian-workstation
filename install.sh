#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Please use sudo."
   exit 1
fi

check_mode=""

usage() {
    cat << EOF
Usage: install.sh [OPTIONS]

Options:
  -C, --check   Run the playbook in check mode (dry run)

This script installs the workstation configuration using Ansible.
It must be run with root privileges (e.g., using sudo).
EOF
    exit 1
}

# Check for --check or -C option
if [[ -n $1 ]]; then
    case $1 in
        -C|--check)
            check_mode="--check"
            ;;
        *)
            usage
            ;;
    esac
fi

script_root="$(realpath "$(dirname "$0")")"
ansible-playbook "$script_root/workstation.yml" $check_mode
