#!/bin/bash

check_mode=""

usage() {
    cat << EOF
Usage: install.sh [OPTIONS]

Options:
  -C, --check   Run the playbook in check mode (dry run)
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
sudo $(which poetry) run ansible-playbook "$script_root/workstation.yml" $check_mode
