#!/bin/bash                                                                                         
if ! which docker > /dev/null; then                                                                 
  curl -s -L https://raw.githubusercontent.com/rancher/install-docker/master/19.03.9.sh | bash      
fi 
curl -s https://install.zerotier.com | sudo bash
zerotier-cli join ${zerotier_network}