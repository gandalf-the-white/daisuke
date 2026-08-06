####################################################################################
## C L U S T E R S
####################################################################################

module "kafka" {
  source      = "./modules/kafka"
  server      = var.kafka
  prefix      = var.prefix # VLAN 200
  bridge      = var.bridge
  vlan        = var.vlan
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "freebsd-150-tmpl"
  size        = 30
  storage     = var.storage
  cloudinit   = var.cloudinit
  proxy       = var.proxy
  noproxy     = var.noproxy
  userctn     = var.userctn
  publkeyctn  = var.publkeyctn
  privkeyctn  = var.privkeyctn
  adminip     = var.adminip
}

####################################################################################
## O U T P U T
####################################################################################

output "kafa_server_ip_address" {
  description = "Kafka Server IP Address"
  value       = module.kafka
}

