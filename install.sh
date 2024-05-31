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
git fetch > /dev/null

local_head=$(git rev-parse HEAD)
remote_head=$(git rev-parse @{u})
base=$(git merge-base HEAD @{u})

if [ "$local_head" = "$remote_head" ]; then
    echo "Local repository is up to date with remote."
else
    if [ "$local_head" = "$base" ]; then
        echo "Update available. Run \"git pull\" to update to the latest version."
    elif [ "$remote_head" = "$base" ]; then
        echo "Local commits detected. You are ahead of the remote. Consider pushing your changes."
    else
        echo "Your local and remote branches have diverged. Consider merging the remote changes."
    fi

    sleep 5s
fi

script_root="$(realpath "$(dirname "$0")")"
sudo $(which poetry) run ansible-playbook "$script_root/workstation.yml" $check_mode
