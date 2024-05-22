#!/bin/bash

script_root="$(realpath "${0}" | xargs dirname)"
ansible-galaxy install -r "$script_root/requirements.yml" --force
