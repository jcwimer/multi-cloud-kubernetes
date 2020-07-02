#!/bin/bash
project_dir=$(git rev-parse --show-toplevel)

cd  ${project_dir}/terraform-code

${project_dir}/terraform destroy -force \
  -var "zerotier_network=${ZEROTIER_NETWORK}" \
  -var "home_username=${HOME_USERNAME}" \
  -var "home_password=${HOME_PASSWORD}" \
  -var "ramnode_username=${RAMNODE_USERNAME}" \
  -var "ramnode_password=${RAMNODE_PASSWORD}" \
  -var "do_token=${DIGITALOCEAN_ACCESS_TOKEN}"