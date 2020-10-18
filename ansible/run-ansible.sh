#!/bin/bash
project_dir=$(git rev-parse --show-toplevel)
cd ${project_dir}/ansible

ansible-playbook --inventory-file=${project_dir}/terraform-code/inventory --private-key ~/.ssh/id_home \
  -e rke_ssh_key_location=~/.ssh/id_home \
  -e rke_directory=${project_dir}/rke \
  -e cloudflare_api=${CLOUDFLARE_API} \
  playbooks/site.yml