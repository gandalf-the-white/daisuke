####################################################################################
## K A F K A
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
## P O S T G R E S   S E R V E R
####################################################################################

module "postgres" {
  source      = "./modules/postgres/"
  server      = var.postgres
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
## L D E S   S E R V E R
####################################################################################

module "ldes" {
  source      = "./modules/ldes"
  server      = var.ldes
  prefix      = var.prefix # VLAN 200
  bridge      = var.bridge
  vlan        = var.vlan
  nameserver  = var.nameserver
  target_node = var.target_node
  clone       = "freebsd-150-tmpl"
  postgres    = var.postgres["server"].octet
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

output "postgres_server_ip_address" {
  description = "PostgreSQL Server IP Address"
  value       = module.postgres
}

output "ldes_server_ip_address" {
  description = "LDSES Server IP Address"
  value       = module.ldes
}
