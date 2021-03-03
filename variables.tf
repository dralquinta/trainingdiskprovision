/* lnx7_variables.tf
Author: Denny Alquinta – denny.alquinta@oracle.com
Purpose: Defines all variables used in project
Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved. */

variable "ssh_private_is_path" {
  default = false
}

variable "ssh_private_key" {
  description = "Defines the SSH private key to be used in order to remotely connect to compute instance"
  type        = string 
}

variable "provisioning_display_name" {
  description = "Provisioning display name"
}

variable "volume_attachment" {
  description = "List of OCI atachment disks"
}

variable "linux_compute_private_ip" {
  description = "Private Ip for connection"
}

variable "fdisk" {
  description = "Placeholder for fdisk execution"
  default     = ""
}

variable "pvcreate" {
  description = "Placeholder for pvcreate execution"
  default     = ""
}

variable "vgcreate" {
  description = "Placeholder for vgcreate"
  default     = ""
}

variable "iscsiadm" {
  description = "Placeholder for iscsiadm command"
  default     = ""
}

variable "is_linux_5" {
  description = "Describes if disks are to be mounted and chopped on linux5 instance or not"
  default     = false
}


