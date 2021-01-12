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
variable "linux_host_enabled" {
  description = "whether to create the compute instance or not."
  default     = false
  type        = bool
}

variable "linux_host_name" {
  description = "Name portion of host"
  default     = "linux"
  type        = string
}

variable "linux_host_public_ip" {
  description = "whether to assigne a public IP or not."
  default     = false
  type        = bool
}

variable "linux_host_private_ip" {
  description = "Private IP for host."
  default     = "10.0.1.7"
  type        = string
}

variable "linux_host_image_id" {
  description = "Provide a custom image id for the host or leave as OEL (Oracle Enterprise Linux)."
  default     = "OEL"
  type        = string
}

variable "linux_host_os" {
  description = "Base OS for Linux based OS."
  default     = "Oracle Linux"
  type        = string
}

variable "linux_host_os_version" {
  description = "Define the default OS version for Oracle Linux."
  default     = "7.8"
  type        = string
}

variable "linux_host_shape" {
  description = "The shape of compute instance."
  default     = "VM.Standard2.2"
  type        = string
}

variable "linux_host_boot_volume_size" {
  description = "Size of the boot volume."
  default     = 150
  type        = number
}

variable "linux_volume_enabled" {
  description = "whether to create an additional volume or not."
  default     = false
  type        = bool
}

variable "linux_volume_attachment_type" {
  description = "The type of volume."
  default     = "paravirtualized"
  type        = string
}

variable "linux_volume_size" {
  description = "Size of the additional volume."
  default     = 256
  type        = number
}

variable "linux_host_state" {
  description = "Whether the host should be either RUNNING or STOPPED state. "
  default     = "RUNNING"
}

variable "linux_host_bootstrap" {
  description = "Bootstrap script."
  default     = ""
  type        = string
}

locals {
  linux_host_state  = var.tvd_training_state == "" ? var.linux_host_state : var.tvd_training_state
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
  tenancy_ocid          = var.tenancy_ocid
  region                = var.region
  compartment_id        = local.compartment_id
  # either ssh_public_key or ssh_public_key_path must be specified
  ssh_public_key        = var.ssh_public_key
  ssh_public_key_path   = var.ssh_public_key_path
  host_subnet           = module.tvdlab-base.private_subnet_id

  # - Optional Parameters ---------------------------------------------------
  # general oci parameters
  ad_index              = var.ad_index
  label_prefix          = var.label_prefix
  tags                  = var.tags

  # Lab Configuration
  resource_name         = var.resource_name
  tvd_domain            = var.tvd_domain
  tvd_participants      = var.tvd_participants

  # host parameters
  host_enabled          = var.linux_host_enabled
  host_name             = var.linux_host_name
  host_image_id         = var.linux_host_image_id
  host_shape            = var.linux_host_shape
  host_bootstrap        = var.linux_host_bootstrap
  host_state            = local.linux_host_state
  host_public_ip        = var.linux_host_public_ip
  host_private_ip       = var.linux_host_private_ip
  host_os               = var.linux_host_os
  host_os_version       = var.linux_host_os_version
  host_boot_volume_size = var.linux_host_boot_volume_size
  host_volume_enabled   = var.linux_volume_enabled
  host_volume_attachment_type = var.linux_volume_attachment_type
  host_volume_size      = var.linux_volume_size
}
# ---------------------------------------------------------------------------
# - Outputs
# ---------------------------------------------------------------------------
output "linux_host_id" {
  description = "OCID of the server instances."
  value = module.tvdlab-db2.host_id
}

output "linux_host_name" {
  description = "The hostname for VNIC's primary private IP of the server instances."
  value = module.tvdlab-db2.host_name
}

output "linux_host_private_ip" {
  description = "The private IP address of the server instances."
  value = module.tvdlab-db2.host_private_ip
}
# --- EOF -------------------------------------------------------------------
