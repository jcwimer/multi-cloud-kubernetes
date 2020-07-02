resource "openstack_compute_secgroup_v2" "multicloud_home" {
  provider = openstack.home
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

data "openstack_images_image_v2" "ubuntu" {
  provider = openstack.home
  name        = "xenial-image"
  most_recent = true
}

resource "openstack_compute_instance_v2" "home-master" {
  provider = openstack.home
  name = "multicloud-home-master"
  flavor_name = "g1.medium"
  key_pair = "multicloud"
  security_groups = [openstack_compute_secgroup_v2.multicloud_home.name]
  image_name = "xenial-image"
  user_data = data.template_file.user-data.rendered
  network {
    name = "GATEWAY_NET"
  }
  metadata = {
    cloud = "home"
    role = "multicloud-k8s-master"
  }
  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = 20
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }
  count = 1
}

resource "openstack_compute_instance_v2" "home-worker" {
  provider = openstack.home
  name = "multicloud-home-worker"
  flavor_name = "g1.medium"
  key_pair = "multicloud"
  security_groups = [openstack_compute_secgroup_v2.multicloud_home.name]
  user_data = data.template_file.user-data.rendered
  network {
    name = "GATEWAY_NET"
  }
  metadata = {
    cloud = "home"
    role = "multicloud-k8s-worker"
  }
  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = 20
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }
  count = 1
}