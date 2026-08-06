variable "userctn" { default = "spike" }
variable "publkeyctn" {}
variable "privkeyctn" {}
variable "token" {}
variable "token_id" {}
variable "fqdn_pmox" {}
variable "bridge" { default = "vmbr3" }

variable "proxy" { default = "" }
variable "noproxy" { default = "127.0.0.1,localhost,10.0.0.0/8,10.42.0.0/16,10.43.0.0/16" }
variable "nameserver" { default = "192.168.68.1" }

variable "cloudinit" { default = "local" }
variable "target_node" { default = "proxmox" }
variable "storage" { default = "local-lvm" }

variable "prefix" { default = "192.188.200" }
variable "adminip" { default = "10.9.0.30" }

variable "vlan" { default = 200 }

variable "kafka" {
  type = map(object({
    name    = string
    octet   = number
    memory  = number
    cores   = number
    sockets = number
  }))
  default = {
    server = {
      name    = "kafa"
      octet   = 101
      memory  = 4096
      cores   = 2
      sockets = 1
    }
  }
}

variable "ldes" {
  type = map(object({
    name    = string
    octet   = number
    memory  = number
    cores   = number
    sockets = number
  }))
  default = {
    server = {
      name    = "ldes"
      octet   = 102
      memory  = 4096
      cores   = 2
      sockets = 1
    }
  }
}
