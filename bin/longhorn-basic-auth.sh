#!/bin/bash
project_dir=$(git rev-parse --show-toplevel)

cd  ${project_dir}

mkdir -p ${project_dir}/rke
USER=$LONGHORN_USERNAME; PASSWORD=$LONGHORN_PASSWORD; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> ${project_dir}rke/auth