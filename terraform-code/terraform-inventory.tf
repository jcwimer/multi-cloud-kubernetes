resource "local_file" "hosts_cfg" {
  content = templatefile("./hosts.cfg",
    {
      ramnode_workers = "${join("\n", openstack_compute_instance_v2.ramnode-worker.*.network.0.fixed_ip_v4)}"
      ramnode_masters = "${join("\n", openstack_compute_instance_v2.ramnode-master.*.network.0.fixed_ip_v4)}"
      home_workers = "${join("\n", openstack_compute_instance_v2.home-worker.*.network.0.fixed_ip_v4)}"
      home_masters = "${join("\n", openstack_compute_instance_v2.home-master.*.network.0.fixed_ip_v4)}"
      do_workers = "${join("\n", digitalocean_droplet.worker.*.ipv4_address) }"
      do_masters = "${join("\n", digitalocean_droplet.master.*.ipv4_address)}"
    }
  )
  filename = "inventory"
}