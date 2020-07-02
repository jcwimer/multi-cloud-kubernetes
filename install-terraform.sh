#!/bin/bash
project_dir=$(git rev-parse --show-toplevel)
cd $project_dir

curl -o terraform.zip https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
unzip terraform.zip
rm terraform.zip

#https://github.com/adammck/terraform-inventory/releases
#curl -o terraform-inventory.zip https://github.com/adammck/terraform-inventory/releases/download/v0.9/terraform-inventory_0.9_linux_amd64.zip