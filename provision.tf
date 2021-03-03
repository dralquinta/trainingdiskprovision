/* provision.tf
Author: DALQUINT - denny.alquinta@oracle.com
Purpose: The following script triggers the iscsi mount and then disk tagging using pvcreate and vgcreate commands
Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved. 
*/

# TODO this force should be removed #
# locals {
#   timestamp = timestamp()
# }

#Create Disk Attachment
resource "null_resource" "provisioning_disk" {
  count = length(var.volume_attachment)

  # TODO this force should be removed #
  #  triggers = {
  #   timestamp = local.timestamp
  # } 

  connection {
    type        = "ssh"
    host        = var.linux_compute_private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  # register and connect the iSCSI block volume
  
  provisioner "remote-exec" {
    
    inline = [
      "set +x",
      /*       "echo ${var.volume_attachment[count.index].id}",
      "echo ${var.volume_attachment[count.index].iqn}",
      "echo ${var.volume_attachment[count.index].ipv4}",
      "echo ${var.volume_attachment[count.index].port}",
      "echo ${var.volume_attachment[count.index].device}",
      "echo ${var.volume_attachment[count.index].state}",
      "echo ${var.provisioning_display_name}_${count.index}", */


      "${local.iscsiadm} -m node -o new -T ${var.volume_attachment[count.index].iqn} -p ${var.volume_attachment[count.index].ipv4}:${var.volume_attachment[count.index].port}",
      "${local.iscsiadm} -m node -o update -T ${var.volume_attachment[count.index].iqn} -n node.startup -v automatic",
      "${local.iscsiadm} -m node -T ${var.volume_attachment[count.index].iqn} -p ${var.volume_attachment[count.index].ipv4}:${var.volume_attachment[count.index].port} -l",
    ]
  }
}


resource "null_resource" "partition_disk" {
  depends_on = [null_resource.provisioning_disk]
  count      = length(var.volume_attachment)
  connection {
    type        = "ssh"
    host        = var.linux_compute_private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  # With provisioned disk, trigger fdisk, then pvcreate and vgcreate to tag the disk
  provisioner "remote-exec" {
   inline = [
      "set +x",
      "export DEVICE_ID=/dev/disk/by-path/ip-${var.volume_attachment[count.index].ipv4}:${var.volume_attachment[count.index].port}-iscsi-${var.volume_attachment[count.index].iqn}-lun-1",
      "${local.fdisk} $${DEVICE_ID}",
    ]
  }
}


resource "null_resource" "pvcreate_exec" {
  depends_on = [null_resource.partition_disk]
  count      = length(var.volume_attachment)
  connection {
    type        = "ssh"
    host        = var.linux_compute_private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  # With provisioned disk, trigger fdisk, then pvcreate and vgcreate to tag the disk
  provisioner "remote-exec" {
    inline = [
      "set +x",
      "export DEVICE_ID=/dev/disk/by-path/ip-${var.volume_attachment[count.index].ipv4}:${var.volume_attachment[count.index].port}-iscsi-${var.volume_attachment[count.index].iqn}-lun-1",
      "${local.pvcreate} $${DEVICE_ID}-part1",
    ]
  }
}

resource "null_resource" "vgcreate_exec" {
  depends_on = [null_resource.pvcreate_exec]
  count      = length(var.volume_attachment)
  connection {
    type        = "ssh"
    host        = var.linux_compute_private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  # With provisioned disk, trigger fdisk, then pvcreate and vgcreate to tag the disk
  provisioner "remote-exec" {
    inline = [
      "set +x",
      "export DEVICE_ID=/dev/disk/by-path/ip-${var.volume_attachment[count.index].ipv4}:${var.volume_attachment[count.index].port}-iscsi-${var.volume_attachment[count.index].iqn}-lun-1",
      "${local.vgcreate} ${var.provisioning_display_name}_${count.index} $${DEVICE_ID}-part1",
    ]
  }
}


/* resource "null_resource" "disk_mount_exec" {
depends_on = [null_resource.vgcreate_exec]
count = length(var.volume_attachment)
  connection {
    type        = "ssh"
    host        = var.linux_compute_private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  # With provisioned disk, performs the mounting of the corresponding disk
  provisioner "remote-exec" {
    inline = [
      
    ]
  }
} */

