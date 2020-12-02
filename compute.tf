# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: compute.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Compute Instance for the terraform module tvdlab compute.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

resource "oci_core_instance" "compute" {
  count               = var.host_enabled == true ? var.tvd_participants : 0
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.label_prefix == "none" ? format("${local.resource_shortname}-${var.host_name}%02d", count.index) : format("${var.label_prefix}-${local.resource_shortname}-${var.host_name}%02d", count.index)
  shape               = var.host_shape
  state               = var.host_state
  freeform_tags       = var.tags

  create_vnic_details {
    subnet_id        = var.host_subnet[count.index]
    assign_public_ip = var.host_public_ip
    private_ip       = var.host_private_ip
    display_name     = var.label_prefix == "none" ? "vnic" : "${var.label_prefix}-vnic"
    hostname_label   = var.host_name
  }

  # prevent the host from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key != "" ? var.ssh_public_key : file(var.ssh_public_key_path)
    user_data           = var.host_bootstrap != "" ? var.host_bootstrap : base64encode(templatefile(local.host_bootstrap_template, {
      yum_upgrade             = var.yum_upgrade
      authorized_keys         = base64gzip(file(local.ssh_public_key_path))
      etc_hosts               = base64gzip(file(local.hosts_file))
      bootstrap_windows_host  = base64gzip(file(local.bootstrap_windows_host))
      bootstrap_linux_host    = base64gzip(file(local.bootstrap_linux_host))
    })
  }

  source_details {
    source_type             = "image"
    source_id               = local.host_image_id
    boot_volume_size_in_gbs = var.host_boot_volume_size
  }

  timeouts {
    create = "60m"
  }
}
# --- EOF -------------------------------------------------------------------