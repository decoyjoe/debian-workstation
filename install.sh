#!/bin/bash

check_mode=""

if [[ ! -z $1 ]]; then
    if [[ $1 == "--check" ]]; then
        check_mode=$1
    else
        echo "Usage: install.sh [--check]"
        exit 1
    fi
fi

script_root="$(realpath "${0}" | xargs dirname)"
ansible-playbook "$script_root/workstation.yml" --ask-become-pass $check_mode
