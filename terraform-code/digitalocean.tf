data "digitalocean_ssh_key" "multicloud" {
  provider = digitalocean.digitalocean
  name = "multicloud"
}

resource "digitalocean_tag" "master" {
  name = "multicloud-k8s-master"
}

resource "digitalocean_tag" "worker" {
  name = "multicloud-k8s-worker"
}

resource "digitalocean_droplet" "master" {
	provider = digitalocean.digitalocean
	image = "ubuntu-20-04-x64"
	name = "multicloud-digitalocean-master"
	region = "nyc1"
	size = "s-1vcpu-2gb"
	count = 1
	user_data = data.template_file.user-data.rendered
	tags = [digitalocean_tag.master.id]
	ssh_keys = [data.digitalocean_ssh_key.multicloud.id]
}

resource "digitalocean_droplet" "worker" {
	provider = digitalocean.digitalocean
	image = "ubuntu-20-04-x64"
	name = "multicloud-digitalocean-worker"
	region = "nyc1"
	size = "s-1vcpu-2gb"
	count = 1
	user_data = data.template_file.user-data.rendered
	tags = [digitalocean_tag.worker.id]
	ssh_keys = [data.digitalocean_ssh_key.multicloud.id]
}