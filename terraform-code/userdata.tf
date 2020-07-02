variable "zerotier_network" {}

data "template_file" "user-data" {                                                          
  template = file("./user-data.sh")
  vars = {
    zerotier_network = var.zerotier_network
  }                                                        
}