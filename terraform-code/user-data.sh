#!/bin/bash
apt-get update                                                  
apt-get install python-dev python-pip curl sudo -y

if ! which docker > /dev/null; then                                                                 
  curl -s -L https://raw.githubusercontent.com/rancher/install-docker/master/19.03.9.sh | bash      
fi 

curl -s https://install.zerotier.com | bash
zerotier-cli join ${zerotier_network}
user=debian
if ! cat /etc/passwd | grep debian; then
  # Add the user (--gecos "" ensures that this runs non-interactively)
  adduser --disabled-password --gecos "" $user

  # Give read-only access to log files by adding the user to adm group
  # Other groups that you may want to add are apache, nginx, mysql etc. for their log files
  usermod -a -G adm $user

  # Give sudo access by adding the user to sudo group
  usermod -a -G sudo $user
  # Allow passwordless sudo
  echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$user

  # Add the user's auth key to allow ssh access
  mkdir /home/$user/.ssh
  cp /root/.ssh/authorized_keys /home/$user/.ssh/authorized_keys

  # Change ownership and access modes for the new directory/file
  chown -R $user:$user /home/$user/.ssh
  chmod -R go-rx /home/$user/.ssh
fi
usermod -a -G docker $user

# for RKE
# iptables -I INPUT -j ACCEPT