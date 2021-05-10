# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: additional_linux_host.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.14
# Revision...: 
# Purpose....: Additional DB host specific terraform configuration, 
#              inlucding variables, resources, datasources and outputs.
# Notes......: --
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# - Variables
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: variables.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Variable file for the terraform module tvdlab compute.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

# provider identity parameters ----------------------------------------------
variable "tenancy_ocid" {
  description = "tenancy id where to create the resources"
  type        = string
}

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "The OCI region where resources will be created"
  type        = string
}

# general oci parameters ----------------------------------------------------
variable "compartment_id" {
  description = "OCID of the compartment where to create all resources"
  type        = string
}

variable "label_prefix" {
  description = "A string that will be prepended to all resources"
  type        = string
  default     = "none"
}

variable "resource_name" {
  description = "user-friendly string to name all resource. If undefined it will be derived from compartment name. "
  type        = string
  default     = ""
}

variable "ad_index" {
  description = "The index of the availability domain. This is used to identify the availability_domain place the compute instances."
  default     = 1
  type        = number
}

variable "tags" {
  description = "A simple key-value pairs to tag the resources created"
  type        = map(any)
  default     = {}
}

# Host Parameter ----------------------------------------------------
variable "host_enabled" {
  description = "whether to create the compute instance or not."
  default     = true
  type        = bool
}

variable "host_name" {
  description = "Name portion of host"
  default     = "host"
  type        = string
}

variable "host_public_ip" {
  description = "whether to assigne a public IP or not."
  default     = false
  type        = bool
}

variable "host_private_ip" {
  description = "Private IP for host."
  default     = "10.0.1.6"
  type        = string
}

variable "host_image_id" {
  description = "Provide a custom image id for the host or leave as OEL (Oracle Enterprise Linux)."
  default     = "OEL"
  type        = string
}

variable "host_os" {
  description = "Base OS for the host."
  default     = "Oracle Linux"
  type        = string
}

variable "host_os_version" {
  description = "Define Base OS version for the host."
  default     = "7.8"
  type        = string
}

variable "hosts_file" {
  description = "path to a custom /etc/hosts which has to be appended"
  default     = ""
  type        = string
}

variable "yum_upgrade" {
  description = "Enable YUM upgrade during bootstrap / cloud-init"
  default     = true
  type        = bool
}

variable "host_shape" {
  description = "The shape of admin instance."
  default     = "VM.Standard.E3.Flex"
  type        = string
}

variable "host_ocpus" {
  description = "The ocpus for the shape."
  default     = 1
  type        = number
}

variable "host_memory_in_gbs" {
  description = "The memory in gbs for the shape."
  default     = 8
  type        = number
}

variable "host_boot_volume_size" {
  description = "Size of the boot volume."
  default     = 150
  type        = number
}

variable "host_volume_enabled" {
  description = "whether to create an additional volume or not."
  default     = false
  type        = bool
}

variable "host_volume_source" {
  description = "Source block volume to clone from."
  default     = ""
  type        = string
}

variable "host_volume_attachment_type" {
  description = "The type of volume."
  default     = "paravirtualized"
  type        = string
}

variable "host_volume_size" {
  description = "Size of the additional volume."
  default     = 256
  type        = number
}

variable "host_state" {
  description = "Whether the host should be either RUNNING or STOPPED state. "
  default     = "RUNNING"
}

variable "host_bootstrap" {
  description = "Bootstrap script."
  default     = ""
  type        = string
}

variable "host_subnet" {
  description = "List of subnets for the host hosts"
  type        = list(string)
}

variable "ssh_public_key" {
  description = "the content of the ssh public key used to access the host. set this or the ssh_public_key_path"
  default     = ""
  type        = string
}

variable "ssh_public_key_path" {
  description = "path to the ssh public key used to access the host. set this or the ssh_public_key"
  default     = ""
  type        = string
}

# Trivadis LAB specific parameter -------------------------------------------
variable "tvd_participants" {
  description = "The number of VCN to create"
  type        = number
  default     = 1
}

variable "tvd_domain" {
  description = "The domain name of the LAB environment"
  type        = string
  default     = "trivadislabs.com"
}
# --- EOF -------------------------------------------------------------------


locals {
  linux_host_state = var.tvd_training_state == "" ? var.linux_host_state : var.tvd_training_state
}

# ---------------------------------------------------------------------------
# - Bootstrap
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# - Resources / module
# ---------------------------------------------------------------------------
# - ADD DB Module -----------------------------------------------------------
module "tvdlab-linux-host" {
  source  = "Trivadis/tvdlab-compute/oci"
  version = ">= 1.0.0"

  # - Mandatory Parameters --------------------------------------------------
  tenancy_ocid   = var.tenancy_ocid
  region         = var.region
  compartment_id = local.compartment_id
  # either ssh_public_key or ssh_public_key_path must be specified
  ssh_public_key      = var.ssh_public_key
  ssh_public_key_path = var.ssh_public_key_path
  host_subnet         = module.tvdlab-base.private_subnet_id

  # - Optional Parameters ---------------------------------------------------
  # general oci parameters
  ad_index     = var.ad_index
  label_prefix = var.label_prefix
  tags         = var.tags

  # Lab Configuration
  resource_name    = var.resource_name
  tvd_domain       = var.tvd_domain
  tvd_participants = var.tvd_participants

  # host parameters
  host_enabled                = var.linux_host_enabled
  host_name                   = var.linux_host_name
  host_image_id               = var.linux_host_image_id
  host_shape                  = var.linux_host_shape
  host_ocpus                  = var.host_ocpus
  host_memory_in_gbs          = var.host_memory_in_gbs
  host_bootstrap              = var.linux_host_bootstrap
  host_state                  = local.linux_host_state
  host_public_ip              = var.linux_host_public_ip
  host_private_ip             = var.linux_host_private_ip
  host_os                     = var.linux_host_os
  host_os_version             = var.linux_host_os_version
  host_boot_volume_size       = var.linux_host_boot_volume_size
  host_volume_enabled         = var.linux_volume_enabled
  host_volume_source          = var.linux_volume_source
  host_volume_attachment_type = var.linux_volume_attachment_type
  host_volume_size            = var.linux_volume_size
}
# ---------------------------------------------------------------------------
# - Outputs
# ---------------------------------------------------------------------------
output "linux_host_id" {
  description = "OCID of the server instances."
  value       = module.tvdlab-db2.host_id
}

output "linux_host_name" {
  description = "The hostname for VNIC's primary private IP of the server instances."
  value       = module.tvdlab-db2.host_name
}

output "linux_host_private_ip" {
  description = "The private IP address of the server instances."
  value       = module.tvdlab-db2.host_private_ip
}
# --- EOF -------------------------------------------------------------------
