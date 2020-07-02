variable "do_token" {}
variable "ramnode_password" {}
variable "ramnode_username" {}
variable "home_password" {}
variable "home_username" {}

provider "digitalocean" {
	token = var.do_token
	alias = "digitalocean"
}

provider "openstack" {
	alias = "ramnode"
	user_name = var.ramnode_username
	tenant_id = "e55c0b4382f14a4fb0cd10d76f58881f"
	password = var.ramnode_password
	auth_url = "https://nyc-controller.ramnode.com:5000/v3"
	region = "NYC"
}

provider "openstack" {
	alias = "home"
	user_name = var.home_username
	tenant_id = "a5c2f0b1bb954c96ad054ae2c586d9c1"
	password = var.home_password
	auth_url = "http://10.0.0.108:35357/v3"
	region = "RegionOne"
}