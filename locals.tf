# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: locals.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Local variables for the terraform module tvdlab vcn.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

locals {
  availability_domain     = data.oci_identity_availability_domains.ad_list.availability_domains[var.ad_index - 1].name
  resource_name           = var.resource_name == "" ? data.oci_identity_compartment.compartment.name : var.resource_name
  resource_shortname      = lower(replace(local.resource_name, "-", ""))
  host_image_id           = var.host_image_id == "CENTOS" || var.host_image_id == "OEL" || var.host_image_id == "WIN" ? data.oci_core_images.oracle_images.images.0.id : var.host_image_id
  hosts_file              = var.hosts_file == "" ? "${path.module}/etc/hosts.template" : var.hosts_file
  ssh_public_key_path     = var.ssh_public_key_path == "" ? "${path.module}/etc/authorized_keys.template" : var.ssh_public_key_path
  host_bootstrap_template = var.host_os == "Windows" ? "${path.module}/cloudinit/windows_host.yaml" : "${path.module}/cloudinit/linux_host.yaml" 
  #default_private_dns = cidrhost(cidrsubnet(var.vcn_cidr, var.private_newbits, var.private_netnum), var.tvd_dns_hostnum)
  #vcn_cidr            = data.oci_core_vcn.vcn.cidr_block
}
# --- EOF -------------------------------------------------------------------
