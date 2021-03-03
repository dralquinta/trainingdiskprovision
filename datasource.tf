/* datasources.tf 
Author: DALQUINT - denny.alquinta@oracle.com
Purpose: The following script defines the lookup logic used in code to obtain pre-created resources in tenancy.
Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved. 
*/

locals {
  iscsiadm = var.is_linux_5 ? "sudo /sbin/iscsiadm" : "sudo iscsiadm"
  fdisk    = var.is_linux_5 ? "(echo n; echo p; echo '1'; echo ''; echo ''; echo 't';echo '8e'; echo w) | sudo /sbin/fdisk " : "(echo n; echo p; echo '1'; echo ''; echo ''; echo 't';echo '8e'; echo w) | sudo /sbin/fdisk "
  pvcreate = var.is_linux_5 ? "sudo /usr/sbin/pvcreate" : "sudo /sbin/pvcreate"
  vgcreate = var.is_linux_5 ? "sudo /usr/sbin/vgcreate" : "sudo /sbin/vgcreate"
}