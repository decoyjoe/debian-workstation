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

# Fetch latest changes from the remote repository
git fetch

# Compare local HEAD against remote HEAD
local_head=$(git rev-parse HEAD)
remote_head=$(git rev-parse @{u})

if [ "$local_head" != "$remote_head" ]; then
    echo "Update available. Run \"git pull\" to update to the latest version."
    echo ""
    sleep 5s
fi

script_root="$(realpath "$(dirname "$0")")"
sudo $(which poetry) run ansible-playbook "$script_root/workstation.yml" $check_mode
