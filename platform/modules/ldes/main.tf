####################################################################################
##  RESOURCES
####################################################################################

resource "proxmox_vm_qemu" "server" {
  description = "Deploiement BSD VM on Proxmox"
  name        = var.server["server"].name
  target_node = var.target_node
  clone       = var.clone

  os_type  = "cloud-init"
  memory   = var.server["server"].memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  agent    = 1

  cpu {
    type    = "host"
    cores   = var.server["server"].cores
    sockets = var.server["server"].sockets
  }

  tags = "Bsd;Ldes"

  cicustom = "user=${var.cloudinit}:snippets/cloudinitbsd.yaml"

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.size
          storage = var.storage
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
    tag    = var.vlan
  }

  ipconfig0  = "ip=${var.prefix}.${var.server["server"].octet}/24,gw=${var.prefix}.1"
  nameserver = var.nameserver

  provisioner "remote-exec" {
    inline = ["echo 'Wait until ssh is ready'"]

    connection {
      host        = "${var.prefix}.${var.server["server"].octet}"
      type        = "ssh"
      user        = var.userctn
      private_key = file(var.privkeyctn)
    }
  }
}

####################################################################################
##  ANSIBLE
####################################################################################

resource "local_file" "inventory" {
  content = templatefile("${path.module}/manifests/inventory-template.yaml",
    {
      ipaddress  = "${var.prefix}.${var.server["server"].octet}"
      userctn    = var.userctn
      privkeyctn = var.privkeyctn
  name = var.server["server"].name })

  filename        = "./ansible/inventory-ldes.yaml"
  file_permission = "0644"
}


resource "local_file" "playbook" {
  content = templatefile("${path.module}/manifests/playbook-template.yaml",
    {
      hostname = var.server["server"].name
      prefix   = "${var.prefix}"
      admin-ip = "${var.adminip}"
      postgres = "${var.postgres}"
      proxy    = var.proxy
      noproxy  = "${var.prefix}.0/24"
  })
  filename        = "./ansible/playbook-ldes.yaml"
  file_permission = "0644"
}

resource "null_resource" "play_ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory-ldes.yaml ansible/playbook-ldes.yaml"
  }
  depends_on = [
    proxmox_vm_qemu.server,
    local_file.inventory,
    local_file.playbook
  ]
}

####################################################################################
##  OUTPUT
####################################################################################

output "ldes_server_ip_address" {
  description = "LDES IP Address"
  value       = proxmox_vm_qemu.server.default_ipv4_address
}
