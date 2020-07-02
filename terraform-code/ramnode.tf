resource "openstack_compute_secgroup_v2" "multicloud_ramnode" {
  provider = openstack.ramnode
  name        = "multicloud"
  description = "multicloud security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "ramnode-master" {
  provider = openstack.ramnode
  name = "multicloud-ramnode-master"
  flavor_name = "2GB SKVM"
  key_pair = "multicloud"
  security_groups = [openstack_compute_secgroup_v2.multicloud_ramnode.name]
  image_name = "Ubuntu 20.04 Server Cloud"
  user_data = data.template_file.user-data.rendered
  network {
    name = "Public"
  }
  metadata = {
    cloud = "ramnode"
    role = "multicloud-k8s-master"
  }
  count = 1
}

resource "openstack_compute_instance_v2" "ramnode-worker" {
  provider = openstack.ramnode
  name = "multicloud-ramnode-worker"
  flavor_name = "2GB SKVM"
  key_pair = "multicloud"
  security_groups = [openstack_compute_secgroup_v2.multicloud_ramnode.name]
  image_name = "Ubuntu 20.04 Server Cloud"
  user_data = data.template_file.user-data.rendered
  network {
    name = "Public"
  }
  metadata = {
    cloud = "ramnode"
    role = "multicloud-k8s-worker"
  }
  count = 1
}