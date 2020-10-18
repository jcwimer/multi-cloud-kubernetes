#!/bin/bash
apt-get update                                                  
apt-get install python-dev python-pip curl sudo open-iscsi -y

# Disable ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

cat <<EOF > /etc/sysctl.d/ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

# enable tun module
modprobe tun
cat <<EOF > /etc/modules-load.d/tun.conf
tun
EOF

service networking restart

# force zerotier to ignore kubernetes interfaces when it's looking for a gateway
mkdir -p /var/lib/zerotier-one
cat <<EOF > /var/lib/zerotier-one/local.conf
{
  "settings": {
    "interfacePrefixBlacklist": [ "flannel", "veth", "cni", "docker" ],
    "allowTcpFallbackRelay": false
  }
}
EOF

curl -s https://install.zerotier.com | bash
zerotier-cli join ${zerotier_network}

if ! which docker > /dev/null; then                                                                 
  curl -s -L https://raw.githubusercontent.com/rancher/install-docker/master/19.03.9.sh | bash      
fi 

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

mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
  "dns": ["1.1.1.1", "8.8.4.4"]
}
EOF

service docker restart