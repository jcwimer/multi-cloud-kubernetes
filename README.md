# multi-cloud-kubernetes
This is example code for how I deploy a cross cloud Kubernetes cluster to my home openstack, ramnode openstack, and digital ocean.

# Run
### Set ENVS on test.env
1. DIGITALOCEAN_ACCESS_TOKEN - api token to interact with Digital Ocean. Used by `terraform-code/digitalocean.tf`
2. RAMNODE_USERNAME - ramnode openstack username. Used by `terraform-code/ramnode.tf`
3. RAMNODE_PASSWORD - ramnode openstack password. Used by `terraform-code/ramnode.tf`
4. HOME_USERNAME - home openstack username. Used by `terraform-code/home.tf`
5. HOME_PASSWORD - home openstack password. Used by `terraform-code/home.tf`
6. ZEROTIER_NETWORK - zerotier network id. Used by `terraform-code/user-data.sh`
7. CLOUDFLARE_API - cloudflare api token. Used by `ansible/roles/kubernetes/templates/cloudflare-updater.yaml` to be passed to the cloudflare updater pod.
8. LONGHORN_USERNAME - any username you want to use for basic auth http for longhorn. Used by `ansible/roles/longhorn/templates/longhorn-ingress.yaml`. Basic auth created by `bin/longhorn-basic-auth.sh`
9. LONGHORN_PASSWORD - any password you want to use for basic auth http for longhorn. Used by `ansible/roles/longhorn/templates/longhorn-ingress.yaml`. Basic auth created by `bin/longhorn-basic-auth.sh`

Then run `source test.env`

### NOTES 
1. My personal domain (codywimer.com) is hard coded throughout this project. If replicating, you'll have to change this.
2. My home openstack cloud and ramnodes openstack envs are hard coded in `terraform-code/home.tf` and `terraform-code/ramnode.tf`

### Deploy
`make deploy`

This will take your ENV's, pass them to terraform and ansible (see `bin/deploy.sh`) and do the following:
1. Install terraform in this repo
2. Run terraform to deploy cloud resources. Instances will be pre-configured via `terraform-code/user-data.sh` and use a Debian 10 cloud image.
3. Terraform will ouput an ansible inventory to `hosts.cfg`
4. Ansible will be run to deploy Kubernetes via RKE. It will create the `rke` directory where you will find `rke/kube_config_rke-k8s.yaml` to run `kubectl` commands after Kubernetes is deployed.

### Deploy Notes
1. The `rke` directory contains your kube config file as stated above, a state file rke uses when configuring, `rke/rke-k8s.yaml` which is the rke cluster config, `rke/auth` which is the Kubernetes secret for http basic auth for Longhorn, the `rke/configs` directory which has default resources deployed into Kubernetes, and the `rke/lonhorn` directory which has the Longhorn configs.
2. The Terraform state file is located at `terraform-code/terraform.tfstate`

### Destroy
`make destroy`