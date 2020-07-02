#!/bin/bash
project_dir=$(git rev-parse --show-toplevel)
cd ${project_dir}/ansible

ansible-playbook --inventory-file=${project_dir}/terraform-code/inventory --private-key ~/.ssh/id_home playbooks/site.yml